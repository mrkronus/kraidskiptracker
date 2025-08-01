--[[-------------------------------------------------------------------------
    TooltipRowBuilder.lua
    Composes tooltip rows for raid skip summary using inline textures.
---------------------------------------------------------------------------]]

local addonName, KRaidSkipTracker = ...
local kprint = KRaidSkipTracker.kprint

local L = LibStub("AceLocale-3.0"):GetLocale(KRaidSkipTracker.Settings.AddonName)


local Colors = KRaidSkipTracker.Colors


--[[-------------------------------------------------------------------------
    Helpers
---------------------------------------------------------------------------]]

--- Attaches a hover tooltip with the given lines to the specified anchor cell.
--- @param parentTooltip table
--- @param anchorCell table
--- @param lines string[]
function AttachHoverTooltip(parentTooltip, anchorCell, lines)
    local hover = KRaidSkipTracker.LibQTip:Acquire("KRaidHoverTooltip", 1, "LEFT")
    parentTooltip.tooltip = hover

    hover:SetFont(KRaidSkipTracker.Fonts.MainText)
    for _, line in ipairs(lines) do
        local styled = colorize(line, KRaidSkipTracker.Colors.White)
        hover:AddLine(styled, "LEFT", KRaidSkipTracker.Colors.White)
    end

    hover:SmartAnchorTo(anchorCell)
    hover:SetAutoHideDelay(0.01, parentTooltip)
    hover:Show()
end

--- Returns texture string representing unlock status.
--- @param snapshot table
--- @param raidId number
--- @return string # Texture tag (|T...|t)
local function getUnlockTexture(snapshot, raidId)
    local id = tonumber(raidId)
    local progress = snapshot.progressByRaid and snapshot.progressByRaid[id]

    if not progress then
        return "|TInterface\\Common\\Indicator-Gray:16:16|t"  -- Unknown / no data
    end

    for _, entry in ipairs(progress) do
        if entry.isComplete then
            return "|TInterface\\RaidFrame\\ReadyCheck-Ready:16:16|t"  -- Completed
        end
        if entry.hasStarted then
            return "|TInterface\\RaidFrame\\ReadyCheck-Waiting:16:16|t" -- Started
        end
    end

    return "|TInterface\\RaidFrame\\ReadyCheck-NotReady:16:16|t" -- Not started
end


--[[-------------------------------------------------------------------------
    TooltipRowBuilder
---------------------------------------------------------------------------]]

local TooltipRowBuilder = {}

--- Adds a formatted header row to the tooltip based on the list of players.
-- Each cell displays the player's name and optionally their realm, with class-based coloring.
-- Warband entries are styled separately.
-- @param tooltip The tooltip object being populated
-- @param players A list of player data structs to render in header columns
function TooltipRowBuilder:AddHeaderRow(tooltip, players)
    tooltip:SetFont(KRaidSkipTracker.Fonts.Heading)
    local header = tooltip:AddLine()

    for col, player in ipairs(players) do
        local name = player.name or player.displayName or "?"
        local realm = player.realm or ""
        local display

        if player.isWarband then
            display = colorize("Warband", KRaidSkipTracker.Colors.Header)
        else
            local classKey = player.englishClass or player.class or "(none)"
            local color = classToColor(classKey)
            if realm ~= "" then
                name = name .. "\n" .. realm
            end
            display = colorize(name, color)
        end

        local columnIndex = 1 + col
        tooltip:SetCell(header, columnIndex, display, "CENTER")

        TooltipRowBuilder:AddPlayerInfoHover(tooltip, header, columnIndex, player)
    end
end

--- Adds a tooltip row for the given raid and its unlock summary.
--- @param tooltip table # LibQTip tooltip instance
--- @param raid table # Raid definition from RaidData
--- @param summary table # Unlock info from RaidSummaryBuilder
--- @param players table[] # List of snapshot structs (current, warband, alts)
function TooltipRowBuilder:AddRaidRow(tooltip, raid, summary, players)
    local y = tooltip:AddLine()
    -- Column 1: Raid name
    tooltip:SetCell(y, 1, raid.instanceShortName, "LEFT", 1)

    -- Columns 2+: Unlock status icon per player
    for colIndex, snapshot in ipairs(players) do
        local icon = getUnlockTexture(snapshot, raid.instanceId)
        tooltip:SetCell(y, colIndex + 1, icon, "CENTER", 1)
    end
end

--- Attaches player info as a hover tooltip for the given cell.
--- @param tooltip table
--- @param row number
--- @param column number
--- @param player table
function TooltipRowBuilder:AddPlayerInfoHover(tooltip, row, column, player)
    tooltip:SetCellScript(row, column, "OnEnter", function()
        local lines = {
            L["Player:"]       .. " " .. (player.playerName   or L["Unknown"]),
            L["Realm:"]        .. " " .. (player.playerRealm  or L["Unknown"]),
            L["Class:"]        .. " " .. (player.playerClass  or L["Unknown"]),
            L["Level:"]        .. " " .. (player.playerLevel  or "--"),
            L["iLevel:"]       .. " " .. (player.playerILevel and math.floor(player.playerILevel + 0.5) or "--"),
            L["Last Synced:"]  .. " " .. (
                player.lastUpdateServerTime
                and date(L["%m/%d/%y %H:%M:%S"], player.lastUpdateServerTime)
                or L["Unknown"]
            ),
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


--- Inserts a visual expansion header row into the tooltip.
--- @param tooltip table
--- @param expansionName string
function TooltipRowBuilder:AddExpansionBreak(tooltip, expansionName)
    local y = tooltip:AddLine()
    tooltip:SetCell(y, 1, colorize(expansionName, Colors.Header), "LEFT", tooltip:GetColumnCount())
end

--- Adds a footer line to the tooltip with instructions or extra info.
--- @param tooltip table
function TooltipRowBuilder:AddFooter(tooltip)
    tooltip:SetFont(KRaidSkipTracker.Fonts.FooterText)

    local msg = "Right-click icon for options"
    local styledMsg = colorize(msg, KRaidSkipTracker.Colors.FooterDark)

    tooltip:AddLine(styledMsg)
end


KRaidSkipTracker.UI = KRaidSkipTracker.UI or {}
KRaidSkipTracker.UI.TooltipRowBuilder = TooltipRowBuilder