
local addonName, KRaidSkipTracker = ...

function IsQuestComplete(questId)
    if questId ~= nil then
        return C_QuestLog.IsQuestFlaggedCompleted(questId)
    else
        return nil
    end
end

function HasStartedAnyQuestObjective(questId)
    local questObjectives = C_QuestLog.GetQuestObjectives(questId)
    local hasStartedAnyObjective = false
    if questObjectives then
        for _,objective in ipairs(questObjectives) do
            if objective then
                if objective.numFulfilled > 0 then
                    hasStartedAnyObjective = true
                    break
                end
            end
        end
    end
    return hasStartedAnyObjective
end

function IsStatisticComplete(statisticId)
    if statisticId ~= nil then
        local statisticValue = GetStatistic(statisticId)
        if (statisticValue == nil) or (statisticValue == "--") or tonumber(statisticValue) == 0 then
            return false
        else
            return true
        end
    else
        return nil
    end
end

function GetQuestObjectivesCompleted(questId, objectiveIndex)
    if questId ~= nil then
        local questText, questObjectiveType, isFinished, numFulfilled, numRequired = GetQuestObjectiveInfo(questId, objectiveIndex, false)
        return numFulfilled, numRequired
    end
    return nil
end

function DoesExpansionHaveAnyProgress(xpac)
    for _, raid in ipairs(xpac.raids) do
        for _, quest in ipairs(raid.quests) do
            if raid.isStatistic then
                if IsStatisticComplete(quest.questId) then
                    return true
                end
            else
                if HasStartedAnyQuestObjective(quest.questId) then
                    return true
                end
            end
        end
    end
    return false
end