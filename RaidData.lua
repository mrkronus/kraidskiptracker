--
-- Addon data initialization
--
local addonName, KRaidSkipTracker = ...

-- [[ Localization ]]
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

-- List of raid IDs, in order 
-- from https://wowpedia.fandom.com/wiki/InstanceID
local RaidOrder =
{
    1205, -- WOD: Blackrock Foundry
    1448, -- WOD: Hellfire Citadel

    1520, -- Legion: The Emerald Nightmare
    1530, -- Legion: The Nighthold
    1676, -- Legion: Tomb of Sargeras
    1712, -- Legion: Antorus, the Burning Throne

    2217, -- BFA: Ny'alotha, the Waking City
    2070, -- BFA: Battle of Dazar'alor

    2296, -- SL: Castle Nathria
    2450, -- SL: Sanctum of Domination
    2481, -- SL: Sepulcher of the First Ones

    2522, -- DF: Vault of the Incarnates
    2569, -- DF: Aberrus, the Shadowed Crucible
    2549, -- DF: Amirdrassil, the Dream's Hope

    2657, -- TWW: Nerub-ar Palace
}

-- Note: you can look up the ids here:
-- InstanceID: https://wago.tools/db2/Map
-- and https://wowpedia.fandom.com/wiki/InstanceID
-- JournalID: https://wago.tools/db2/JournalInstance
-- ZoneID: https://www.wowhead.com/guide/list-of-zone-ids-for-navigation-in-wow-and-tomtom-19501
KRaidSkipTracker.questDataByExpansion =
{
    {
        expansionName = EXPANSION_NAME5,
        raids =
        {
            -- WOD: Blackrock Foundry
            {
                instanceName = L["WOD_BRF_INSTANCE_NAME"], instanceShortName = L["WOD_BRF_INSTANCE_SHORT_NAME"], instanceId = 1205, journalInstanceId = 457, isStatistic = false,
                requiredLevel = "40", numberOfPlayers = "10/30", locatedInZoneId = 543, -- Gorgrond 
                instanceDescriptionText = L["WOD_BRF_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 37029 },
                    { questName = L["Heroic"], questId = 37030 },
                    { questName = L["Mythic"], questId = 37031 },
                }
            },

            -- WOD: Hellfire Citadel
            {
                instanceName = L["WOD_HFC_INSTANCE_NAME"], instanceShortName = L["WOD_HFC_INSTANCE_SHORT_NAME"], instanceId = 1448, journalInstanceId = 669, isStatistic = false,
                requiredLevel = "40", numberOfPlayers = "10/30", locatedInZoneId = 534, -- Tanaan Jungle
                instanceDescriptionText = L["WOD_HFC_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"].." "..L["Upper Citadel"], questId = 39499 },
                    { questName = L["Heroic"].." "..L["Upper Citadel"], questId = 39500 },
                    { questName = L["Mythic"].." "..L["Upper Citadel"], questId = 39501 },
                    { questName = L["Normal"].." "..L["Destructor's Rise"], questId = 39502 },
                    { questName = L["Heroic"].." "..L["Destructor's Rise"], questId = 39504 },
                    { questName = L["Mythic"].." "..L["Destructor's Rise"], questId = 39505 }
                },
            },
        }
    },
    {
        expansionName = EXPANSION_NAME6,
        raids =
        {
            -- Legion: The Emerald Nightmare
            {
                instanceName = L["LEG_EN_INSTANCE_NAME"], instanceShortName = L["LEG_EN_INSTANCE_SHORT_NAME"], instanceId = 1520, journalInstanceId = 768, isStatistic = false,
                requiredLevel = "45", numberOfPlayers = "10/30", locatedInZoneId = 641, -- Val'sharah
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 44283 },
                    { questName = L["Heroic"], questId = 44284 },
                    { questName = L["Mythic"], questId = 44285 }
                }
            },

            -- Legion: The Nighthold
            {
                instanceName = L["LEG_NIGHT_INSTANCE_NAME"], instanceShortName = L["LEG_NIGHT_INSTANCE_SHORT_NAME"], instanceId = 1530, journalInstanceId = 786, isStatistic = false,
                requiredLevel = "45", numberOfPlayers = "10/30", locatedInZoneId = 680, -- Suramar 
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 45381 },
                    { questName = L["Heroic"], questId = 45382 },
                    { questName = L["Mythic"], questId = 45383 }
                }
            },

            -- Legion: Tomb of Sargeras
            {
                instanceName = L["LEG_TOS_INSTANCE_NAME"], instanceShortName = L["LEG_TOS_INSTANCE_SHORT_NAME"], instanceId = 1676, journalInstanceId = 875, isStatistic = false,
                requiredLevel = "45", numberOfPlayers = "10/30", locatedInZoneId = 646, -- The Broken Shore 
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 47725 },
                    { questName = L["Heroic"], questId = 47726 },
                    { questName = L["Mythic"], questId = 47727 }
                }
            },

            -- Legion: Antorus, the Burning Throne
            {
                instanceName = L["LEG_ANT_INSTANCE_NAME"], instanceShortName = L["LEG_ANT_INSTANCE_SHORT_NAME"], instanceId = 1712, journalInstanceId = 946, isStatistic = false,
                requiredLevel = "45", numberOfPlayers = "10/30", locatedInZoneId = 885, -- Argus: Antoran Wastes
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"].." "..L["Imonar"], questId = 49032 },
                    { questName = L["Heroic"].." "..L["Imonar"], questId = 49075 },
                    { questName = L["Mythic"].." "..L["Imonar"], questId = 49076 },
                    { questName = L["Normal"].." "..L["Aggramar"], questId = 49134 },
                    { questName = L["Heroic"].." "..L["Aggramar"], questId = 49133 },
                    { questName = L["Mythic"].." "..L["Aggramar"], questId = 49135 }
                },
            },
        }
    },
    {
        expansionName = EXPANSION_NAME7,
        raids =
        {
            -- BFA: Ny'alotha, the Waking City
            {
                instanceName = L["BFA_NTWC_INSTANCE_NAME"], instanceShortName = L["BFA_NTWC_INSTANCE_SHORT_NAME"], instanceId = 2217, journalInstanceId = 1180, isStatistic = false,
                requiredLevel = "50", numberOfPlayers = "10/30", locatedInZoneId = 1527, -- Uldum
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 58373 },
                    { questName = L["Heroic"], questId = 58374 },
                    { questName = L["Mythic"], questId = 58375 }
                }
            },

            -- BFA: Battle of Dazar'alor
            {
                instanceName = L["BFA_BD_INSTANCE_NAME"], instanceShortName = L["BFA_BD_INSTANCE_SHORT_NAME"], instanceId = 2070, journalInstanceId = 1176, isStatistic = true,
                requiredLevel = "50", numberOfPlayers = "10/30", locatedInZoneId = 862, -- Zuldazar 
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Mythic"], questId = 13382 }
                }
            },
        }
    },
    {
        expansionName = EXPANSION_NAME8,
        raids =
        {
            -- SL: Castle Nathria
            {
                instanceName = L["SL_CN_INSTANCE_NAME"], instanceShortName = L["SL_CN_INSTANCE_SHORT_NAME"], instanceId = 2296, journalInstanceId = 1190, isStatistic = false,
                requiredLevel = "60", numberOfPlayers = "10/30", locatedInZoneId = 1525, -- Revendreth
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 62054 },
                    { questName = L["Heroic"], questId = 62055 },
                    { questName = L["Mythic"], questId = 62056 }
                }
            },
            -- SL: Sanctum of Domination
            {
                instanceName = L["SL_SOD_INSTANCE_NAME"], instanceShortName = L["SL_SOD_INSTANCE_SHORT_NAME"], instanceId = 2450, journalInstanceId = 1193, isStatistic = false,
                requiredLevel = "60", numberOfPlayers = "10/30", locatedInZoneId = 1543, -- The Maw
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 64597 },
                    { questName = L["Heroic"], questId = 64598 },
                    { questName = L["Mythic"], questId = 64599 }
                }
            },
            -- SL: Sepulcher of the First Ones
            {
                instanceName = L["SL_SFO_INSTANCE_NAME"], instanceShortName = L["SL_SFO_INSTANCE_SHORT_NAME"], instanceId = 2481, journalInstanceId = 1195, isStatistic = false,
                requiredLevel = "60", numberOfPlayers = "10/30", locatedInZoneId = 1970, -- Zereth Mortis
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 65764 },
                    { questName = L["Heroic"], questId = 65763 },
                    { questName = L["Mythic"], questId = 65762 }
                }
            },
        }
    },
    {
        expansionName = EXPANSION_NAME9,
        raids =
        {
            -- DF: Vault of the Incarnates
            {
                instanceName = L["DF_VOI_INSTANCE_NAME"], instanceShortName = L["DF_VOI_INSTANCE_SHORT_NAME"], instanceId = 2522, journalInstanceId = 1200, isStatistic = false,
                requiredLevel = "70", numberOfPlayers = "10/30", locatedInZoneId = 2025, -- Thaldraszus
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 71018 },
                    { questName = L["Heroic"], questId = 71019 },
                    { questName = L["Mythic"], questId = 71020 }
                }
            },

            -- DF: Aberrus, the Shadowed Crucible
            {
                instanceName = L["DF_ASC_INSTANCE_NAME"], instanceShortName = L["DF_ASC_INSTANCE_SHORT_NAME"], instanceId = 2569, journalInstanceId = 1208, isStatistic = false,
                requiredLevel = "70", numberOfPlayers = "10/30", locatedInZoneId = 2133, -- Zarelek Cavern
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 76083 },
                    { questName = L["Heroic"], questId = 76085 },
                    { questName = L["Mythic"], questId = 76086 }
                }
            },

            -- DF: Amirdrassil, the Dream's Hope
            {
                instanceName = L["DF_ADH_INSTANCE_NAME"], instanceShortName = L["DF_ADH_INSTANCE_SHORT_NAME"], instanceId = 2549, journalInstanceId = 1207, isStatistic = false,
                requiredLevel = "70", numberOfPlayers = "10/30", locatedInZoneId = 2200, -- Emerald Dream
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 78600 },
                    { questName = L["Heroic"], questId = 78601 },
                    { questName = L["Mythic"], questId = 78602 }
                }
            },
        }
    },
    {
        expansionName = EXPANSION_NAME10,
        raids =
        {
            -- TWW: Nerub-ar Palace
            {
                instanceName = L["TWW_NAP_INSTANCE_NAME"], instanceShortName = L["TWW_NAP_INSTANCE_SHORT_NAME"], instanceId = 2657, journalInstanceId = 1273, isStatistic = false,
                requiredLevel = "70", numberOfPlayers = "10/30", locatedInZoneId = 2255, -- Azj-Kahet
                instanceDescriptionText = L["DEFAULT_DESCRIPTION_TEXT"],
                quests =
                {
                    { questName = L["Normal"], questId = 82629 },
                    { questName = L["Heroic"], questId = 82638 },
                    { questName = L["Mythic"], questId = 82639 }
                }
            },
        }
    }
}

function GetExpansionFromFromRaidInstanceId(instanceId)
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        for _, raid in ipairs(xpac.raids) do
            if raid.instanceId == instanceId then
                return xpac.expansionName
            end
        end
    end
    return L["(no instance name)"]
end

function GetRaidInstanceDataFromId(instanceId)
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        for _, raid in ipairs(xpac.raids) do
            if raid.instanceId == instanceId then
                return raid
            end
        end
    end
    return L["(no instance name)"]
end

function GetRaidInstanceNameFromIdInData(instanceId)
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        for _, raid in ipairs(xpac.raids) do
            if raid.instanceId == instanceId then
                return raid.instanceName
            end
        end
    end
    return L["(no instance name)"]
end

function GetQuestDisplayNameFromIdInData(questId)
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        for _, raid in ipairs(xpac.raids) do
            for _, quest in ipairs(raid.quests) do
                if quest.questId == questId then
                    return quest.questName
                end
            end
        end
    end
    return L["(no quest name)"]
end

function GetCombinedObjectivesString(questId, objectives)
    local objectivesString = L["(none)"]
    if objectives ~= nil then
        local objectiveIndex = 1
        for _, objective in ipairs(objectives) do
            if objective then
                local numFulfilled, numRequired = GetQuestObjectivesCompleted(questId, objectiveIndex)
                if objectiveIndex == 1 then
                    objectivesString = format("%i/%i", numFulfilled, numRequired)
                else
                    objectivesString = objectivesString .. format(" | %i/%i", numFulfilled, numRequired)
                end

                objectiveIndex = objectiveIndex + 1
            end
        end
    end
    return objectivesString
end

function GetCombinedObjectivesStringFromData(questId, objectives)
    local objectivesString = L["(none)"]
    if objectives ~= nil then
        local objectiveIndex = 1
        for _, objective in ipairs(objectives) do
            if objective then
                if objectiveIndex == 1 then
                    objectivesString = format("%i/%i", objective.numFulfilled, objective.numRequired)
                else
                    objectivesString = objectivesString .. format(" | %i/%i", objective.numFulfilled, objective.numRequired)
                end

                objectiveIndex = objectiveIndex + 1
            end
        end
    end
    return objectivesString
end

function IsQuestInLog(questId)
    if questId ~= nil then
        local logIndex = C_QuestLog.GetLogIndexForQuestID(questId)
        if logIndex ~= nil then
            return true
        end
    end
    return false
end

function IsQuestComplete(questId)
    if questId ~= nil then
        return C_QuestLog.IsQuestFlaggedCompleted(questId)
    end
    return false
end

function IsQuestWarbandComplete(questId)
    if questId ~= nil then
        return C_QuestLog.IsQuestFlaggedCompletedOnAccount(questId)
    end
    return false
end

function IsStatisticComplete(statisticId)
    if statisticId ~= nil then
        local statisticValue = GetStatistic(statisticId)
        if (statisticValue == nil) or (statisticValue == "--") or tonumber(statisticValue) == 0 then
            return false
        else
            return true
        end
    end
    return false
end

function GetQuestObjectivesCompleted(questId, objectiveIndex)
    if questId ~= nil then
        local _, _, _, numFulfilled, numRequired = GetQuestObjectiveInfo(questId, objectiveIndex, false)
        return numFulfilled, numRequired
    end
    return nil
end

function HasStartedAnyQuestObjective(questId)
    local objectiveIndex = 1
    local hasStartedAnyObjective = false
    local questObjectives = C_QuestLog.GetQuestObjectives(questId)
    if questObjectives then
        for _, objective in ipairs(questObjectives) do
            if objective then
                local numFulfilled, numRequired = GetQuestObjectivesCompleted(questId, objectiveIndex)
                if numFulfilled > 0 then
                    hasStartedAnyObjective = true
                    break
                end
                objectiveIndex = objectiveIndex + 1
            end
        end
    end
    return hasStartedAnyObjective
end

function DoesRaidDataHaveAnyProgressOnAnyCharacter(raidId)
    for _, player in ipairs(PlayersDataToShow) do
        for _, xpac in ipairs(player.data) do
            for _, raid in ipairs(xpac) do
                if raid.instanceId == raidId then
                    if DoesRaidDataHaveAnyProgress(raid) then
                        if KRaidSkipTracker.LibAceAddon:ToggleShowDebugOutput() then
                            print(player.playerName .. L["has progress on quest"] .. raid.instanceId)
                        end
                        return true
                    end
                end
            end
        end
    end
    return false
end

function DoesQuestDataHaveAnyProgressOnAnyCharacter(questId)
    for _, player in ipairs(PlayersDataToShow) do
        for _, xpac in ipairs(player.data) do
            for _, raid in ipairs(xpac) do
                for _, quest in ipairs(raid.quests) do
                    if quest.questId == questId then
                        if quest.isCompleted or quest.isStarted then
                            if KRaidSkipTracker.LibAceAddon:ToggleShowDebugOutput() then
                                print(player.playerName .. L["has progress on quest"] .. questId)
                            end
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

function DoesRaidDataHaveAnyProgress(raid)
    for _, quest in ipairs(raid.quests) do
        if quest.isCompleted or quest.isStarted then
            return true
        end
    end
    return false
end