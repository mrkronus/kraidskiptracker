--[[-------------------------------------------------------------------------
    RaidDataHelper.lua
    Lookup and formatting tools for raid and quest metadata.
    Stateless; usable by snapshot renderers, progress scanners, and UI builders.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--[[-------------------------------------------------------------------------
    Local access
---------------------------------------------------------------------------]]

local RaidDataHelper = {}

local questData = KRaidSkipTracker.questDataByExpansion or {}


--[[-------------------------------------------------------------------------
    Expansion / Raid lookups
---------------------------------------------------------------------------]]

--- Returns the expansion name for a given raid instance ID
--- @param instanceId number
--- @return string
function RaidDataHelper.GetExpansionFromInstanceId(instanceId)
    for _, xpac in ipairs(questData) do
        for _, raid in ipairs(xpac.raids or {}) do
            if raid.instanceId == instanceId then
                return xpac.expansionName
            end
        end
    end
    return L["(no instance name)"]
end

--- Returns the full raid metadata for a given instance ID
--- @param instanceId number
--- @return table|nil
function RaidDataHelper.GetRaidData(instanceId)
    for _, xpac in ipairs(questData) do
        for _, raid in ipairs(xpac.raids or {}) do
            if raid.instanceId == instanceId then
                return raid
            end
        end
    end
    return nil
end

--- Returns the localized raid name for a given instance ID
--- @param instanceId number
--- @return string
function RaidDataHelper.GetRaidName(instanceId)
    local raid = RaidDataHelper.GetRaidData(instanceId)
    return raid and raid.instanceName or L["(no instance name)"]
end


--[[-------------------------------------------------------------------------
    Quest lookups
---------------------------------------------------------------------------]]

--- Returns the localized display name for a given quest ID
--- @param questId number
--- @return string
function RaidDataHelper.GetQuestName(questId)
    for _, xpac in ipairs(questData) do
        for _, raid in ipairs(xpac.raids or {}) do
            for _, quest in ipairs(raid.quests or {}) do
                if quest.questId == questId then
                    return quest.questName
                end
            end
        end
    end
    return L["(no quest name)"]
end


--[[-------------------------------------------------------------------------
    Objective formatters
---------------------------------------------------------------------------]]

--- Builds an objective progress string from raw API results
--- Format: "X/Y | A/B | ..."
--- @param questId number
--- @param objectives table
--- @return string
function RaidDataHelper.GetCombinedObjectivesString(questId, objectives)
    if type(questId) ~= "number" or not objectives then return L["(none)"] end

    local segments = {}
    local index = 1

    for _, _ in ipairs(objectives) do
        local numFulfilled, numRequired = GetQuestObjectivesCompleted(questId, index)
        if numFulfilled and numRequired then
            table.insert(segments, format("%d/%d", numFulfilled, numRequired))
        end
        index = index + 1
    end

    return #segments > 0 and table.concat(segments, " | ") or L["(none)"]
end

--- Builds a progress string from pre-hydrated data (e.g. snapshot)
--- @param questId number
--- @param objectives table
--- @return string
function RaidDataHelper.GetCombinedObjectivesStringFromData(questId, objectives)
    if not objectives then return L["(none)"] end

    local segments = {}
    for _, obj in ipairs(objectives) do
        if obj and obj.numFulfilled and obj.numRequired then
            table.insert(segments, format("%d/%d", obj.numFulfilled, obj.numRequired))
        end
    end

    return #segments > 0 and table.concat(segments, " | ") or L["(none)"]
end


--[[-------------------------------------------------------------------------
    Module export
---------------------------------------------------------------------------]]

KRaidSkipTracker.Modules = KRaidSkipTracker.Modules or {}
KRaidSkipTracker.Modules.RaidDataHelper = RaidDataHelper
