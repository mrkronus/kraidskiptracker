local addonName = ...

-- Localization file for english/United States
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "deDE")
if not L then return end

-- Ctrl-c copy dialog
L["Close"] = "de_Close"
L["Use ctrl-c to copy"] = "de_Use ctrl-c to copy"
L["Click for Wowhead link"] = "de_Click for Wowhead link"
L["This raid skip does not have a quest associated with it."] = "de_This raid skip does not have a quest associated with it."

-- Expansion Tooltip
L["Expansion: "] = "de_Expansion: "
L["Containing zone: "] = "de_Containing zone: "
L["Required level to enter: "] = "de_Required level to enter: "
L["Number of players: "] = "de_Number of players: "
L["Click to open Adventure Journal"] = "de_Click to open Adventure Journal"

-- Player toolip
L["Player:"] = "de_Player:"
L["Realm:"] = "de_Realm:"
L["Class:"] = "de_Class:"
L["Level:"] = "de_Level:"
L["iLevel:"] = "de_iLevel:"
L["Last Synced:"] = "de_Last Synced:"
L["Unknown"] = "de_Unknown"
L["%m/%d/%y %H:%M:%S"] = "%m/%d/%y %H:%M:%S"

-- Addon title toolip
L["Total Shown Characters: "] = "de_Total Shown Characters: "
L["Total Tracked Characters: "] = "de_Total Tracked Characters: "

-- Minimap Icon/LibDB Tooltip
L["Right click icon for options"] = "de_Right click icon for options"

-- Options
L["Hide minimap button"] = "de_Hide minimap button"
L["Hides or shows the minimap button."] = "de_Hides or shows the minimap button."
L["Always show all raid headings"] = "de_Always show all raid headings"
L["Forces all raid headers to awlays be shown, regardless of other settings."] = "de_Forces all raid headers to awlays be shown, regardless of other settings."
L["Hide raid quests with no progress"] = "de_Hide raid quests with no progress"
L["Toggles the display of raids that have have no progression on any shown characters."] = "de_Toggles the display of raids that have have no progression on any shown characters."
L["Hide characters with no progress"] = "de_Hide characters with no progress"
L["Toggles the display of characters that have have no progression on any shown raids."] = "de_Toggles the display of characters that have have no progression on any shown raids."
L["Show current realm only"] = "de_Show current realm only"
L["Toggles hiding all characters from realms other than the current one"] = "de_Toggles hiding all characters from realms other than the current one"
L["Fit window to screen"] = "de_Fit window to screen"
L["Scales the entire window to fit on the screen. Useful if you have many characters and content would otherwise run off the side of the screen."] = "de_Scales the entire window to fit on the screen. Useful if you have many characters and content would otherwise run off the side of the screen."
L["Show debug output in chat"] = "de_Show debug output in chat"
L["Toggles the display debugging Text in the chat window. "] = "de_Toggles the display debugging Text in the chat window. "
L["Recommended to leave off."] = "de_Recommended to leave off."
L["Characters"] = "de_Characters"
L["Delete All Stored Character Data"] = "de_Delete All Stored Character Data"
L["Are you sure you want to delete all instance and raid data?"] = "de_Are you sure you want to delete all instance and raid data?"
L["This action cannot be undone and will require you to log into each character again to get the data back."] = "de_This action cannot be undone and will require you to log into each character again to get the data back."
L["Some data is not avaiable, please log into this character to refresh the data."] = "de_Some data is not avaiable, please log into this character to refresh the data."
L["Realm: "] = "de_Realm: "
L["Level: "] = "de_Level: "
L["iLvl: "] = "de_iLvl: "
L["Class: "] = "de_Class: "
L["Last Synced: "] = "de_Last Synced: "
L["(unknown)"] = "de_(unknown)"
L["Class: (unknown)"] = "de_Class: (unknown)"
L["Hide"] = "de_Hide"
L["Show"] = "de_Show"
L["Toggles visibililty of the currently selected character but will not delete the associated data."] = "de_Toggles visibililty of the currently selected character but will not delete the associated data."
L["Delete"] = "de_Delete"
L["Are you sure you want to delete instance and raid data for "] = "de_Are you sure you want to delete instance and raid data for "
L["This action cannot be undone and will require logging into this character again to get the data back."] = "de_This action cannot be undone and will require logging into this character again to get the data back."

-- Raid data
L["DEFAULT_DESCRIPTION_TEXT"] = "de_Information on how to acquire and use this skip will be added in a future update. In the meantime, please check the wowhead link by clicking on the appropriate quest below this heading."
L["Normal"] = "de_Normal"
L["Heroic"] = "de_Heroic"
L["Mythic"] = "de_Mythic"

L["WOD_BRF_INSTANCE_NAME"] = "de_WOD: Blackrock Foundry"
L["WOD_BRF_INSTANCE_SHORT_NAME"] = "de_Blackrock Foundry"
L["WOD_BRF_DESCRIPTION_TEXT"] = "de_Starting NPC:\nAfter defeating The Iron Maidens (about halfway through the raid), a hidden path to the east through some cargo boxes becomes available. At the end of the winding path, Goraluk Anvilcrack can be found and will give the quest Sigil of the Black Hand.\n\nUsing the Skip:\nIf anyone in the raid has the skip, two large stones on either side of the entrance to Blackhand become usable. Interacting with them allows the raid to skip all other bosses.\n\nAcquiring the mythic skip unlocks the skip for all difficulty levels."

L["WOD_HFC_INSTANCE_NAME"] = "de_WOD: Hellfire Citadel"
L["WOD_HFC_INSTANCE_SHORT_NAME"] = "de_Hellfire Citadel"
L["WOD_HFC_DESCRIPTION_TEXT"] = "de_Starting NPC:\nThere are two quests to fully unlock the skip. One for the first half, and one for the second half. Khadgar (available in multiple places in the instance) gives both, the first after killing the 2nd boss, Iron Reaver. Completing the first quest allows access to the second.\n\nUsing the Skip:\nIf anyone in the raid has either skip quest completed, a special portal will appear on the south wall, near the entrace to the raid, after all the NPCs spawn in.\n\nAcquiring the mythic skip unlocks the skip for all difficulty levels."
L["Upper Citadel"] = "de_Upper Citadel"
L["Destructor's Rise"] = "de_Destructor's Rise"