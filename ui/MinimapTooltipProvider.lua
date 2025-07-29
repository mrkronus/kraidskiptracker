--[[-------------------------------------------------------------------------
	Data Initialization
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local kprint = KRaidSkipTracker.kprint
local Colors = KRaidSkipTracker.Colors
local Fonts = KRaidSkipTracker.Fonts

local addonName = KRaidSkipTracker.Settings.AddonName
local addonTooltipName = KRaidSkipTracker.Settings.AddonTooltipName
local addonVersion = KRaidSkipTracker.Settings.Version
local addonNameWithIcon = KRaidSkipTracker.Settings.AddonNameWithIcon

---@class ParentAceAddon : AceAddon
local ParentAceAddon = LibStub("AceAddon-3.0"):GetAddon(addonName)

local MinimapTooltip = ParentAceAddon:GetModule("MinimapTooltip")
local MinimapIcon = ParentAceAddon:GetModule("MinimapIcon")


--[[-------------------------------------------------------------------------
	Minimap Tooltip Provider
---------------------------------------------------------------------------]]

local TooltipProvider = {}

MinimapIcon:SetClickCallback(function(...) TooltipProvider:OnIconClick(...) end)
MinimapTooltip:SetProvider(TooltipProvider)


--[[-------------------------------------------------------------------------
	Event Handlers
---------------------------------------------------------------------------]]

function TooltipProvider:OnIconClick(clickedframe, button)
    if button == "LeftButton" then
         --Kollector.ItemBrowserController:Show()
    end

    if button == "RightButton" then
        Settings.OpenToCategory(addonName)
    end
end

--[[-------------------------------------------------------------------------
	PopulateTooltip
---------------------------------------------------------------------------]]

function TooltipProvider:PopulateTooltip(tooltip)
    -- Apply horizontal margin before adding data
    tooltip:SetCellMarginH(16)
    tooltip:SetCellMarginV(6)

    -- Ensure Data is primed (TODO: move this somewhere else)
    _ = KRaidSkipTracker.Models.WarbandModel:GetWarbandData()

    -- Ensure we have enough columns for however many players we will show
    -- TODO: move this to a method
    local numVisiblePlayers = #KRaidSkipTracker.VisiblePlayers
    local warbandIncluded = false

    -- Check if warband is among visible players
    for _, player in ipairs(KRaidSkipTracker.VisiblePlayers) do
        if player.guid == "Warband" then
            warbandIncluded = true
            break
        end
    end

    local extraColumns = warbandIncluded and 1 or 0
    local totalColumns = 1 + numVisiblePlayers + extraColumns -- 1 for raid name

    local colIndex = 2  -- starting at column 2 since column 1 is raid name
    while colIndex <= totalColumns do
        tooltip:AddColumn()
        colIndex = colIndex + 1
    end

    tooltip:SetFont("KLib_MainHeaderFont")
    local y, x = tooltip:AddLine()
    tooltip:SetCell(y, 1, colorize(addonNameWithIcon, Colors.Header))
    tooltip:SetCell(y, 2, colorize(addonVersion, Colors.Grey))

    tooltip:AddSeparator(3, 0, 0, 0, 0)
    tooltip:AddSeparator()
    tooltip:AddSeparator(3, 0, 0, 0, 0)

    local Builder       = KRaidSkipTracker.TooltipRowBuilder
    local raids         = KRaidSkipTracker.Models.Raid:GetAll()
    local players       = KRaidSkipTracker.VisiblePlayers
    local warbandPlayer = KRaidSkipTracker.Models.WarbandModel:GetWarbandPlayer()

    Builder:AddHeaderRow(tooltip, players)

    local lastExpansion = nil
    for _, raid in ipairs(raids) do
        if raid.expansion ~= lastExpansion then
            Builder:AddExpansionBreak(tooltip, raid.expansion)
            lastExpansion = raid.expansion
        end
        Builder:AddRaidRow(tooltip, raid, warbandPlayer, players)
    end

    tooltip:AddSeparator(3, 0, 0, 0, 0)
    tooltip:AddSeparator()
    tooltip:AddSeparator(3, 0, 0, 0, 0)

    Builder:AddFooter(tooltip)
end