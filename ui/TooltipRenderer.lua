--[[-------------------------------------------------------------------------
    TooltipRenderer.lua
    Creates and populates GameTooltip with raid unlock summaries.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...

local kprint = KRaidSkipTracker.kprint
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

local RaidSummaryBuilder = KRaidSkipTracker.Modules.RaidSummaryBuilder
local TooltipRowRenderer = KRaidSkipTracker.UI.TooltipRowBuilder

--[[-------------------------------------------------------------------------
    TooltipRenderer
---------------------------------------------------------------------------]]

local TooltipRenderer = {}
KRaidSkipTracker.UI.TooltipRenderer = TooltipRenderer

--- Renders the tooltip at the given anchor.
--- @param anchorFrame table
function TooltipRenderer.Render(anchorFrame)
    GameTooltip:SetOwner(anchorFrame, "ANCHOR_RIGHT")
    GameTooltip:ClearLines()

    GameTooltip:AddLine(L["RAID_SKIP_SUMMARY"], 1, 1, 1, true)

    local summaries = RaidSummaryBuilder.BuildSummaries()
    for _, summary in ipairs(summaries) do
        TooltipRowRenderer.RenderRaidRow(summary)
    end

    GameTooltip:Show()
end

KRaidSkipTracker.UI = KRaidSkipTracker.UI or {}
KRaidSkipTracker.UI.TooltipRenderer = TooltipRenderer