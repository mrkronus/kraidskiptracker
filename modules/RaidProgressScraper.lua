--[[-------------------------------------------------------------------------
    RaidProgressScraper.lua
    Central pipeline to gather progress snapshots across all toon types.
    No filtering or formatting—raw data for use by summary and UI layers.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local kprint = KRaidSkipTracker.kprint
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local CurrentPlayerModel = KRaidSkipTracker.Modules.CurrentPlayerModel
local WarbandModel = KRaidSkipTracker.Modules.WarbandModel
local SavedPlayersStore = KRaidSkipTracker.Modules.SavedPlayersStore

--[[-------------------------------------------------------------------------
    RaidProgressScraper
---------------------------------------------------------------------------]]

local RaidProgressScraper = {}

--- Gathers raw progress snapshots for current player, warband, and saved toons.
--- @return table # Scraped result with 'current', 'warband', and 'saved' fields
function RaidProgressScraper.ScrapeProgress()
    local result = {
        current = CurrentPlayerModel.BuildSnapshot(),
        warband = WarbandModel.BuildSnapshot(),
        saved = {}
    }

    local savedSnapshots = SavedPlayersStore.LoadAll() or {}
    for _, snapshot in ipairs(savedSnapshots) do
        table.insert(result.saved, snapshot)
    end

    return result
end

KRaidSkipTracker.Modules = KRaidSkipTracker.Modules or {}
KRaidSkipTracker.Modules.RaidProgressScraper = RaidProgressScraper