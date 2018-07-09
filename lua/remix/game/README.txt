This directory is where all minigame logic lives. Each mame game should have a lua file called
"mamename".lua (i.e. dkong.lua for the dkong game). Each file should export a module called "game", and this module
must have a function with the exact same name as the save state in minigame_states/(gamename)/ for each save state.
This function will be invoked once per game tick and should return one of the values in common.MINIGAME_STATE, indicating
the status of the minigame.

For example, see dkong.lua. We have a minigame state called "jump5.sta". In dkong.lua, the module contains a function
called jump5. This function returns a value based on whether the minigame has been completed.