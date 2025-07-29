--[[-------------------------------------------------------------------------
    PlayerModel
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local kprint = KRaidSkipTracker.kprint

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--[[-------------------------------------------------------------------------
	PlayerModel Initialization
---------------------------------------------------------------------------]]

KRaidSkipTracker.Models = KRaidSkipTracker.Models or {}
local PlayerModel = {}
PlayerModel.__index = PlayerModel

function PlayerModel:New(raw)
    raw = raw or {}
    local self = setmetatable({}, PlayerModel)

    self.id             = raw.id
    self.guid           = raw.guid or raw.id
    self.name           = raw.name or raw.playerName or "Unknown"
    self.realm          = raw.realm or GetRealmName()
    self.class          = raw.class or raw.playerClass or "(none)"
    self.visible        = raw.visible ~= false
    self.displayName    = raw.displayName or (self.name .. "\n" .. self.realm)

    local skips = raw.skips or raw.progress or {}
    local normalized = {}

    for _, raidQuests in pairs(skips) do
        for _, quest in ipairs(raidQuests) do
            if quest.questId then
                normalized[quest.questId] = quest
            end
        end
    end

    self.skips = normalized

    return self
end

function PlayerModel:GetProgressForRaid(instanceId)
    return self.skips and self.skips[instanceId] or {}
end

-- Returns true if this toon has started the given quest
function PlayerModel:HasQuest(questId)
    for _, raidQuests in pairs(self.skips) do
        if raidQuests[questId] and raidQuests[questId].isStarted then
            return true
        end
    end
    return false
end

-- Returns true if this toon has completed the given quest
function PlayerModel:IsQuestComplete(questId)
    for _, raidQuests in pairs(self.skips) do
        if type(raidQuests) == "table" and raidQuests[questId] and raidQuests[questId].isCompleted then
            return true
        end
    end
    return false
end

-- Returns true if this toon should be shown in tooltips/UI
function PlayerModel:ShouldBeDisplayed()
    if not self.visible then return false end

    if KRaidSkipTracker.LibAceAddon:ShouldShowOnlyCurrentRealm() then
        if self.realm ~= GetRealmName() then return false end
    end

    if KRaidSkipTracker.LibAceAddon:ShouldShowOnlyQuestHolders() then
        for _, raidQuests in pairs(self.skips) do
            for _, quest in pairs(raidQuests) do
                if quest.isStarted then return true end
            end
        end
        return false
    end

    return true
end

KRaidSkipTracker.Models.Player = PlayerModel
