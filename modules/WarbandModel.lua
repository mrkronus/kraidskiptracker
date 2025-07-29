--[[-------------------------------------------------------------------------
	Addon Data Initialization
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local kprint = KRaidSkipTracker.kprint

local KRT = LibStub("AceAddon-3.0"):GetAddon("KRaidSkipTracker")
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local function GetWarbandTable()
    local allxpacsTable = {}

    -- For each xpac
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        local xpacTable = {}

        -- For each raid in xpac
        for _, raid in ipairs(xpac.raids) do
            local raidsTable = {}

            -- For each quest in raid
            for _, quest in ipairs(raid.quests) do
                local isStarted, isCompleted = false, false

                if raid.isStatistic then
                    -- If it's a statistic
                    isCompleted = IsStatisticComplete(quest.questId)
                    isStarted = isCompleted
                else
                    -- Otherwise it's a quest
                    isCompleted = IsQuestWarbandComplete(quest.questId)
                end

                -- insert the quest data into the raids table
                local objectives = quest.objectives or {}
                table.insert(raidsTable, { isStarted = isStarted, isCompleted = isCompleted, questId = quest.questId, objectives = objectives })
            end

            -- insert the raid data into the xpacs table
            table.insert(xpacTable, { isStatistic = raid.isStatistic, instanceId = raid.instanceId, quests = raidsTable })
        end

        -- insert the xpac table into the all xpacs table
        table.insert(allxpacsTable, xpacTable)
    end

    local lastUpdateTime = GetServerTime()

    local warbandData = { playerName = "Warband", playerRealm = "", playerClass = "(none)",
        englishClass = "(none)", playerLevel = nil, playerILevel = nil, shouldShow = true,
        lastUpdateServerTime = lastUpdateTime, data = allxpacsTable }

    return warbandData
end

--[[-------------------------------------------------------------------------
	WarbandModel Initialization
---------------------------------------------------------------------------]]

KRaidSkipTracker.Models = KRaidSkipTracker.Models or {}
local WarbandModel = {}
WarbandModel.__index = WarbandModel

local PlayerModel = KRaidSkipTracker.Models.Player
local RaidTracker = KRaidSkipTracker.Services.RaidTracker

function WarbandModel:GetAllPlayers()
    local toons = KRT.db.profile.toons or {}
    local hydrated = {}

    for guid, data in pairs(toons) do
        hydrated[guid] = PlayerModel:New(data)
    end

    return hydrated
end

-- Hydrates all stored toon data from saved DB
function WarbandModel:HydrateAllToons()
    local hydrated = {}
    local rawPlayerData = self:GetAllPlayers() or {}

    for playerId, raw in pairs(rawPlayerData) do
        hydrated[playerId] = PlayerModel:New(raw)
    end

    return hydrated
end

-- Builds the warband-level unified player model
function WarbandModel:BuildWarbandEntity()
    local warbandName = "Warband"
    local displayName = "|cffffff99" .. warbandName .. "|r"
    local guid = "Warband"

    local raw = {
        id = guid,
        guid = guid,
        name = warbandName,
        realm = "Shared",
        class = "Warband", -- use special identifier
        playerName = warbandName,
        playerRealm = "Shared",
        englishClass = "Warband",
        visible = true,
        displayName = displayName,
        lastUpdateServerTime = GetServerTime(),
        skips = self:BuildWarbandSkipProgress()
    }

    return KRaidSkipTracker.Models.Player:New(raw)
end

function WarbandModel:BuildWarbandSkipProgress()
    local result = {}

    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        for _, raid in ipairs(xpac.raids) do
            for _, quest in ipairs(raid.quests) do
                local completed = IsQuestWarbandComplete(quest.questId)

                result[quest.questId] = {
                    questId = quest.questId,
                    isCompleted = completed,
                    isStarted = completed, -- warband skips are binary
                    objectives = {}
                }
                print("-> Added Warbound Quest:")
                DevTools_Dump(result[quest.questId])
            end
        end
    end

    return result
end


-- Filters visible players using current config (e.g. hiding unprogressed toons)
function WarbandModel:GetVisibleToons(allToons)
    return RaidTracker:GetVisiblePlayers(allToons)
end

-- Fully rehydrates and returns all toons, including warband
function WarbandModel:GetAllToonModels()
    local all = self:HydrateAllToons()

    local currentPlayer = self:HydrateCurrentPlayer()
    all[currentPlayer.guid] = currentPlayer

    local warband = self:BuildWarbandEntity()
    all["Warband"] = warband

    return all
end

-- Refreshes and stores visible toon list globally
function WarbandModel:RefreshVisibility(allToons)
    KRaidSkipTracker.VisiblePlayers = self:GetVisibleToons(allToons)
end

-- Optional extension: returns sorted visible toons by progress or name
function WarbandModel:GetSortedVisibleToons()
    local visible = KRaidSkipTracker.VisiblePlayers or {}
    local sorted = {}

    for _, player in pairs(visible) do
        table.insert(sorted, player)
    end

    table.sort(sorted, function(a, b)
        local sa = a.GetProgressScore and a:GetProgressScore() or 0
        local sb = b.GetProgressScore and b:GetProgressScore() or 0
        return sa > sb
    end)

    return sorted
end

function WarbandModel:GetWarbandData()
    if not self.AllPlayersData then
        KRaidSkipTracker.Services.DataMigrationService:EnsureMigrated(KRT.db.profile)
        self.AllPlayersData = self:GetAllToonModels()
        self:RefreshVisibility(self.AllPlayersData)
    end
    return self.AllPlayersData
end

function WarbandModel:ForceRefresh()
    self.AllPlayersData = self:GetAllToonModels()
    self:RefreshVisibility(self.AllPlayersData)
end

function WarbandModel:GetWarbandPlayer()
    return self.AllPlayersData and self.AllPlayersData["Warband"]
end

function WarbandModel:HydrateCurrentPlayer()
    local name, realm = UnitName("player"), GetRealmName()
    local _, class = UnitClass("player")
    local guid = UnitGUID("player")

    local raw = {
        id = guid,
        guid = guid,
        name = name,
        realm = realm,
        class = class,
        playerName = name,
        playerRealm = realm,
        englishClass = class,
        visible = true,
        displayName = name .. "\n" .. realm,
        lastUpdateServerTime = GetServerTime(),
        skips = self:BuildCurrentPlayerSkipProgress()
    }

    return KRaidSkipTracker.Models.Player:New(raw)
end

function WarbandModel:BuildCurrentPlayerSkipProgress()
    local allxpacsTable = {}

    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        local xpacTable = {}

        for _, raid in ipairs(xpac.raids) do
            local raidProgress = {}

            for _, quest in ipairs(raid.quests) do
                local isStarted = IsQuestComplete(quest.questId)
                table.insert(raidProgress, {
                    questId = quest.questId,
                    isStarted = isStarted,
                    isCompleted = isStarted,  -- same for stats
                    objectives = {}
                })
            end

            table.insert(xpacTable, raidProgress)
        end

        table.insert(allxpacsTable, xpacTable)
    end

    return allxpacsTable
end

KRaidSkipTracker.Models.WarbandModel = WarbandModel
