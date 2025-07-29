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
RaidModel.__index = RaidModel

function RaidModel:New(data)
    local self = setmetatable({}, RaidModel)

    self.expansion          = data.expansion
    self.instanceId         = data.instanceId
    self.journalInstanceId  = data.journalInstanceId
    self.zoneId             = data.locatedInZoneId
    self.name               = data.instanceName
    self.shortName          = data.instanceShortName
    self.description        = data.instanceDescriptionText
    self.isStatistic        = data.isStatistic
    self.difficultyQuests   = {}

    for _, quest in ipairs(data.quests) do
        local name = quest.questName:lower()
        local difficulty = name:find("mythic") and "Mythic"
            or name:find("heroic") and "Heroic"
            or "Normal"
        self.difficultyQuests[difficulty] = {
            questId = quest.questId,
            unlocksLowerTiers = quest.unlocksLowerTiers or false
        }
    end

    return self
end

function RaidModel:GetHighestDifficultyUnlocked(playerProgress)
    playerProgress = playerProgress or {}
    local DIFFICULTY_ORDER = { "Mythic", "Heroic", "Normal" }
    for _, tier in ipairs(DIFFICULTY_ORDER) do
        local questInfo = self.difficultyQuests[tier]
        local data = questInfo and playerProgress[questInfo.questId]
        if data and data.isCompleted then
            return tier
        end
    end
    return nil
end

function RaidModel:GetSkipSummary(player)
    local playerProgress = player:GetProgressForRaid(self.instanceId)
    local tier = self:GetHighestDifficultyUnlocked(playerProgress)
    if not tier then
        return KRaidSkipTracker.TextIcons.RedX .. " " .. L["Not yet unlocked"]
    end

    local icons = {
        Normal = KRaidSkipTracker.TextIcons.GreenCheck,
        Heroic = KRaidSkipTracker.TextIcons.HeroicIcon,
        Mythic = KRaidSkipTracker.TextIcons.MythicIcon
    }

    local label = tier == "Mythic" and L["All difficulties unlocked"]
               or tier == "Heroic" and L["Unlocked up to Heroic"]
               or L["Unlocked: "] .. tier

    return icons[tier] .. " " .. colorize(label, KRaidSkipTracker.Colors.Highlight)
end

function RaidModel:GetAll()
    local hydratedRaids = {}

    for _, expansionBlock in ipairs(KRaidSkipTracker.questDataByExpansion) do
        for _, raidData in ipairs(expansionBlock.raids) do
            raidData.expansion = expansionBlock.expansionName

            local raidModel = KRaidSkipTracker.Models.Raid:New(raidData)
            table.insert(hydratedRaids, raidModel)
        end
    end

    return hydratedRaids
end


KRaidSkipTracker.Models.Raid = RaidModel
