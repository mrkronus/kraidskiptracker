--[[-------------------------------------------------------------------------
    TooltipProvider.lua
    Integrates raid skip summary rendering into the minimap tooltip.
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

local RaidProgressScraper = KRaidSkipTracker.Modules.RaidProgressScraper
local RaidSummaryBuilder = KRaidSkipTracker.Modules.RaidSummaryBuilder
local TooltipRowBuilder = KRaidSkipTracker.UI.TooltipRowBuilder

--[[-------------------------------------------------------------------------
    Minimap Tooltip Provider
---------------------------------------------------------------------------]]

local TooltipProvider = {}

MinimapIcon:SetClickCallback(function(...) TooltipProvider:OnIconClick(...) end)
MinimapTooltip:SetProvider(TooltipProvider)

--[[-------------------------------------------------------------------------
    Event Handlers
---------------------------------------------------------------------------]]

function TooltipProvider:OnIconClick(clickedFrame, button)
    if button == "RightButton" then
        Settings.OpenToCategory(addonName)
    end
end

--[[-------------------------------------------------------------------------
    PopulateTooltip
---------------------------------------------------------------------------]]

function TooltipProvider:PopulateTooltip(tooltip)
    tooltip:SetCellMarginH(16)
    tooltip:SetCellMarginV(6)

    local scrape = RaidProgressScraper.ScrapeProgress()
    local raidSummaries = RaidSummaryBuilder.BuildSummaries()
    local allExpansions = KRaidSkipTracker.questDataByExpansion

    local visiblePlayers = { scrape.warband, scrape.current }
    for _, saved in ipairs(scrape.saved) do
        table.insert(visiblePlayers, saved)
    end

    local totalColumns = 1 + #visiblePlayers

    for col = 1, totalColumns do
        tooltip:AddColumn()
    end

    tooltip:SetFont(KRaidSkipTracker.Fonts.MainHeader)
    local y = tooltip:AddLine()
    tooltip:SetCell(y, 1, colorize(addonNameWithIcon, Colors.Header))
    tooltip:SetCell(y, totalColumns-1, colorize(addonVersion, Colors.Grey), "RIGHT", 2)

    tooltip:AddSeparator(3, 0, 0, 0, 0)
    tooltip:AddSeparator()
    tooltip:AddSeparator(3, 0, 0, 0, 0)

    TooltipRowBuilder:AddHeaderRow(tooltip, visiblePlayers)

    for _, expansion in ipairs(allExpansions or {}) do
        TooltipRowBuilder:AddExpansionBreak(tooltip, expansion.expansionName)
        for _, raid in ipairs(expansion.raids or {}) do
            local summary = RaidSummaryBuilder.FindSummaryForRaid(raid.instanceId, raidSummaries)
            TooltipRowBuilder:AddRaidRow(tooltip, raid, summary, visiblePlayers)
        end
        tooltip:AddSeparator(2, 0, 0, 0, 0)
    end

    tooltip:AddSeparator(3, 0, 0, 0, 0)
    tooltip:AddSeparator()
    tooltip:AddSeparator(3, 0, 0, 0, 0)

    TooltipRowBuilder:AddFooter(tooltip)
end

KRaidSkipTracker.UI = KRaidSkipTracker.UI or {}
KRaidSkipTracker.UI.TooltipProvider = TooltipProvider