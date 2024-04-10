--
-- Addon data initialization
--
local addonName, KRaidSkipTracker = ...

--
-- AceAddon initialization
--
LibAceAddon = LibStub("AceAddon-3.0"):NewAddon("KRaidSkipTracker", "AceConsole-3.0", "AceEvent-3.0")

local aceOptions = {
    name = "KRaidSkipTracker",
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

function LibAceAddon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KRaidSkipTrackerDB", aceOptionsDefaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("KRaidSkipTracker", aceOptions, {"kraidskiptracker", "krst"})
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("KRaidSkipTracker", "KRaidSkipTracker")
end

--
-- LibDB initialization
--
local LibQTip = LibStub('LibQTip-1.0')
local LibDataBroker = LibStub("LibDataBroker-1.1")

function tipOnClick(clickedframe, button)
    if button == "RightButton" then
        Settings.OpenToCategory("KRaidSkipTracker")
    end
end

local function tipOnEnter(self)
    local tooltip = LibQTip:Acquire("KKeyedTooltip", 2, "LEFT", "RIGHT")
    self.tooltip = tooltip

    KRaidSkipTracker.PopulateTooltip(tooltip)

    tooltip:SmartAnchorTo(self)
    tooltip:Show()
end

local function tipOnLeave(self)
    LibQTip:Release(self.tooltip)
    self.tooltip = nil
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
