@echo off
color 0a
cd ..
@echo on
echo Installing libraries
echo Please wait a moment, this may take a while depending on your internet speed.
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
echo Library installation already done! You can now close this window
pause