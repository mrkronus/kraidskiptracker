--[[-------------------------------------------------------------------------
    QuestHelper.lua
    WoW quest API wrapper (complete status, objectives, log presence).
    Stateless, safe for use by all player models and progress scrapers.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local kprint = KRaidSkipTracker.kprint
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--[[-------------------------------------------------------------------------
    QuestHelper
---------------------------------------------------------------------------]]

local QuestHelper = {}

--- Checks whether a specific quest is flagged as completed by Blizzard API.
--- @param questID number # Quest ID to check
--- @return boolean # True if quest is completed, false otherwise
function QuestHelper.IsQuestComplete(questID)
    if not questID or type(questID) ~= "number" then
        return false
    end

    return C_QuestLog.IsQuestFlaggedCompleted(questID) == true
end

--- Retrieves objective details for a quest if it exists in the player's log.
--- @param questID number # Quest ID whose objectives should be retrieved
--- @return table|nil # Array of {text:string, finished:boolean} or nil
function QuestHelper.GetObjectives(questID)
    if not questID or type(questID) ~= "number" then
        return nil
    end

    local index = C_QuestLog.GetLogIndexForQuestID(questID)
    if not index then
        return nil
    end

    local info = C_QuestLog.GetInfo(index)
    if not info or not info.objectives then
        return nil
    end

    local objectives = {}
    for _, objective in ipairs(info.objectives) do
        table.insert(objectives, {
            text = objective.text or "",
            finished = objective.finished or false
        })
    end

    return objectives
end

--- Determines if a given quest exists in the active player's quest log.
--- @param questID number # Quest ID to check
--- @return boolean # True if found in quest log, false otherwise
function QuestHelper.IsInQuestLog(questID)
    if not questID or type(questID) ~= "number" then
        return false
    end

    local index = C_QuestLog.GetLogIndexForQuestID(questID)
    return index ~= nil
end

function QuestHelper.IsWarbandQuestComplete(questId)
    return type(questId) == "number" and C_QuestLog.IsQuestFlaggedCompletedOnAccount(questId)
end

function QuestHelper.HasStartedAnyQuestObjective(questId)
    if type(questId) ~= "number" then return false end
    local objectives = C_QuestLog.GetQuestObjectives(questId)
    if not objectives then return false end

    for index, _ in ipairs(objectives) do
        local numFulfilled = select(4, GetQuestObjectiveInfo(questId, index, false))
        if numFulfilled and numFulfilled > 0 then
            return true
        end
    end
    return false
end


KRaidSkipTracker.Modules = KRaidSkipTracker.Modules or {}
KRaidSkipTracker.Modules.QuestHelper = QuestHelper