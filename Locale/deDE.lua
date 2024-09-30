local addonName = ...

-- Localization file for german
local L = LibStub("AceLocale-3.0"):NewLocale(addonName, "deDE")
if not L then return end

-- Ctrl-c copy dialog
L["Close"] = "Schliessen"
L["Use ctrl-c to copy"] = "mit STRG-C kopieren"
L["Click for Wowhead link"] = "anklicken => Wowhead link"
L["This raid skip does not have a quest associated with it."] = "Es gibt keine zugehörige Quest um in diesem Raid Bosse zu überspringen"

-- Expansion Tooltip
L["Expansion: "] = "Erweiterung: "
L["Containing zone: "] = "Zone: "
L["Required level to enter: "] = "Benötigtes Level um einzutreten: "
L["Number of players: "] = "Spieleranzahl: "
L["Click to open Adventure Journal"] = "anklicken => Abenteuerführer öffnen"

-- Player toolip
L["Player:"] = "Spieler:"
L["Realm:"] = "Realm:"
L["Class:"] = "Klasse:"
L["Level:"] = "Level:"
L["iLevel:"] = "iLevel:"
L["Last Synced:"] = "zuletzt synchronisiert:"
L["Unknown"] = "unbekannt"
L["%m/%d/%y %H:%M:%S"] = "%y/%m/%d/ %H:%M:%S"

-- Addon title toolip
L["Total Shown Characters: "] = "Anzahl aller Charactere: "
L["Total Tracked Characters: "] = "Anzahl verfolgter Charactere: "

-- Minimap Icon/LibDB Tooltip
L["Right click icon for options"] = "Rechtsklick öffnet Optionsmenu"

-- Options
L["Hide minimap button"] = "Minimap Button ausblenden"
L["Hides or shows the minimap button."] = "Minimap Button AN / AUS"
L["Always show all raid headings"] = "Immer alle Raidbezeichnungen anzeigen"
L["Forces all raid headers to awlays be shown, regardless of other settings."] = "Zeigt alle Raidbezeichnungen an, unabhängig aller anderen Einstellungen"
L["Hide raid quests with no progress"] = "Raid Quests ohne jeden Fortschritt ausblenden"
L["Toggles the display of raids that have no progression on any shown characters."] = "Stellt die Darstellung von Raids um, welche keinen Fortschritt bei irgendeinem angezeigtem Charakter haben"
L["Hide characters with no progress"] = "Charakter ohne jeden Fortschritt ausblenden"
L["Toggles the display of characters that have no progression on any shown raids."] = "Stellt die Darstellung von Charaktären um, welche keinen Fortschritt bei irgendeinem Raid haben"
L["Show current realm only"] = "Nur den aktuellen Realm anzeigen"
L["Toggles hiding all characters from realms other than the current one"] = "Charaktäre anderer Reamls verstecken oder anzeigen"
L["Fit window to screen"] = "Anzeigeliste an Fenstergröße anpassen"
L["Scales the entire window to fit on the screen. Useful if you have many characters and content would otherwise run off the side of the screen."] = "Passt die Größe des Anzeigefensters an das Spielefenster an. Sehr hilfreich wenn man viele Charaktäre darstellen will und sonst das Anzeigefenster aus dem Spielefenster ragt und nicht mehr sichbar wäre."
L["Show debug output in chat"] = "Zeige den Debugtext im Chat mit an"
L["Toggles the display debugging Text in the chat window. "] = "Debugtext in den Chat schreiben AN / AUS "
L["Recommended to leave off."] = " Empfehlung: AUS"
L["Characters"] = "Charactäre"
L["Delete All Stored Character Data"] = "Daten aller Charaktäre löschen"
L["Are you sure you want to delete all instance and raid data?"] = "Wirklich alle Instanz- und Raidaten löschen ?!?"
L["This action cannot be undone and will require you to log into each character again to get the data back."] = "Dies kann nicht rückgängig gemacht werden! Es muss jeder einzelne Charakter erneut eingelogt werden um die Daten erneut zu erheben"
L["Some data is not avaiable, please log into this character to refresh the data."] = "Einige Daten sind nicht vorhanden. Bitte diesen Charakter erneut einloggen um die Daten neu aufzunehmen"
L["Realm: "] = "Realm: "
L["Level: "] = "Level: "
L["iLvl: "] = "iLvl: "
L["Class: "] = "Klasse: "
L["Last Synced: "] = "Zuseltzt synchronisiert: "
L["(unknown)"] = "(unbekannt)"
L["Class: (unknown)"] = "Klasse: (unbekannt)"
L["Hide"] = "ausblenden"
L["Show"] = "Anzeigen"
L["Toggles visibililty of the currently selected character but will not delete the associated data."] = "Sichbarkeit des aktuell gewählten Charakters AN / AUS. Daten bleiben natürlich erhalten"
L["Delete"] = "Löschen"
L["Are you sure you want to delete instance and raid data for "] = "Sollen wirklich die Instanz- und Raiddaten für diesen Charakater gelöscht werden :"
-- DOUBLE !!!!!
L["This action cannot be undone and will require logging into this character again to get the data back."] = "Dies kann nicht rückgängig gemacht werden! Es muss jeder einzelne Charakter erneut eingelogt werden um die Daten erneut zu erheben"

-- Raid data
L["DEFAULT_DESCRIPTION_TEXT"] = "Die genaue Anleitung zum Skippen wird in späteren Updates integriert. Solange hilft der WoWHead Link zur Quest unterhalb der Überschriften"
L["Normal"] = "Normal"
L["Heroic"] = "Heroisch"
L["Mythic"] = "Mythisch"

L["(no instance name)"] = "(Kein Instanzname)"
L["(no quest name)"] = "(Kein Questname)"
L["(none)"] = "(kein)"
L["has progress on quest"] = "´s Questfortschritt "

L["WOD_BRF_INSTANCE_NAME"] = "WOD: Schwarzfelsgießerei"
L["WOD_BRF_INSTANCE_SHORT_NAME"] = "Schwarzfelsgießerei"
L["WOD_BRF_DESCRIPTION_TEXT"] = "Starting NPC:\nAfter defeating The Iron Maidens (about halfway through the raid), a hidden path to the east through some cargo boxes becomes available. At the end of the winding path, Goraluk Anvilcrack can be found and will give the quest Sigil of the Black Hand.\n\nUsing the Skip:\nIf anyone in the raid has the skip, two large stones on either side of the entrance to Blackhand become usable. Interacting with them allows the raid to skip all other bosses.\n\nAcquiring the mythic skip unlocks the skip for all difficulty levels."

L["WOD_HFC_INSTANCE_NAME"] = "WOD: Höllenfeuerzitadelle"
L["WOD_HFC_INSTANCE_SHORT_NAME"] = "Höllenfeuerzitadelle"
L["WOD_HFC_DESCRIPTION_TEXT"] = "Starting NPC:\nThere are two quests to fully unlock the skip. One for the first half, and one for the second half. Khadgar (available in multiple places in the instance) gives both, the first after killing the 2nd boss, Iron Reaver. Completing the first quest allows access to the second.\n\nUsing the Skip:\nIf anyone in the raid has either skip quest completed, a special portal will appear on the south wall, near the entrace to the raid, after all the NPCs spawn in.\n\nAcquiring the mythic skip unlocks the skip for all difficulty levels."
L["Upper Citadel"] = "obere Zitadelle"
L["Destructor's Rise"] = "Höhe des Zerstörers"

L["LEG_EN_INSTANCE_NAME"] = "Legion: Der Smaragggrüne Alptraum"
L["LEG_EN_INSTANCE_SHORT_NAME"] = "Der Smaragggrüne Alptraum"

L["LEG_NIGHT_INSTANCE_NAME"] = "Legion: Die Nachtfestung"
L["LEG_NIGHT_INSTANCE_SHORT_NAME"] = "Die Nachtfestung"

L["LEG_TOS_INSTANCE_NAME"] = "Legion: Das Grabmal des Sargeras"
L["LEG_TOS_INSTANCE_SHORT_NAME"] = "Das Grabmal des Sargeras"

L["LEG_ANT_INSTANCE_NAME"] = "Legion: Antorus, der brennende Thron"
L["LEG_ANT_INSTANCE_SHORT_NAME"] = "Antorus, der brennende Thron"
L["Imonar"] = "Immonar der Seelenjäger"
L["Aggramar"] = "Aggramar"

L["BFA_NTWC_INSTANCE_NAME"] = "BFA: Ny'alotha, die erwachte Stadt"
L["BFA_NTWC_INSTANCE_SHORT_NAME"] = "Ny'alotha, die erwachte Stadt"

L["BFA_BD_INSTANCE_NAME"] = "BFA: Schlacht von Dazar'alor"
L["BFA_BD_INSTANCE_SHORT_NAME"] = "Schlacht von Dazar'alor"

L["SL_CN_INSTANCE_NAME"] = "SL: Schloss Nathria"
L["SL_CN_INSTANCE_SHORT_NAME"] = "Schloss Nathria"

L["SL_SOD_INSTANCE_NAME"] = "SL: Sanktum der Herrschaft"
L["SL_SOD_INSTANCE_SHORT_NAME"] = "Sanktum der Herrschaft"

L["SL_SFO_INSTANCE_NAME"] = "SL: Mausoleum der Ersten"
L["SL_SFO_INSTANCE_SHORT_NAME"] = "Mausoleum der Ersten"

L["DF_VOI_INSTANCE_NAME"] = "DF: Gewölbe der Inkarnation"
L["DF_VOI_INSTANCE_SHORT_NAME"] = "Gewölbe der Inkarnation"

L["DF_ASC_INSTANCE_NAME"] = "DF: Aberrus, Schmelztiegel der Schatten"
L["DF_ASC_INSTANCE_SHORT_NAME"] = "Aberrus, Schmelztiegel der Schatten"

L["DF_ADH_INSTANCE_NAME"] = "DF: Amirdrassil, Hoffnung des Traums"
L["DF_ADH_INSTANCE_SHORT_NAME"] = "Amirdrassil, Hoffnung des Traums"