--[[-------------------------------------------------------------------------
    RaidSummaryBuilder.lua
    Collates toon progress to produce structured unlock summaries.
    No UI logic—just raw data for TooltipRenderer or other consumers.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local kprint = KRaidSkipTracker.kprint
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local CurrentPlayerModel = KRaidSkipTracker.Modules.CurrentPlayerModel
local WarbandModel = KRaidSkipTracker.Modules.WarbandModel
local RaidProgressScraper = KRaidSkipTracker.Modules.RaidProgressScraper

--[[-------------------------------------------------------------------------
    RaidSummaryBuilder
---------------------------------------------------------------------------]]

local RaidSummaryBuilder = {}
KRaidSkipTracker.Modules.RaidSummaryBuilder = RaidSummaryBuilder

--- Computes a full unlock summary per raid across all sources.
--- @return table[] # List of raid summaries with unlock states
function RaidSummaryBuilder.BuildSummaries()
    local scrape = RaidProgressScraper.ScrapeProgress()
    local allExpansions = KRaidSkipTracker.questDataByExpansion
    local summaries = {}

    for _, expansion in ipairs(allExpansions or {}) do
        for _, raid in ipairs(expansion.raids or {}) do
            local raidId = raid.instanceId
            local raidName = raid.instanceName

            if raidId and raidName then
                local unlockedByCurrent = false
                local unlockedByWarband = false
                local unlockedBySavedToon = false
                local savedToonUnlockers = {}

                if scrape.current then
                    unlockedByCurrent = CurrentPlayerModel.IsRaidUnlocked(raidId, scrape.current)
                end
                if scrape.warband then
                    unlockedByWarband = WarbandModel.IsRaidUnlocked(raidId, scrape.warband)
                end
                for _, saved in ipairs(scrape.saved or {}) do
                    local entries = saved.progressByRaid and saved.progressByRaid[raidId] or {}

                    for _, entry in ipairs(entries) do
                        if entry.hasStarted or entry.isComplete then
                            unlockedBySavedToon = true
                            table.insert(savedToonUnlockers, saved.name .. "-" .. saved.realm)
                            break
                        end
                    end
                end

                table.insert(summaries, {
                    raidId = raidId,
                    raidName = raidName,
                    unlockedByCurrent = unlockedByCurrent,
                    unlockedByWarband = unlockedByWarband,
                    unlockedBySavedToon = unlockedBySavedToon,
                    savedToonUnlockers = savedToonUnlockers
                })
            end
        end
    end

    return summaries
end


--- Finds a raid summary for the given raidId from a list.
--- @param raidId number
--- @param summaries table[]
--- @return table? # The matching raid summary, or nil if not found
function RaidSummaryBuilder.FindSummaryForRaid(raidId, summaries)
    for _, summary in ipairs(summaries or {}) do
        if summary.raidId == raidId then
            return summary
        end
    end
    return nil
end

--- Checks if a snapshot shows the raid unlocked.
--- @param snapshot table
--- @param raidId string
--- @return boolean
local function isRaidUnlocked(snapshot, raidId)
    local progress = snapshot.progressByRaid and snapshot.progressByRaid[raidId]
    if not progress then return false end

    for _, entry in ipairs(progress) do
        if entry.isComplete then
            return true
        end
    end

    return false
end

KRaidSkipTracker.Modules = KRaidSkipTracker.Modules or {}
KRaidSkipTracker.Modules.RaidSummaryBuilder = RaidSummaryBuilder