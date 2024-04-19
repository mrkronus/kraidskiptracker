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
        hideNotStarted = {
            type = "toggle",
            name = "Hide not started skips",
            desc = "Toggles the display of skips that have have no progression",
            get = "ShouldHideNotStarted",
            set = "ToggleHideNotStarted",
        },
        showDebugOutput = {
            type = "toggle",
            name = "Show Debug Output",
            desc = "Toggles the display debugging Text in the chat window. Recommended to leave off.",
            get = "ShouldShowDebugOutput",
            set = "ToggleShowDebugOutput",
        },
    },
}

local aceOptionsDefaults = {
    profile =  {
        hideNotStarted = false,
    },
}

function LibAceAddon:ShouldHideNotStarted(info)
    return self.db.profile.hideNotStarted
end

function LibAceAddon:ToggleHideNotStarted(info, value)
    self.db.profile.hideNotStarted = value
end

function LibAceAddon:ShouldShowDebugOutput(info)
    return self.db.profile.showDebugOutput
end

function LibAceAddon:ToggleShowDebugOutput(info, value)
    self.db.profile.showDebugOutput = value
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
    KRaidSkipTracker.UpdateCurrentPlayerData()
    local tooltip = LibQTip:Acquire("KKeyedTooltip", 2, "LEFT", "RIGHT")
    self.tooltip = tooltip

    KRaidSkipTracker.PopulateTooltip(tooltip)

	tooltip:SetAutoHideDelay(0.01, self)
    tooltip:SmartAnchorTo(self)
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
