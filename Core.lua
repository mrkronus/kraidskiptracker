--[[-------------------------------------------------------------------------
	Addon Data Initialization
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local kprint = KRaidSkipTracker.kprint

local L = LibStub("AceLocale-3.0"):GetLocale(addonName)
local KRT = LibStub("AceAddon-3.0"):GetAddon("KRaidSkipTracker")


--[[-------------------------------------------------------------------------
	Core module Initialization
---------------------------------------------------------------------------]]

local function MigrateLegacyData(profile)
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

        profile.players = nil
        kprint("Migrated legacy player data (" .. tostring(#oldData) .. " entries).")
    end

    profile.dataVersion = 1
end

function KRT:Initialize()
    self.db = KRT.db
    local profile = self.db.profile

    profile.dataVersion = profile.dataVersion or 0
    profile.allPlayersData = profile.allPlayersData or {}

    --if profile.dataVersion == 0 then
    --    MigrateLegacyData(profile)
    --end

    --PlayerModel:Initialize(profile.allPlayersData)
    --PlayerModel:InjectOptions(KRaidSkipTracker.options.args.characterSettings.args)

    KRT:EnableModule("MinimapIcon")
    KRT:EnableModule("MinimapTooltip")

    --kprint("KRaidSkipTracker initialized with " .. tostring(#PlayerModel:GetAllPlayers()) .. " tracked players.")
end
