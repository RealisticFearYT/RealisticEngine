package;
//importaciones de paquetes
import Controls.KeyboardScheme;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;

class Options {
	// Volumen Maestro (Anterior) - Master Volume (Previous)
	public static var masterVolume:Float = 1;
	// Nuevas Opciones - New Options
	public static var downscroll:Bool = false;
	public static var enableRPC:Bool = true;
	public static var FPS:Int = 60;
	public static var ghostTapping:Bool = false;
	public static var keybindMap:Map<String, Array<FlxKey>> = new Map<String, Array<FlxKey>>();
	public static var middlescroll:Bool = false;

	//Teclas predeterminadas - Default Keys
	static var defaultKeybinds:Map<String, Array<FlxKey>> = [
		"UP" => [W, FlxKey.UP],
		"DOWN" => [S, FlxKey.DOWN],
		"LEFT" => [A, FlxKey.LEFT],
		"RIGHT" => [D, FlxKey.RIGHT],
	];


	//Revisar los controles guardados - Review saved controls
	public static function checkControls() {
		if(FlxG.save.data.keybinds != null)
			keybindMap = FlxG.save.data.keybinds;
		else
			keybindMap = defaultKeybinds.copy();
	}

	//Carga las Opciones guardadas - Load saved options
	public static function loadOptions() {
		// Downscroll
		if(FlxG.save.data.useDS != null)
			downscroll = FlxG.save.data.useDS;
		else
			downscroll = false;

		//Habilitar Discord RPC - Enable Discord RPC
		if(FlxG.save.data.enableRPC != null)
			enableRPC = FlxG.save.data.enableRPC;
		else
			enableRPC = true;

		// FPS
		if(FlxG.save.data.FPS != null) {
			FPS = FlxG.save.data.FPS;
			// Ajusta el framerate de acuerdo a la opcion gaurdada - Adjust the framerate according to the saved option
			if(FPS > FlxG.drawFramerate) {
				FlxG.updateFramerate = FPS;
				FlxG.drawFramerate = FPS;
			} else {
				FlxG.drawFramerate = FPS;
				FlxG.updateFramerate = FPS;
			}
		}

		// Ghost Tapping
		if(FlxG.save.data.ghostTapping != null)
			ghostTapping = FlxG.save.data.ghostTapping;
		else
			ghostTapping = false;

		// Middlescroll
		if(FlxG.save.data.useMS != null)
			middlescroll = FlxG.save.data.useMS;
		else
			middlescroll = false;

		// Keybinds
		if(FlxG.save.data.keybinds != null)
			keybindMap = FlxG.save.data.keybinds;
		else
			keybindMap = defaultKeybinds.copy();

		// Configura el esquema de teclado del jugador 1 - Set the keyboard layout for player 1
		PlayerSettings.player1.setKeyboardScheme(KeyboardScheme.Solo);
	}
	//Recarga los controles en caso de ser necesario - Reload controls if necessary
	public static function reloadControls() {
		PlayerSettings.player1.setKeyboardScheme(KeyboardScheme.Solo);
	}

	//Guarda las Opciones actuales - Save current options
	public static function saveOptions() {
		FlxG.save.data.useDS = downscroll;
		FlxG.save.data.enableRPC = enableRPC;
		FlxG.save.data.FPS = FPS;
		FlxG.save.data.ghostTapping = ghostTapping;
		FlxG.save.data.keybinds = keybindMap;
		FlxG.save.data.useMS = middlescroll;
		FlxG.save.flush();
	}
}
// Esto hizo Britex - This made Britex