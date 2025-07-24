--[[-------------------------------------------------------------------------
	Addon Data Initialization
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local kprint = KRaidSkipTracker.kprint

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--[[-------------------------------------------------------------------------
	PlayerModel Initialization
---------------------------------------------------------------------------]]

KRaidSkipTracker.Models = KRaidSkipTracker.Models or {}
local PlayerModel = {}
KRaidSkipTracker.Models.Player = PlayerModel
PlayerModel.__index = PlayerModel

function PlayerModel:New(data)
    local self = setmetatable({}, PlayerModel)

    self.name       = data.playerName
    self.realm      = data.playerRealm
    self.class      = data.englishClass
    self.level      = data.playerLevel
    self.iLevel     = data.playerILevel
    self.visible    = data.shouldShow or true
    self.lastUpdate = data.lastUpdateServerTime
    self.skips      = {}  -- keyed by instanceId

    for xpacIndex, xpac in ipairs(data.data or {}) do
        for raidIndex, raidData in ipairs(xpac) do
            local raidSkips = {}
            for _, questData in ipairs(raidData.quests) do
                raidSkips[questData.questId] = {
                    isCompleted = questData.isCompleted,
                    isStarted   = questData.isStarted,
                    objectives  = questData.objectives
                }
            end
            self.skips[raidData.instanceId] = raidSkips
        end
    end

    return self
end

function PlayerModel:HasQuest(questId)
    for _, raidQuests in pairs(self.skips) do
        if raidQuests[questId] and raidQuests[questId].isStarted then
            return true
        end
    end
    return false
end

function PlayerModel:IsQuestComplete(questId)
    for _, raidQuests in pairs(self.skips) do
        if raidQuests[questId] and raidQuests[questId].isCompleted then
            return true
        end
    end
    return false
end

function PlayerModel:ShouldBeDisplayed()
    if not self.visible then return false end

    if KRaidSkipTracker.LibAceAddon:ShouldShowOnlyCurrentRealm() then
        if self.realm ~= GetRealmName() then
            return false
        end
    end

    if KRaidSkipTracker.LibAceAddon:ShouldShowOnlyQuestHolders() then
        for _, raidQuests in pairs(self.skips or {}) do
            for _, quest in pairs(raidQuests) do
                if quest.isStarted then
                    return true
                end
            end
        end
        return false
    end

    return true
end

