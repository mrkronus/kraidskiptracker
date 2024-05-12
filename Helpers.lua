
local addonName, KRaidSkipTracker = ...

function GetRaidInstanceNameFromIdInData(instanceId)
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        for _, raid in ipairs(xpac.raids) do
            if raid.instanceId == instanceId then
                return raid.instanceName
            end
        end
    end
    return "(no instance name)"
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
    return "(no quest name)"
end

function GetCombinedObjectivesString(questId, objectives)
    local objectivesString = "(none)"
    if objectives then
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

function IsQuestComplete(questId)
    if questId ~= nil then
        return C_QuestLog.IsQuestFlaggedCompleted(questId)
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
                        if LibAceAddon:ToggleShowDebugOutput() then
                            print(player.playerName .. " has progress on raid " .. raid.instanceId)
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
                            if LibAceAddon:ToggleShowDebugOutput() then
                                print(player.playerName .. " has progress on quest " .. questId)
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