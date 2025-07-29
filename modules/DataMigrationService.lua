--[[-------------------------------------------------------------------------
    DataMigrationService
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local DataMigrationService = {}
DataMigrationService.__index = DataMigrationService

local kprint = KRaidSkipTracker.kprint

-- Migrates legacy player data stored as 'players' into the new 'allPlayersData' structure
function DataMigrationService:EnsureMigrated(profile)
    profile.dataVersion = profile.dataVersion or 0

    if profile.dataVersion >= 1 then
        return -- Already migrated
    end

    local oldData = profile.players or {}
    if next(oldData) then
        profile.allPlayersData = {}

        for key, info in pairs(oldData) do
            local guid = info.guid or key
            profile.allPlayersData[guid] = {
                guid        = guid,
                name        = info.name,
                realm       = info.realm or GetRealmName(),
                class       = info.class,
                spec        = info.spec,
                progress    = info.progress or {},
                lastSeen    = info.lastSeen or time(),
                isIgnored   = info.isIgnored,
                displayName = info.displayName or info.name,
            }
        end

        profile.players = nil -- Clean up legacy field
        kprint("Migrated legacy player data (" .. tostring(#oldData) .. " entries).")
    end

    profile.dataVersion = 1
end

KRaidSkipTracker.Services.DataMigrationService = DataMigrationService
