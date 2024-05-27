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
    type = "group",
    args = {
        alwaysShowAllRaidHeadings = {
            type = "toggle",
            width = "full",
            order = 1,
            name = "Always show all raid headings",
            desc = "Forces all raid headers to awlays be shown, regardless of other settings.",
            get = "ShouldAlwaysShowAllRaidHeadings",
            set = "ToggleAlwaysShowAllRaidHeadings",
        },
        hideNoProgressRaids = {
            type = "toggle",
            width = "full",
            order = 2,
            name = "Hide raid quests with no progress",
            desc = "Toggles the display of raids that have have no progression on any shown characters.",
            get = "ShouldHideNoProgressRaids",
            set = "ToggleHideNoProgressRaids",
        },
        hideNoProgressToons = {
            type = "toggle",
            width = "full",
            order = 3,
            disabled = true,
            name = "Hide characters with no progress",
            desc = "Toggles the display of characters that have have no progression on any shown raids.",
            get = "ShouldHideNoProgressToons",
            set = "ToggleHideNoProgressToons",
        },
        showOnlyCurrentRealm = {
            type = "toggle",
            width = "full",
            order = 4,
            name = "Show current realm only",
            desc = "Toggles hiding all characters from realms other than " .. GetRealmName() .. ".",
            get = "ShouldShowOnlyCurrentRealm",
            set = "ToggleShowOnlyCurrentRealm",
        },
        fitToScreen = {
            type = "toggle",
            width = "full",
            order = 50,
            name = "Fit window to screen",
            desc = "Scales the entire window to fit on the screen. Useful if you have many characters and content would otherwise run off the side of the screen.",
            get = "ShouldFitToScreen",
            set = "ToggleFitToScreen",
        },
        showDebugOutput = {
            type = "toggle",
            width = "full",
            order = 100,
            name = "Show debug output in chat",
            desc = "Toggles the display debugging Text in the chat window. " ..
            colorize("Recommended to leave off.", KRaidSkipTracker.Colors.Red),
            get = "ShouldShowDebugOutput",
            set = "ToggleShowDebugOutput",
            confirm = true
        },
    },
}
local aceOptionsDefaults = {
    profile =  {
        hideNoProgressRaids = false,
        hideNoProgressToons = false,
        alwaysShowAllRaidHeadings = false,
        showOnlyCurrentRealm = true,
        fitToScreen = true,
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

function LibAceAddon:ShouldAlwaysShowAllRaidHeadings(info)
    return self.db.profile.alwaysShowAllRaidHeadings
end

function LibAceAddon:ToggleAlwaysShowAllRaidHeadings(info, value)
    self.db.profile.alwaysShowAllRaidHeadings = value
end

function LibAceAddon:ShouldShowOnlyCurrentRealm(info)
    return self.db.profile.showOnlyCurrentRealm
end

function LibAceAddon:ToggleShowOnlyCurrentRealm(info, value)
    self.db.profile.showOnlyCurrentRealm = value
end

function LibAceAddon:ShouldFitToScreen(info)
    return self.db.profile.fitToScreen
end

function LibAceAddon:ToggleFitToScreen(info, value)
    self.db.profile.fitToScreen = value
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

    if LibAceAddon:ShouldFitToScreen() then
        local toolTipScale = tooltip:GetScale()
        local toolTipWidth, toolTipHeight = tooltip:GetSize()
        local parentWidth, parentHeight = UIParent:GetSize()
        toolTipWidth = toolTipWidth * toolTipScale
        toolTipHeight = toolTipHeight * toolTipScale
        if toolTipWidth > parentWidth or toolTipHeight > parentHeight then
            toolTipScale = toolTipScale / math.max(toolTipWidth / parentWidth, toolTipHeight / parentHeight)
            toolTipScale = toolTipScale * 0.95 -- scale it down just a bit more to make it look nicer
            tooltip:SetScale(toolTipScale)
        end
    else
        tooltip:UpdateScrolling()
    end

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
