--[[-------------------------------------------------------------------------
	Data Initialization
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local kprint = KRaidSkipTracker.kprint

local KRaidSkipTracker = KRaidSkipTracker
local L = LibStub("AceLocale-3.0"):GetLocale(KRaidSkipTracker.Settings.AddonName)

local HeaderFont = CreateFont("KRaidSkip_HeaderFont")
HeaderFont:SetFont("Fonts\\FRIZQT__.TTF", 16, "")
local MainTextFont = CreateFont("KRaidSkip_MainTextFont")
MainTextFont:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
local InstanceNameFont = CreateFont("KRaidSkip_InstanceFont")
InstanceNameFont:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
local FooterFont = CreateFont("KRaidSkip_FooterFont")
FooterFont:SetFont("Fonts\\FRIZQT__.TTF", 10, "")


--[[-------------------------------------------------------------------------
	TooltipRowBuilder
---------------------------------------------------------------------------]]

local function AttachHoverTooltip(parentTooltip, anchorCell, lines)
    local hover = KRaidSkipTracker.LibQTip:Acquire("KRaidHoverTooltip", 1, "LEFT")
    parentTooltip.tooltip = hover
    hover:SetFont(MainTextFont)

    for _, line in ipairs(lines) do
        hover:AddLine(colorize(line, KRaidSkipTracker.Colors.White))
    end

    hover:SetAutoHideDelay(0.01, parentTooltip)
    hover:SmartAnchorTo(anchorCell)
    hover:Show()
end


--[[-------------------------------------------------------------------------
	TooltipRowBuilder
---------------------------------------------------------------------------]]

local TooltipRowBuilder = {}

function TooltipRowBuilder:AddHeaderRow(tooltip, players)
    tooltip:SetFont(HeaderFont)

    local header = tooltip:AddLine()
    tooltip:SetCell(header, 1, colorize("Raid", KRaidSkipTracker.Colors.Header))
    tooltip:SetCell(header, 2, colorize("Warband", KRaidSkipTracker.Colors.Header))

    for i, player in ipairs(players) do
        if player.guid ~= "Warband" then
            local display = player.displayName
            local color   = classToColor(player.englishClass or player.class or "(none)")
            print("setting header cell:", display, color, player.displayName, player.englishClass, player.class)
            tooltip:SetCell(header, 2 + i, colorize(display, color))
        end
    end
end

function TooltipRowBuilder:AddExpansionBreak(tooltip, expansionName)
    tooltip:AddSeparator()
    tooltip:SetFont(HeaderFont)
    tooltip:AddLine(colorize(expansionName, KRaidSkipTracker.Colors.Header))
end

function TooltipRowBuilder:AddRaidRow(tooltip, raid, warbandPlayer, players)
    tooltip:SetFont(MainTextFont)

    local row = tooltip:AddLine()
    tooltip:SetCell(row, 1, colorize(raid.name, KRaidSkipTracker.Colors.SubHeader))

    tooltip:SetCell(row, 2, raid:GetSkipSummary(warbandPlayer))

    for i, player in ipairs(players) do
        if player.guid ~= "Warband" then
            local colNum = 2 + i
            local summary = player and raid:GetSkipSummary(player) or KRaidSkipTracker.TextIcons.RedX
            tooltip:SetCell(row, colNum, summary)
            if not player then
                kprint("AddRaidRow: Found nil player at column " .. colNum .. " for raid " .. raid.name)
            end
        end
    end
end

function TooltipRowBuilder:AddPlayerInfoHover(tooltip, row, column, player)
    tooltip:SetCellScript(row, column, "OnEnter", function()
        local lines = {
            L["Player:"] .. " " .. player.playerName,
            L["Realm:"] .. " " .. player.playerRealm,
            L["Class:"] .. " " .. (player.playerClass or L["Unknown"]),
            L["Level:"] .. " " .. (player.playerLevel or "--"),
            L["iLevel:"] .. " " .. (player.playerILevel and math.floor(player.playerILevel + 0.5) or "--"),
            L["Last Synced:"] .. " " .. (player.lastUpdateServerTime and date(L["%m/%d/%y %H:%M:%S"], player.lastUpdateServerTime) or L["Unknown"]),
        }
        AttachHoverTooltip(tooltip, tooltip, lines)
    end)

    tooltip:SetCellScript(row, column, "OnLeave", function()
        if tooltip.tooltip then
            tooltip.tooltip:Release()
            tooltip.tooltip = nil
        end
    end)
end

function TooltipRowBuilder:AddFooter(tooltip)
    tooltip:AddSeparator()
    tooltip:SetFont(FooterFont)
    tooltip:AddLine(colorize("Right click icon for options", KRaidSkipTracker.Colors.FooterDark))
end

KRaidSkipTracker.TooltipRowBuilder = TooltipRowBuilder
