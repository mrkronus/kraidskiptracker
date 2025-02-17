local addonName = ...

-- Localization file for english/United States
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "enUS", true)

-- Ctrl-c copy dialog
L["Close"] = "Close"
L["Use ctrl-c to copy"] = "Use ctrl-c to copy"
L["Click for Wowhead link"] = "Click for Wowhead link"
L["This raid skip does not have a quest associated with it."] = "This raid skip does not have a quest associated with it."

-- Expansion Tooltip
L["Expansion: "] = "Expansion: "
L["Containing zone: "] = "Containing zone: "
L["Required level to enter: "] = "Required level to enter: "
L["Number of players: "] = "Number of players: "
L["Click to open Adventure Journal"] = "Click to open Adventure Journal"

-- Player toolip
L["Player:"] = "Player:"
L["Realm:"] = "Realm:"
L["Class:"] = "Class:"
L["Level:"] = "Level:"
L["iLevel:"] = "iLevel:"
L["Last Synced:"] = "Last Synced:"
L["Unknown"] = "Unknown"
L["%m/%d/%y %H:%M:%S"] = "%m/%d/%y %H:%M:%S"

-- Addon title toolip
L["Total Shown Characters: "] = "Total Shown Characters: "
L["Total Tracked Characters: "] = "Total Tracked Characters: "

-- Minimap Icon/LibDB Tooltip
L["Right click icon for options"] = "Right click icon for options"

-- Options
L["Hide minimap button"] = "Hide minimap button"
L["Hides or shows the minimap button."] = "Hides or shows the minimap button."
L["Always show all raid headings"] = "Always show all raid headings"
L["Forces all raid headers to awlays be shown, regardless of other settings."] = "Forces all raid headers to awlays be shown, regardless of other settings."
L["Hide raid quests with no progress"] = "Hide raid quests with no progress"
L["Toggles the display of raids that have no progression on any shown characters."] = "Toggles the display of raids that have have no progression on any shown characters."
L["Hide characters with no progress"] = "Hide characters with no progress"
L["Toggles the display of characters that have have no progression on any shown raids."] = "Toggles the display of characters that have have no progression on any shown raids."
L["Show current realm only"] = "Show current realm only"
L["Toggles hiding all characters from realms other than the current one"] = "Toggles hiding all characters from realms other than the current one"
L["Fit window to screen"] = "Fit window to screen"
L["Scales the entire window to fit on the screen. Useful if you have many characters and content would otherwise run off the side of the screen."] = "Scales the entire window to fit on the screen. Useful if you have many characters and content would otherwise run off the side of the screen."
L["Show debug output in chat"] = "Show debug output in chat"
L["Toggles the display debugging Text in the chat window. "] = "Toggles the display debugging Text in the chat window. "
L["Recommended to leave off."] = "Recommended to leave off."
L["Characters"] = "Characters"
L["Delete All Stored Character Data"] = "Delete All Stored Character Data"
L["Are you sure you want to delete all instance and raid data?"] = "Are you sure you want to delete all instance and raid data?"
L["This action cannot be undone and will require you to log into each character again to get the data back."] = "This action cannot be undone and will require you to log into each character again to get the data back."
L["Some data is not avaiable, please log into this character to refresh the data."] = "Some data is not avaiable, please log into this character to refresh the data."
L["Realm: "] = "Realm: "
L["Level: "] = "Level: "
L["iLvl: "] = "iLvl: "
L["Class: "] = "Class: "
L["Last Synced: "] = "Last Synced: "
L["(unknown)"] = "(unknown)"
L["Class: (unknown)"] = "Class: (unknown)"
L["Hide"] = "Hide"
L["Show"] = "Show"
L["Toggles visibililty of the currently selected character but will not delete the associated data."] = "Toggles visibililty of the currently selected character but will not delete the associated data."
L["Delete"] = "Delete"
L["Are you sure you want to delete instance and raid data for "] = "Are you sure you want to delete instance and raid data for "
L["This action cannot be undone and will require logging into this character again to get the data back."] = "This action cannot be undone and will require logging into this character again to get the data back."

-- Raid data
L["DEFAULT_DESCRIPTION_TEXT"] = "Information on how to acquire and use this skip will be added in a future update. In the meantime, please check the wowhead link by clicking on the appropriate quest below this heading."
L["Normal"] = "Normal"
L["Heroic"] = "Heroic"
L["Mythic"] = "Mythic"

L["(no instance name)"] = "(no instance name)"
L["(no quest name)"] = "(no quest name)"
L["(none)"] = "(none)"
L["has progress on quest"] = " has progress on quest "

L["WOD_BRF_INSTANCE_NAME"] = "WOD: Blackrock Foundry"
L["WOD_BRF_INSTANCE_SHORT_NAME"] = "Blackrock Foundry"
L["WOD_BRF_DESCRIPTION_TEXT"] = "Starting NPC:\nAfter defeating The Iron Maidens (about halfway through the raid), a hidden path to the east through some cargo boxes becomes available. At the end of the winding path, Goraluk Anvilcrack can be found and will give the quest Sigil of the Black Hand.\n\nUsing the Skip:\nIf anyone in the raid has the skip, two large stones on either side of the entrance to Blackhand become usable. Interacting with them allows the raid to skip all other bosses.\n\nAcquiring the mythic skip unlocks the skip for all difficulty levels."

L["WOD_HFC_INSTANCE_NAME"] = "WOD: Hellfire Citadel"
L["WOD_HFC_INSTANCE_SHORT_NAME"] = "Hellfire Citadel"
L["WOD_HFC_DESCRIPTION_TEXT"] = "Starting NPC:\nThere are two quests to fully unlock the skip. One for the first half, and one for the second half. Khadgar (available in multiple places in the instance) gives both, the first after killing the 2nd boss, Iron Reaver. Completing the first quest allows access to the second.\n\nUsing the Skip:\nIf anyone in the raid has either skip quest completed, a special portal will appear on the south wall, near the entrace to the raid, after all the NPCs spawn in.\n\nAcquiring the mythic skip unlocks the skip for all difficulty levels."
L["Upper Citadel"] = "Upper Citadel"
L["Destructor's Rise"] = "Destructor's Rise"

L["LEG_EN_INSTANCE_NAME"] = "Legion: The Emerald Nightmare"
L["LEG_EN_INSTANCE_SHORT_NAME"] = "The Emerald Nightmare"

L["LEG_NIGHT_INSTANCE_NAME"] = "Legion: The Nighthold"
L["LEG_NIGHT_INSTANCE_SHORT_NAME"] = "The Nighthold"

L["LEG_TOS_INSTANCE_NAME"] = "Legion: Tomb of Sargeras"
L["LEG_TOS_INSTANCE_SHORT_NAME"] = "Tomb of Sargeras"

L["LEG_ANT_INSTANCE_NAME"] = "Legion: Antorus, the Burning Throne"
L["LEG_ANT_INSTANCE_SHORT_NAME"] = "Antorus, the Burning Throne"
L["Imonar"] = "Imonar"
L["Aggramar"] = "Aggramar"

L["BFA_NTWC_INSTANCE_NAME"] = "BFA: Ny'alotha, the Waking City"
L["BFA_NTWC_INSTANCE_SHORT_NAME"] = "Ny'alotha, the Waking City"

L["BFA_BD_INSTANCE_NAME"] = "BFA: Battle of Dazar'alor"
L["BFA_BD_INSTANCE_SHORT_NAME"] = "Battle of Dazar'alor"

L["SL_CN_INSTANCE_NAME"] = "SL: Castle Nathria"
L["SL_CN_INSTANCE_SHORT_NAME"] = "Castle Nathria"

L["SL_SOD_INSTANCE_NAME"] = "SL: Sanctum of Domination"
L["SL_SOD_INSTANCE_SHORT_NAME"] = "Sanctum of Domination"

L["SL_SFO_INSTANCE_NAME"] = "SL: Sepulcher of the First Ones"
L["SL_SFO_INSTANCE_SHORT_NAME"] = "Sepulcher of the First Ones"

L["DF_VOI_INSTANCE_NAME"] = "DF: Vault of the Incarnates"
L["DF_VOI_INSTANCE_SHORT_NAME"] = "Vault of the Incarnates"

L["DF_ASC_INSTANCE_NAME"] = "DF: Aberrus, the Shadowed Crucible"
L["DF_ASC_INSTANCE_SHORT_NAME"] = "Aberrus, the Shadowed Crucible"

L["DF_ADH_INSTANCE_NAME"] = "DF: Amirdrassil, the Dream's Hope"
L["DF_ADH_INSTANCE_SHORT_NAME"] = "Amirdrassil, the Dream's Hope"

L["TWW_NAP_INSTANCE_NAME"] = "TWW: Nerub-ar Palace"
L["TWW_NAP_INSTANCE_SHORT_NAME"] = "Nerub-ar Palace"