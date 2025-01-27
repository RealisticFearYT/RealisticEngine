package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MenuEditorState extends MusicBeatState
{
    public static var curSelected:Int = 0;

    var engineVersion:FlxText;
	var vanillaVersion:FlxText;
    var informationMenu:FlxText;

    private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

    var credTextShit:Alphabet;

    override function create() 
    {   
    #if desktop
    // Updating Discord Rich Presence
    DiscordClient.changePresence("In the Editor Menu", null);
    #end

    var bgEditor:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
    bgEditor.color = FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
    bgEditor.setGraphicSize(Std.int(bgEditor.width * 1.1));
    bgEditor.updateHitbox();
    bgEditor.screenCenter();
    bgEditor.antialiasing = true;
    add(bgEditor);

    vanillaVersion = new FlxText(5, FlxG.height - 24, 0, "Friday Night Funkin v0.5.2", 12);
    vanillaVersion.scrollFactor.set();
    vanillaVersion.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(vanillaVersion);

    engineVersion = new FlxText(5, FlxG.height - 44, 0, 'Realistic Engine v${Application.current.meta.get('version')} SUPER CHRISTMAS UPDATE!', 12);
    engineVersion.scrollFactor.set();
    engineVersion.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(engineVersion);
    
    informationMenu = new FlxText(5, FlxG.height - 64, 0, "In the Menu Editor - NEW!", 12);
    informationMenu.scrollFactor.set();
    informationMenu.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
    add(informationMenu);
    }

    var selectedSomethin:Bool = false;

    override function update(elapsed:Float) {
    {
        if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(new MainMenuState());
			}
         }
      }
    }