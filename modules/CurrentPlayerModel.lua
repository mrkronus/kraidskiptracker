--[[-------------------------------------------------------------------------
    CurrentPlayerModel.lua
    Tracks current toon context and raid skip progress.
    Responsible for hydration from live state and persistence via SavedPlayersStore.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local kprint = KRaidSkipTracker.kprint
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local QuestHelper = KRaidSkipTracker.Modules.QuestHelper
local SavedPlayersStore = KRaidSkipTracker.Modules.SavedPlayersStore


--[[-------------------------------------------------------------------------
    CurrentPlayerModel
---------------------------------------------------------------------------]]

local CurrentPlayerModel = {}

--- Builds a structured snapshot of the current toon’s metadata and progress.
--- @return table # Snapshot containing name, realm, class, faction, progressByRaid
function CurrentPlayerModel.BuildSnapshot()
    local name = UnitName("player") or "Unknown"
    local realm = GetRealmName() or "Unknown"
    local class = select(2, UnitClass("player")) or "Unknown"
    local faction = UnitFactionGroup("player") or "Neutral"

    local snapshot = {
        name = name,
        realm = realm,
        class = class,
        faction = faction,
        isWarband = false,
        progressByRaid = {}
    }

    local allExpansions = KRaidSkipTracker.questDataByExpansion

    for _, expansion in ipairs(allExpansions or {}) do
        for _, raid in ipairs(expansion.raids or {}) do
            if raid.instanceId and raid.quests then
                local progress = {}

                for _, questInfo in ipairs(raid.quests or {}) do
                    local questId = questInfo.questId
                    if questId then
                        local complete = QuestHelper.IsQuestComplete(questId)
                        local started = QuestHelper.IsInQuestLog(questId) or QuestHelper.HasStartedAnyQuestObjective(questId)
                        local objectives = QuestHelper.GetObjectives(questId)

                        table.insert(progress, {
                            questId = questId,
                            questName = questInfo.questName,
                            isComplete = complete,
                            hasStarted = started,
                            objectives = objectives
                        })
                    end
                end

                snapshot.progressByRaid[raid.instanceId] = progress
            end
        end
    end

    return snapshot
end

--- Persists the current toon snapshot into SavedPlayersStore.
--- @param snapshot table # Output of BuildSnapshot to persist
--- @return boolean # True if successful, false otherwise
function CurrentPlayerModel.PersistSnapshot(snapshot)
    return SavedPlayersStore.Save(snapshot)
end

--- Determines if the current player has started or completed any quest in the raid.
--- @param raidId number
--- @param snapshot table
--- @return boolean
function CurrentPlayerModel.IsRaidUnlocked(raidId, snapshot)
    if not snapshot or not snapshot.progressByRaid then return false end
    local progressList = snapshot.progressByRaid[raidId]
    if not progressList then return false end

    for _, entry in ipairs(progressList) do
        if entry.hasStarted or entry.isComplete then
            return true
        end
    end

    return false
end

KRaidSkipTracker.Modules = KRaidSkipTracker.Modules or {}
KRaidSkipTracker.Modules.CurrentPlayerModel = CurrentPlayerModel