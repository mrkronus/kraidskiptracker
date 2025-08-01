--[[-------------------------------------------------------------------------
    SavedPlayersStore.lua
    Holds persisted toon records excluding current and warband.
    Interface for loading, saving, and iterating saved characters.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local kprint = KRaidSkipTracker.kprint
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)


--[[-------------------------------------------------------------------------
    SavedPlayersStore
---------------------------------------------------------------------------]]

local SavedPlayersStore = {}

--- Loads all persisted toon snapshots from saved variables.
--- @return table<string, table> # Map of toonKey → snapshot table
function SavedPlayersStore.LoadAll()
    if not KRaidSkipTrackerDB or not KRaidSkipTrackerDB.savedPlayers then
        return {}
    end

    return KRaidSkipTrackerDB.savedPlayers
end

--- Saves a snapshot for a single toon into saved variables.
--- @param snapshot table # Output from CurrentPlayerModel.BuildSnapshot
--- @return boolean # True if save succeeded
function SavedPlayersStore.Save(snapshot)
    if not snapshot or type(snapshot) ~= "table" then
        return false
    end

    local name = snapshot.name or "UNKNOWN"
    local realm = snapshot.realm or GetRealmName() or "UNKNOWN"
    local toonKey = name .. "-" .. realm

    KRaidSkipTrackerDB.savedPlayers = KRaidSkipTrackerDB.savedPlayers or {}
    KRaidSkipTrackerDB.savedPlayers[toonKey] = snapshot

    return true
end

--- Returns an array of all persisted toon keys (for iteration).
--- @return string[] # Array of saved toon IDs
function SavedPlayersStore.ListKeys()
    local all = SavedPlayersStore.LoadAll()
    local keys = {}

    for key, _ in pairs(all) do
        table.insert(keys, key)
    end

    return keys
end

--- Retrieves a snapshot for a specific toonKey.
--- @param toonKey string # Unique identifier like "CharName-Realm"
--- @return table|nil # Snapshot table or nil if not found
function SavedPlayersStore.Load(toonKey)
    if not toonKey or type(toonKey) ~= "string" then
        return nil
    end

    local all = SavedPlayersStore.LoadAll()
    return all[toonKey]
end

KRaidSkipTracker.Modules = KRaidSkipTracker.Modules or {}
KRaidSkipTracker.Modules.SavedPlayersStore = SavedPlayersStore