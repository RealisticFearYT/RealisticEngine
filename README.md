# <img src="art/icon64.png" align="center"> Friday Night Funkin' Realistic Engine </img>
## Build instuctions (Windows)
If you want to compile the game, follow these steps:
ATTENTION THIS ENGINE FOR NOW IS ONLY FOR WINDOWS AND ONLY 64 BIT
1. [Install Haxe 4.2.5](https://haxe.org/download/version/4.1.5/)
2. [Install HaxeFlixel](https://haxeflixel.com/documentation/install-haxeflixel/) after downloading Haxe
Now open cmd and type the following commands:
```
haxelib install lime
haxelib install openfl
haxelib install flixel
haxelib install flixel-haxelib install addons
haxelib install flixel-ui
haxelib install hscript
haxelib install newgrounds
haxelib run lime setup flixel
haxelib run lime setup
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git polymod https://github.com/larsiusprime/polymod.git
haxelib git discord_rpc https://github.com/Aidan63/linc_discord-rpc
haxelib git flixel-addons https://github.com/HaxeFlixel/flixel-addons
```
After you have installed all the libraries go to the RealisticEngine folder and open terminal and place:
```
lime test windows
```
or
```
lime test windows -debug
```
The lime test windows -debug is used to see the errors in the compilation.
Is it normal that after compiling it tells me a warning at some point?
Yes, if it is normal, it is not an error, it is just a warning.
