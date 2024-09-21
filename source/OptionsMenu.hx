package;

// IMPORTAR LIBRERIAS - IMPORT LIBRARIES
#if desktop
	import Discord.DiscordClient; // Importa las librerias de cliente de discord, (solo para escritorios) - Import the discord client libraries, (only for desktops)
#end
import Controls.Control; // Importa los controles del juego
import flash.text.TextField; // Importa la clase TextField de Flash
import flixel.FlxG; // Importa la clase FlxG de Flixel
import flixel.FlxSprite; // Importa FlxSprite de Flixel
import flixel.addons.display.FlxGridOverlay; // Importa FlxGridOverlay de los addons de Flixel
import flixel.addons.transition.FlxTransitionableState; // Importa FlxTransitionableState de los addons de Flixel
import flixel.group.FlxGroup.FlxTypedGroup; // Importa FlxTypedGroup de Flixel
import flixel.input.keyboard.FlxKey; // Importa FlxKey de Flixel
import flixel.math.FlxMath;  // Importa FlxMath de Flixel
import flixel.text.FlxText; // Importa FlxText de Flixel
import flixel.util.FlxColor; // Importa FlxColor de Flixel
import flixel.util.FlxTimer; // Importa FlxTimer de Flixel
import lime.utils.Assets;  //Importa Assets de Lime
import openfl.Lib; //Importa Lib de OpenFL
import haxe.Json; //Importa Json de Haxe
import haxe.format.JsonParser; //Importa JsonParser de Haxe
using StringTools; // Utiliza las herramientas de cadenas

class OptionsMenu extends MusicBeatState {
	

	// Keybind Setting -- - Configuracion de teclas
	var checkingKey:Bool = false;
	var isAltKey:Bool = false;
	var isSettingControl:Bool = false;
	var keybindToReplace:String = null;
	var keybindAlphaScreen:FlxSprite = null;
	var keybindAlphaText:FlxText = null;
	// -- Keybind Setting - Configuracion de teclas

	// FPS --
	var fpsExtraText:String = "- Press LEFT/RIGHT to change the value by 5 (hold SHIFT to change it by 1). Press E/R to change tabs. Press ENTER to change options.";
	var FpsThing:FlxText; //Muestra los FPS 
	var FpsBGThing:FlxSprite; // Sprites de fondo de los FPS
	var fpsWebExtraText:String = "Press E/R to change tabs. Press ENTER to change options.";
	// -- FPS

	// Tabs and Settings -- - Pestañas y configuraciones
	var curSelected:Int = 0;
	var curTab:Int = 0;
	var grpControls:FlxTypedGroup<FlxText>;
	var grpControlsBools:FlxTypedGroup<FlxText>;
	var grpControlsTabs:FlxTypedGroup<FlxText>;
	var settingsBools:Array<String> = [];
	var settingsStuff:Array<String> = [];
	var settingsTabs:Array<String> = [];
	// -- Tabs and Settings - Pestañas y configuraciones

	// Themes -- - Temas
	var ThemeBGThing:FlxSprite;
	var ThemeThing:FlxText;
	// -- Themes - Temas (TXT and/y BG)

	override function create() {
		Options.loadOptions(); // Carga las opciones 

		settingsTabs.push("Gameplay"); // Agrega 'Gameplay a la pestaña de configuración
		#if desktop
			// This will be back on web later. - Esto volverá a estar en la web más tarde.
			settingsTabs.push("User Experience"); // Agrega "User Experience" a las pestañas de configuración para escritorio
		#end
		settingsTabs.push("Keybinds");// Agrega 'KeyBinds' a las pestañas de configuración

		//Configuracion del fondo de menú
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		menuBG.color = FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255));
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		//Configuracón del fondo Gris del menú
		var menuGray:FlxSprite = new FlxSprite(30, 60).makeGraphic(1220, 600, FlxColor.BLACK);
		menuGray.alpha = 0.5;
		menuGray.scrollFactor.set();
		add(menuGray);

		//Configuracion del divisor de pestañas
		var tabDividerSprite:FlxSprite = new FlxSprite(30, 112).makeGraphic(1220, 5, FlxColor.BLACK);
		tabDividerSprite.scrollFactor.set();
		add(tabDividerSprite);

		//Configuración de la pantalla de "Configuración de teclas"
		keybindAlphaScreen = new FlxSprite(-600,-600).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		keybindAlphaScreen.visible = false;
		keybindAlphaScreen.alpha = 0.5;
		keybindAlphaScreen.scrollFactor.set();
		add(keybindAlphaScreen);

		keybindAlphaText = new FlxText(0, 0, 0, "");
		keybindAlphaText.visible = false;
		keybindAlphaText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		keybindAlphaText.scrollFactor.set();
		add(keybindAlphaText);

		//Inicialización de Grupo de controles
		grpControls = new FlxTypedGroup<FlxText>();
		add(grpControls);
		grpControlsBools = new FlxTypedGroup<FlxText>();
		add(grpControlsBools);
		grpControlsTabs = new FlxTypedGroup<FlxText>();
		add(grpControlsTabs);

		setupGameplayTab();//Configura la pestaña de juego

		//Configuracion de pestañas de controles
		for (i in 0...settingsTabs.length) {
			var Text:FlxText = new FlxText(50, 70, 0, settingsTabs[i]);
			Text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			Text.borderSize = 1.25;
			if(i != 0) {
				Text.x = grpControlsTabs.members[i - 1].x + grpControlsTabs.members[i - 1].width + 32;
				Text.alpha = 0.6;
			}
			grpControlsTabs.add(Text);
		}

		//Configuración del fondo de los FPS
		FpsBGThing = new FlxSprite(0, (FlxG.height * 0.9) + 50).makeGraphic(FlxG.width, Std.int((FlxG.height * 0.9) - 50), FlxColor.BLACK);
		FpsBGThing.alpha = 0.5;
		FpsBGThing.scrollFactor.set();
		add(FpsBGThing);

		//Configuración del texto de los FPS
		FpsThing = new FlxText(5, (FlxG.height * 0.9) + 50, 0, "", 12);
		#if desktop
			FpsThing.text = 'FPS: ${Options.FPS} $fpsExtraText';
		#else
			FpsThing.text = fpsWebExtraText;
		#end
		FpsThing.scrollFactor.set();
		FpsThing.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(FpsThing);

		//Configuración del fondo de tema
		ThemeBGThing = new FlxSprite(0, 0).makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		ThemeBGThing.alpha = 0.5;
		ThemeBGThing.scrollFactor.set();
		add(ThemeBGThing);

		transIn = FlxTransitionableState.defaultTransIn; //Transición de entrada por defecto
		transOut = FlxTransitionableState.defaultTransOut; //Transición de salida por defecto

		super.create();//Llama a la función de creare del padre
	}

	//Función para cambiar la Seccion de controles dentro del juego
	function changeSelection(change:Int = 0) {
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);//sonido que se reproduce al cambiar alguna opción al momento de estar en el menú

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
	//Función para cambiar la pestaña actual
	function changeTab(tabChoice:Int) {
		curTab += tabChoice;

		if(curTab < 0)
			curTab = grpControlsTabs.length - 1;
		if(curTab >= grpControlsTabs.length)
			curTab = 0;

		for(i in 0...grpControlsTabs.length) {
			if(i != curTab)
				grpControlsTabs.members[i].alpha = 0.6;
			else
				grpControlsTabs.members[i].alpha = 1;
		}

		switch(curTab) {
			case 0:
				setupGameplayTab();
			#if desktop
				case 1:
					setupUETab();
				case 2:
					setupKBTab();
			#else
				case 1:
					setupKBTab();
			#end
			default:
				setupGameplayTab();
		}
	}

	// Función para configurar la pestaña de controles de juego
	function setupGameplayTab() {
		grpControls.clear();
		grpControlsBools.clear();
		untyped settingsStuff.length = 0;
		untyped settingsBools.length = 0;
		curSelected = 0;

		settingsStuff.push("Downscroll");
		settingsBools.push((Options.downscroll ? "< ON >" : "< OFF >"));
		settingsStuff.push("Middlescroll");
		settingsBools.push((Options.middlescroll ? "< ON >" : "< OFF >"));
		settingsStuff.push("Ghost Tapping");
		settingsBools.push((Options.ghostTapping ? "< ON >" : "< OFF >"));

		for (i in 0...settingsBools.length) {
			var Text:FlxText = new FlxText(FlxG.width - 40, 122 + (32 * i), 0, settingsBools[i]);
			Text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			Text.borderSize = 1.25;
			Text.x = Text.x - Text.width;
			if(i != 0)
				Text.alpha = 0.6;
			grpControlsBools.add(Text);
		}

		for (i in 0...settingsStuff.length) {
			var Text:FlxText = new FlxText(40, 122 + (32 * i), 0, settingsStuff[i]);
			Text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			Text.borderSize = 1.25;
			if(i != 0)
				Text.alpha = 0.6;
			grpControls.add(Text);
		}
	}

	function setupKBTab() {
		grpControls.clear();
		grpControlsBools.clear();
		untyped settingsStuff.length = 0;
		untyped settingsBools.length = 0;
		curSelected = 0;

		settingsStuff.push("Left");
		settingsBools.push("< " + Options.keybindMap.get("LEFT")[0].toString() + " >");
		settingsStuff.push("Left (Alt)");
		settingsBools.push("< " + Options.keybindMap.get("LEFT")[1].toString() + " >");
		settingsStuff.push("Down");
		settingsBools.push("< " + Options.keybindMap.get("DOWN")[0].toString() + " >");
		settingsStuff.push("Down (Alt)");
		settingsBools.push("< " + Options.keybindMap.get("DOWN")[1].toString() + " >");
		settingsStuff.push("Up");
		settingsBools.push("< " + Options.keybindMap.get("UP")[0].toString() + " >");
		settingsStuff.push("Up (Alt)");
		settingsBools.push("< " + Options.keybindMap.get("UP")[1].toString() + " >");
		settingsStuff.push("Right");
		settingsBools.push("< " + Options.keybindMap.get("RIGHT")[0].toString() + " >");
		settingsStuff.push("Right (Alt)");
		settingsBools.push("< " + Options.keybindMap.get("RIGHT")[1].toString() + " >");

		for (i in 0...settingsBools.length) {
			var Text:FlxText = new FlxText(FlxG.width - 40, 122 + (32 * i), 0, settingsBools[i]);
			Text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			Text.borderSize = 1.25;
			Text.x = Text.x - Text.width;
			if(i != 0)
				Text.alpha = 0.6;
			grpControlsBools.add(Text);
		}

		for (i in 0...settingsStuff.length) {
			var Text:FlxText = new FlxText(40, 122 + (32 * i), 0, settingsStuff[i]);
			Text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			Text.borderSize = 1.25;
			if(i != 0)
				Text.alpha = 0.6;
			grpControls.add(Text);
		}
	}

	function setupUETab() {
		grpControls.clear();
		grpControlsBools.clear();
		untyped settingsStuff.length = 0;
		untyped settingsBools.length = 0;
		curSelected = 0;

		#if desktop
			settingsStuff.push("Discord Rich Presence");
			settingsBools.push((Options.enableRPC ? "< ON >" : "< OFF >"));
		#end

		for (i in 0...settingsBools.length) {
			var Text:FlxText = new FlxText(FlxG.width - 40, 122 + (32 * i), 0, settingsBools[i]);
			Text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			Text.borderSize = 1.25;
			Text.x = Text.x - Text.width;
			if(i != 0)
				Text.alpha = 0.6;
			grpControlsBools.add(Text);
		}

		for (i in 0...settingsStuff.length) {
			var Text:FlxText = new FlxText(40, 122 + (32 * i), 0, settingsStuff[i]);
			Text.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			Text.borderSize = 1.25;
			if(i != 0)
				Text.alpha = 0.6;
			grpControls.add(Text);
		}
	}

	override function update(elapsed:Float) {
		super.update(elapsed); // Llama a la función update del padre
	
		if(!checkingKey) {
			if (controls.BACK) { // al salir de la escena OptionsMenu
				Options.saveOptions(); // Guarda las opciones
				Options.reloadControls(); // Carga los controles cambiados
				FlxG.switchState(new MainMenuState()); // Vuelve a la escena de MainMenuState
			}
	
			if (controls.UP_P)
				changeSelection(-1); // Cambia la pestaña hacia atrás
	
			if (controls.DOWN_P)
				changeSelection(1); // Cambia la pestaña hacia adelante
	
			if (controls.ACCEPT) {
				switch(curTab) {
					case 0: // Pestaña 0 - Opciones booleanas
						switch(curSelected) {
							case 0:
								Options.downscroll = !Options.downscroll; // Cambia la opción downscroll
								Options.saveOptions(); // Guarda las opciones
								grpControlsBools.members[curSelected].text = (Options.downscroll ? "< ON >" : "< OFF >"); // Actualiza el texto en el menú
								grpControlsBools.members[curSelected].x = FlxG.width - grpControlsBools.members[curSelected].width - 40; // Actualiza la posición del texto
							case 1:
								Options.middlescroll = !Options.middlescroll; // Cambia la opción middlescroll
								Options.saveOptions(); // Guarda las opciones
								grpControlsBools.members[curSelected].text = (Options.middlescroll ? "< ON >" : "< OFF >"); // Actualiza el texto en el menú
								grpControlsBools.members[curSelected].x = FlxG.width - grpControlsBools.members[curSelected].width - 40; // Actualiza la posición del texto
							case 2:
								Options.ghostTapping = !Options.ghostTapping; // Cambia la opción ghostTapping
								Options.saveOptions(); // Guarda las opciones
								grpControlsBools.members[curSelected].text = (Options.ghostTapping ? "< ON >" : "< OFF >"); // Actualiza el texto en el menú
								grpControlsBools.members[curSelected].x = FlxG.width - grpControlsBools.members[curSelected].width - 40; // Actualiza la posición del texto
						}
					#if desktop // Solo en desktop
						case 1: // Pestaña 1 - Opciones de Discord RPC
							switch(curSelected) {
								case 0:
									Options.enableRPC = !Options.enableRPC; // Cambia la opción enableRPC
									if(Options.enableRPC) { 
										if(!DiscordClient.initialized)
											DiscordClient.initialize(); // Inicializa Discord si no está inicializado
									} else {
										if(DiscordClient.initialized)
											DiscordClient.shutdown(); // Cierra Discord si está inicializado
									}
									Options.saveOptions(); // Guarda las opciones
									grpControlsBools.members[curSelected].text = (Options.enableRPC ? "< ON >" : "< OFF >"); // Actualiza el texto en el menú
									grpControlsBools.members[curSelected].x = FlxG.width - grpControlsBools.members[curSelected].width - 40; // Actualiza la posición del texto
							}
						case 2: // Pestaña 2 - Configuración de teclas
							switch(curSelected) {
								case 0:
									checkingKey = true; // Indica que se está esperando una tecla
									keybindToReplace = "LEFT"; // Configura la tecla para reemplazar
									isAltKey = false; // Indica que no es una tecla alternativa
								case 1:
									checkingKey = true; 
									keybindToReplace = "LEFT"; 
									isAltKey = true; // Indica que es una tecla alternativa
								case 2:
									checkingKey = true; 
									keybindToReplace = "DOWN"; 
									isAltKey = false; 
								case 3:
									checkingKey = true; 
									keybindToReplace = "DOWN"; 
									isAltKey = true; 
								case 4:
									checkingKey = true; 
									keybindToReplace = "UP"; 
									isAltKey = false; 
								case 5:
									checkingKey = true; 
									keybindToReplace = "UP"; 
									isAltKey = true; 
								case 6:
									checkingKey = true; 
									keybindToReplace = "RIGHT"; 
									isAltKey = false; 
								case 7:
									checkingKey = true; 
									keybindToReplace = "RIGHT"; 
									isAltKey = true; 
							}
					#else // No desktop
						case 1: // Configuración de teclas
							switch(curSelected) {
								case 0:
									checkingKey = true; 
									keybindToReplace = "LEFT"; 
									isAltKey = false; 
								case 1:
									checkingKey = true; 
									keybindToReplace = "LEFT"; 
									isAltKey = true; 
								case 2:
									checkingKey = true; 
									keybindToReplace = "DOWN"; 
									isAltKey = false; 
								case 3:
									checkingKey = true; 
									keybindToReplace = "DOWN"; 
									isAltKey = true; 
								case 4:
									checkingKey = true; 
									keybindToReplace = "UP"; 
									isAltKey = false; 
								case 5:
									checkingKey = true; 
									keybindToReplace = "UP"; 
									isAltKey = true; 
								case 6:
									checkingKey = true; 
									keybindToReplace = "RIGHT"; 
									isAltKey = false; 
								case 7:
									checkingKey = true; 
									keybindToReplace = "RIGHT"; 
									isAltKey = true; 
							}
					#end
				}
			}
	
			if(FlxG.keys.justPressed.E)
				changeTab(-1); // Cambia la pestaña hacia atrás
	
			if(FlxG.keys.justPressed.R)
				changeTab(1); // Cambia la pestaña hacia adelante
	
			#if desktop
				if(FlxG.keys.justPressed.LEFT) {
					if(FlxG.keys.pressed.SHIFT)
						Options.FPS -= 1; // Disminuye FPS en 1 si SHIFT está presionado
					else
						Options.FPS -= 5; // Disminuye FPS en 5 si SHIFT no está presionado
	
					if(Options.FPS < 60)
						Options.FPS = 60; // Asegura que los FPS no bajen de 60
	
					Options.saveOptions(); // Guarda las opciones
					FpsThing.text = 'FPS: ${Options.FPS} $fpsExtraText'; // Actualiza el texto de FPS
					if(Options.FPS > FlxG.drawFramerate) {
						FlxG.updateFramerate = Options.FPS;
						FlxG.drawFramerate = Options.FPS;
					} else {
						FlxG.drawFramerate = Options.FPS;
						FlxG.updateFramerate = Options.FPS;
					}
				}
				if(FlxG.keys.justPressed.RIGHT) {
					if(FlxG.keys.pressed.SHIFT)
						Options.FPS += 1; // Aumenta FPS en 1 si SHIFT está presionado
					else
						Options.FPS += 5; // Aumenta FPS en 5 si SHIFT no está presionado
	
					if(Options.FPS > 450)
						Options.FPS = 450; // Asegura que los FPS no superen 450
	
					Options.saveOptions(); // Guarda las opciones
					FpsThing.text = 'FPS: ${Options.FPS} $fpsExtraText'; // Actualiza el texto de FPS
					if(Options.FPS > FlxG.drawFramerate) {
						FlxG.updateFramerate = Options.FPS;
						FlxG.drawFramerate = Options.FPS;
					} else {
						FlxG.drawFramerate = Options.FPS;
						FlxG.updateFramerate = Options.FPS;
					}
				}
			#end
		} else {
			keybindAlphaScreen.visible = true; // Muestra la pantalla de configuración de teclas
			keybindAlphaText.text = "Setting keybind for " + grpControls.members[curSelected].text; // Muestra el texto de configuración de teclas
			keybindAlphaText.screenCenter(); // Centra el texto en la pantalla
			keybindAlphaText.visible = true; // Hace visible el texto
			var funnyKey:Int = FlxG.keys.firstJustPressed(); // Espera a que se presione una tecla
			if(funnyKey > -1) {
				var theArray:Array<FlxKey> = Options.keybindMap.get(keybindToReplace); // Obtiene el array de teclas para reemplazar
				theArray[isAltKey ? 1 : 0] = funnyKey; // Asigna la nueva tecla
				Options.keybindMap.set(keybindToReplace, theArray); // Guarda el nuevo mapa de teclas
				Options.saveOptions(); // Guarda las opciones
				Options.reloadControls(); // Recarga los controles
	
				grpControlsBools.members[curSelected].text = "< " + theArray[isAltKey ? 1 : 0].toString() + " >"; // Actualiza el texto en el menú
				grpControlsBools.members[curSelected].x = FlxG.width - grpControlsBools.members[curSelected].width - 40; // Actualiza la posición del texto
				checkingKey = false; // Indica que ya no se está esperando una tecla
				isAltKey = false; // Resetea la variable isAltKey
				keybindToReplace = null; // Resetea la variable keybindToReplace
				keybindAlphaScreen.visible = false; // Oculta la pantalla de configuración de teclas
				keybindAlphaText.visible = false; // Oculta el texto de configuración de teclas
			}
		}
	}
}
// Esto hizo Britex :v - made for Britex :v