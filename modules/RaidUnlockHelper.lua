--[[-------------------------------------------------------------------------
    RaidUnlockHelper.lua
    Placeholder for centralized raid unlock logic.
    May be used to abstract repeated checks across summary and UI layers.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local kprint = KRaidSkipTracker.kprint
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--[[-------------------------------------------------------------------------
    RaidUnlockHelper
---------------------------------------------------------------------------]]

local RaidUnlockHelper = {}

--- Determines if a snapshot shows the raid as unlocked.
--- NOTE: Implementation pending
--- @param snapshot table
--- @param raidId string
--- @return boolean
function RaidUnlockHelper.IsRaidUnlocked(snapshot, raidId)
    -- TODO: Delegate logic from RaidSummaryBuilder
    return false
end

--- Extracts unlock source label from summary.
--- NOTE: Implementation pending
--- @param summary table
--- @return string # "Current", "Warband", "Saved", or "None"
function RaidUnlockHelper.GetUnlockSource(summary)
    -- TODO: Use summary fields to return display label
    return "None"
end

KRaidSkipTracker.Modules = KRaidSkipTracker.Modules or {}
KRaidSkipTracker.Modules.RaidUnlockHelper = RaidUnlockHelper