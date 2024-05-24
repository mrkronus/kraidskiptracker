--
-- Addon data initialization
--
local addonName, KRaidSkipTracker = ...

--
-- AceAddon initialization
--
LibAceAddon = LibStub("AceAddon-3.0"):NewAddon("KRaidSkipTracker", "AceConsole-3.0", "AceEvent-3.0")

local aceOptions = {
    name = "K Raid Skip Tracker",
    handler = LibAceAddon,
    type = 'group',
    args = {
        hideNoProgressRaids = {
            type = "toggle",
            name = "Hide no progress raids",
            desc = "Toggles the display of raids that have have no progression on any shown characters.",
            get = "ShouldHideNoProgressRaids",
            set = "ToggleHideNoProgressRaids",
        },
        hideNoProgressToons = {
            type = "toggle",
            name = "Hide no progress characters",
            desc = "Toggles the display of characters that have have no progression on any shown raids.",
            get = "ShouldHideNoProgressToons",
            set = "ToggleHideNoProgressToons",
        },
        showOnlyCurrentRealm = {
            type = "toggle",
            name = "Current realm only",
            desc = "Toggles hiding all characters from realms other than " .. GetRealmName() .. ".",
            get = "ShouldShowOnlyCurrentRealm",
            set = "ToggleShowOnlyCurrentRealm",
        },
        showDebugOutput = {
            type = "toggle",
            name = "Show debug output",
            desc = "Toggles the display debugging Text in the chat window. Recommended to leave off.",
            get = "ShouldShowDebugOutput",
            set = "ToggleShowDebugOutput",
        },
    },
}

local aceOptionsDefaults = {
    profile =  {
        hideNoProgressRaids = false,
        hideNoProgressToons = false,
        showOnlyCurrentRealm = true,
        showDebugOutput = false,
    },
}

function LibAceAddon:ShouldHideNoProgressRaids(info)
    return self.db.profile.hideNoProgressRaids
end

function LibAceAddon:ToggleHideNoProgressRaids(info, value)
    self.db.profile.hideNoProgressRaids = value
end

function LibAceAddon:ShouldHideNoProgressToons(info)
    return self.db.profile.hideNoProgressToons
end

function LibAceAddon:ToggleHideNoProgressToons(info, value)
    self.db.profile.hideNoProgressToons = value
end

function LibAceAddon:ShouldShowDebugOutput(info)
    return self.db.profile.showDebugOutput
end

function LibAceAddon:ToggleShowDebugOutput(info, value)
    self.db.profile.showDebugOutput = value
end

function LibAceAddon:ShouldShowOnlyCurrentRealm(info)
    return self.db.profile.showOnlyCurrentRealm
end

function LibAceAddon:ToggleShowOnlyCurrentRealm(info, value)
    self.db.profile.showOnlyCurrentRealm = value
end

function LibAceAddon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KRaidSkipTrackerDB", aceOptionsDefaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("KRaidSkipTracker", aceOptions, {"kraidskiptracker", "krst"})
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("KRaidSkipTracker", "KRaidSkipTracker")

    KRaidSkipTracker.Initialize()

    self.db.profile.dataVersion = KRaidSkipTracker.GetCurrentDataVersion()
    self.db.profile.allPlayersData = KRaidSkipTracker.GetAllPlayersData()
end

function LibAceAddon:GetDBAllPlayersData()
    if self.db.profile.allPlayersData == nil then
        return {}
    end
    return self.db.profile.allPlayersData
end

function LibAceAddon:GetDBDataVersion()
    if self.db.profile.dataVersion == nil then
        return "0.0.0"
    end
    return self.db.profile.dataVersion
end

--
-- LibDB initialization
--
LibQTip = LibStub('LibQTip-1.0')
local LibDataBroker = LibStub("LibDataBroker-1.1")

function tipOnClick(clickedframe, button)
    if button == "RightButton" then
        Settings.OpenToCategory("KRaidSkipTracker")
    end
end

local function tipOnEnter(self)
    if self.tooltip then
        self.tooltip:Release()
        self.tooltip = nil
    end

    KRaidSkipTracker.UpdateCurrentPlayerData()
    local tooltip = LibQTip:Acquire("KKeyedTooltip", 1, "LEFT")
    self.tooltip = tooltip

    KRaidSkipTracker.PopulateTooltip(tooltip)

	tooltip:SetAutoHideDelay(0.01, self)
    tooltip:SmartAnchorTo(self)
	tooltip:UpdateScrolling()
    tooltip:Show()
end

local function tipOnLeave(self)
    -- Do nothing
end

--
-- LibDBIcon initialization
--
local dataobj = LibDataBroker:NewDataObject("K Keyed", {
    type = "launcher",
    icon = [[Interface/Icons/Inv_misc_key_15]],
    OnClick = tipOnClick,
    OnLeave = tipOnLeave,
    OnEnter = tipOnEnter
})

local libIcon = LibStub("LibDBIcon-1.0", true)
libIcon:Register("K Keyed", dataobj, KKeyedDB)
libIcon:Show("K Keyed")
