package;

#if desktop
import Discord.DiscordClient;
#end
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;
import lime.utils.Assets;
import openfl.Lib;
import haxe.Json;
import haxe.format.JsonParser;
using StringTools;

class OptionsMenuState extends MusicBeatState {
    // Keybind Setting
    var checkingKey:Bool = false;
    var isAltKey:Bool = false;
    var isSettingControl:Bool = false;
    var keybindToReplace:String = null;
    var keybindAlphaScreen:FlxSprite = null;
    var keybindAlphaText:FlxText = null;

    // FPS --
    var fpsExtraText:String = "- Press LEFT/RIGHT to change the value by 5 (hold SHIFT to change it by 1). Press ENTER to change options.";
    var FpsThing:FlxText;
    var FpsBGThing:FlxSprite;

    // Options --
    var curSelected:Int = 0;
    var grpControls:FlxTypedGroup<FlxText>;
    var grpControlsBools:FlxTypedGroup<FlxText>;
    var settingsBools:Array<String> = [];
    var settingsStuff:Array<String> = [];
    var sections:Array<String> = ["GAMEPLAY", "USER EXPERIENCE", "KEYBINDS"];

    var optionsMusic:FlxSound;

    override function create() {
        Options.loadOptions();

        optionsMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		optionsMusic.volume = 0;
		optionsMusic.play(false, FlxG.random.int(0, Std.int(optionsMusic.length / 2)));

        // Background configuration
        var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
        menuBG.color = FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
        menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
        menuBG.updateHitbox();
        menuBG.screenCenter();
        menuBG.antialiasing = true;
        add(menuBG);

        var menuGray:FlxSprite = new FlxSprite(30, 60).makeGraphic(1220, 600, FlxColor.BLACK);
        menuGray.alpha = 0.5;
        menuGray.scrollFactor.set();
        add(menuGray);

        // Group setup
        grpControls = new FlxTypedGroup<FlxText>();
        add(grpControls);
        grpControlsBools = new FlxTypedGroup<FlxText>();
        add(grpControlsBools);

        setupOptions();

        // FPS setup
        FpsBGThing = new FlxSprite(0, (FlxG.height * 0.9) + 50).makeGraphic(FlxG.width, Std.int((FlxG.height * 0.9) - 50), FlxColor.BLACK);
        FpsBGThing.alpha = 0.5;
        FpsBGThing.scrollFactor.set();
        add(FpsBGThing);

        FpsThing = new FlxText(5, (FlxG.height * 0.9) + 50, 0, "", 12);
        #if desktop
            FpsThing.text = 'FPS: ${Options.FPS} $fpsExtraText';
        #else
            FpsThing.text = 'FPS: ${Options.FPS} $fpsExtraText';
        #end
        FpsThing.scrollFactor.set();
        FpsThing.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(FpsThing);

        super.create();
    }

    function setupOptions() {
        grpControls.clear();
        grpControlsBools.clear();
        untyped settingsStuff.length = 0;
        untyped settingsBools.length = 0;
        curSelected = 0;

        // Add settings
        settingsStuff.push("GAMEPLAY-----");
        settingsStuff.push("Downscroll");
        settingsBools.push((Options.downscroll ? "On" : "Off"));
        settingsStuff.push("Middlescroll");
        settingsBools.push((Options.middlescroll ? "On" : "Off"));
        settingsStuff.push("Ghost Tapping");
        settingsBools.push((Options.ghostTapping ? "On" : "Off"));

        settingsStuff.push("USER EXPERIENCE-----");
        #if desktop
            settingsStuff.push("Discord Rich Presence");
            settingsBools.push((Options.enableRPC ? "On" : "Off"));
        #end

        settingsStuff.push("KEYBINDS-----");
        settingsStuff.push("Left");
        settingsBools.push(Options.keybindMap.get("LEFT")[0].toString());
        settingsStuff.push("Down");
        settingsBools.push(Options.keybindMap.get("DOWN")[0].toString());
        settingsStuff.push("Up");
        settingsBools.push(Options.keybindMap.get("UP")[0].toString());
        settingsStuff.push("Right");
        settingsBools.push(Options.keybindMap.get("RIGHT")[0].toString());

        for (i in 0...settingsStuff.length) {
            var yPos = 122 + (32 * i);
            var text:FlxText = new FlxText(40, yPos, 0, settingsStuff[i]);
            if (sections.indexOf(settingsStuff[i].split("-----")[0]) != -1) {
                text.setFormat("VCR OSD Mono", 32, FlxColor.YELLOW, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            } else {
                text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                text.borderSize = 1.25;
                grpControls.add(text);

                var boolText:FlxText = new FlxText(FlxG.width - 40, yPos, 0, settingsBools.shift());
                boolText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
                boolText.borderSize = 1.25;
                boolText.x = boolText.x - boolText.width;
                grpControlsBools.add(boolText);
            }
            add(text);
        }
    }

    function changeSelection(change:Int = 0) {
        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += change;
        if (curSelected < 0)
            curSelected = grpControls.length - 1;
        if (curSelected >= grpControls.length)
            curSelected = 0;

        for (i in 0...grpControls.length) {
            grpControls.members[i].alpha = 0.6;
        }
        grpControls.members[curSelected].alpha = 1;

        for (i in 0...grpControlsBools.length) {
            grpControlsBools.members[i].alpha = 0.6;
        }
        grpControlsBools.members[curSelected].alpha = 1;
    }

    override function update(elapsed:Float) {
        super.update(elapsed);
        if (!checkingKey) {
            if (controls.BACK) {
                Options.saveOptions();
                Options.reloadControls();
                FlxG.switchState(new MainMenuState());
            }

            if (controls.UP_P)
                changeSelection(-1);

            if (controls.DOWN_P)
                changeSelection(1);

            if (controls.ACCEPT) {
                switch(curSelected) {
                    case 0:
                        Options.downscroll = !Options.downscroll;
                        grpControlsBools.members[0].text = (Options.downscroll ? "On" : "Off");
                    case 1:
                        Options.middlescroll = !Options.middlescroll;
                        grpControlsBools.members[1].text = (Options.middlescroll ? "On" : "Off");
                    case 2:
                        Options.ghostTapping = !Options.ghostTapping;
                        grpControlsBools.members[2].text = (Options.ghostTapping ? "On" : "Off");
                    #if desktop
                        case 3:
                            Options.enableRPC = !Options.enableRPC;
                            grpControlsBools.members[3].text = (Options.enableRPC ? "On" : "Off");
                    #end
                }
            }
        }
    }
}