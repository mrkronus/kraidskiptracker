--[[-------------------------------------------------------------------------
	Addon Data Initialization
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local kprint = KRaidSkipTracker.kprint

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--[[-------------------------------------------------------------------------
	RaidModel Initialization
---------------------------------------------------------------------------]]

KRaidSkipTracker.Services = KRaidSkipTracker.Services or {}
local RaidTracker = {}
RaidTracker.__index = RaidTracker

function RaidTracker:GetVisiblePlayers(allPlayers)
    local visible = {}
    for charId, raw in pairs(allPlayers or {}) do
        local player = type(raw) == "table" and raw._isPlayerModel
            and raw or KRaidSkipTracker.Models.Player:New(raw)
        if player:ShouldBeDisplayed() then
            table.insert(visible, player)
        end
    end
    return visible
end

function RaidTracker:ShouldDisplayRaid(raid, visiblePlayers)
    if KRaidSkipTracker.LibAceAddon:ShouldHideNoProgressRaids() == false then return true end
    for _, player in ipairs(visiblePlayers) do
        if player:HasAnyRaidSkip(raid.instanceId) then
            return true
        end
    end
    return false
end

function RaidTracker:GetRaidSummary(raidModel, visiblePlayers)
    local summary = {
        raid = raidModel,
        perPlayer = {},
        warbandProgress = raidModel:GetSkipSummary(KRaidSkipTracker.WarbandPlayer)
    }
    for _, player in ipairs(visiblePlayers) do
        summary.perPlayer[player.name .. "-" .. player.realm] = raidModel:GetSkipSummary(player)
    end
    return summary
end

KRaidSkipTracker.Services.RaidTracker = RaidTracker