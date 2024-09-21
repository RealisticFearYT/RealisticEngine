package; 
// Declara que esta clase pertenece al paquete raíz.

import flixel.FlxSprite; 
// Importa la clase FlxSprite de la biblioteca Flixel, que es la clase base para HealthIcon.

#if sys
	import openfl.display.BitmapData;
#end 
// Si se está compilando para sistemas de escritorio, importa BitmapData de OpenFL.

class HealthIcon extends FlxSprite {
	// Define la clase HealthIcon que extiende FlxSprite.

	public var hasWinningIcon:Bool = false;
	// Variable pública que indica si el ícono tiene una versión ganadora.

	var character:String;
	// Variable para almacenar el personaje asociado con este ícono.

	public var sprTracker:FlxSprite;
	// Variable pública para un FlxSprite que rastrea la posición.

	public function new(character:String = 'bf', isPlayer:Bool = false) {
		// Constructor de la clase que toma el personaje y si es jugador.

		super();
		// Llama al constructor de la clase base FlxSprite.

		changeIcon(character, isPlayer);
		// Llama a la función changeIcon con los parámetros proporcionados.

		scrollFactor.set();
		// Establece el scroll factor a los valores predeterminados.
	}

	public function changeIcon(character:String = 'bf', isPlayer:Bool = false) {
		// Función pública para cambiar el ícono del personaje.

		if(this.character != character) {
			// Comprueba si el personaje actual es diferente del nuevo.

			this.character = character;
			// Actualiza el personaje actual.

			loadGraphic(Paths.image('icons/$character'));
			// Carga la imagen del nuevo ícono del personaje.

			if(width == 450)
				hasWinningIcon = true;
				// Si el ancho de la imagen es 450, indica que tiene una versión ganadora.

			loadGraphic(Paths.image('icons/$character'), true, 150, 150);
			// Vuelve a cargar la imagen con animaciones, estableciendo el tamaño a 150x150.

			antialiasing = true;
			// Habilita el antialiasing para una mejor calidad de imagen.

			animation.add(character, [0, 1, 2], 0, false, isPlayer);
			// Agrega una animación para el personaje con los fotogramas especificados.

			animation.play(character);
			// Reproduce la animación del personaje.
		}
	}

	override function update(elapsed:Float) {
		// Sobrescribe la función update para actualizar cada frame.

		super.update(elapsed);
		// Llama a la función update de la clase base.

		if (sprTracker != null)
			// Si sprTracker no es nulo,

			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
			// Establece la posición del ícono basado en la posición de sprTracker.
	}
}
