--[[-------------------------------------------------------------------------
	Addon Data Initialization
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local kprint = KRaidSkipTracker.kprint

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--[[-------------------------------------------------------------------------
	RaidModel Initialization
---------------------------------------------------------------------------]]

KRaidSkipTracker.Models = KRaidSkipTracker.Models or {}
local RaidModel = {}
KRaidSkipTracker.Models.Raid = RaidModel
RaidModel.__index = RaidModel

function RaidModel:New(data)
    local self = setmetatable({}, RaidModel)

    self.instanceId         = data.instanceId
    self.journalInstanceId = data.journalInstanceId
    self.zoneId            = data.locatedInZoneId
    self.name              = data.instanceName
    self.shortName         = data.instanceShortName
    self.description       = data.instanceDescriptionText
    self.isStatistic       = data.isStatistic
    self.difficultyQuests  = {}

    for _, quest in ipairs(data.quests) do
        local difficulty = quest.questName:match("Normal") and "Normal"
                      or quest.questName:match("Heroic") and "Heroic"
                      or "Mythic"
        self.difficultyQuests[difficulty] = {
            questId = quest.questId,
            unlocksLowerTiers = quest.unlocksLowerTiers or false
        }
    end

    return self
end

function RaidModel:GetHighestDifficultyUnlocked(playerProgress)
    for _, tier in ipairs({ "Mythic", "Heroic", "Normal" }) do
        local questInfo = self.difficultyQuests[tier]
        if questInfo and playerProgress:IsQuestComplete(questInfo.questId) then
            return tier
        end
    end
    return nil
end

function RaidModel:GetSkipSummary(player)
    local tier = self:GetHighestDifficultyUnlocked(player)
    if not tier then
        return KRaidSkipTracker.TextIcons.RedX .. " " .. L["Not yet unlocked"]
    end

    local icons = {
        Normal = KRaidSkipTracker.TextIcons.GreenCheck,
        Heroic = KRaidSkipTracker.TextIcons.HeroicIcon or KRaidSkipTracker.TextIcons.YellowCheck,
        Mythic = KRaidSkipTracker.TextIcons.MythicIcon or KRaidSkipTracker.TextIcons.OrangeStar
    }

    local label = tier == "Mythic" and L["All difficulties unlocked"]
               or tier == "Heroic" and L["Unlocked up to Heroic"]
               or L["Unlocked: "] .. tier

    return icons[tier] .. " " .. colorize(label, KRaidSkipTracker.Colors.Highlight)
end
KRaidSkipTracker.Models.RaidModel = RaidModel
