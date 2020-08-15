# MULE - Mort's Ultimate Leveling Experience
Version 1.7

A fully customizable leveling mod that removes the level-up screen entirely. Never worry about min/maxing skill ups ever again. The functionality of GCD/MADD, but fully customizable and conflict-free. Play how you want, and leave leveling to the MULE.

About:
With this mod, you will never see a levelup screen. You won't have to min/max to make sure you're gaining health properly, or getting enough strength per level. Instead, progress in skills gives you progress towards attribute gains.

Similar to GCD, except not nearly as punishing and (hopefully) not nearly as buggy.

By default, major and minor skills give 1 of their favored attribute per level.

Misc skills give 0.5, but only after they are at 30 or above (otherwise you could just spam training and get a ton of attributes from your misc skills).

Misc skills also give progress towards level. 3 misc skills give one level point (As in vanilla, 10 are required to level. This is one of the few unchangeable values).

Luck is gained 1 per level. 

Health gain is either vanilla, or my preferred method of 5 per level, and gain 2 health per endurance gained. 

There is a fairly robust Mod Configuration Menu included. 
In that you have the option to:
-Change level thresholds for attribute gain
-Change amount of attribute gain
-Modify gains from major/minor/misc
-Revert health gains to vanilla

Suggested Mod:
MWSE State based health by Necrolesian
https://www.nexusmods.com/morrowind/mods/48133

Updates:
v1.7
-Now includes levelup messages
-More difficult default leveling (it was a bit *too* easy)

v1.6
-Now fixes -1 levelup bug

v1.5
-You can now alter the flat rate HP system! Both flat HP per level and HP per endurance are now changeable
-Fixed return potentially breaking other MWSE mods using skillup event
-Now using HP GMST instead of 0.1 for vanilla leveling

v1.4
-0 misc to level now correctly doesn't increment levelup progress

v1.3
-Fixed a different misc leveling bug

v1.2
-Fixed misc level bug

v1.1
-More customizable options
-Fixed UI bug
-Fixed long blade bug

Requirements:
-MGEXE
-MWSE-lua beta branch (available here: https://nullcascade.com/mwse/mwse-dev.zip )
-OpenMW is not supported

Installation:
-Drag and drop data files folder, merge if asked.

Uninstallation:
-Remove or rename the main.lua file. There is also a mod configuration option to disable the mod as well.

Licence/Usage:
MIT Licence

Special Thanks:
Greatness7 - Level UI update code
Merlord - EasyMCM
Nullcascade - MWSE-lua
Hrnchamd - MWSE-lua work, MGEXE, MCP, all of that great stuff
