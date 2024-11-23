local addonName, KRaidSkipTracker = ...

--[[-------------------------------------------------------------------------
	Variables
---------------------------------------------------------------------------]]

-- [[ Localization ]]
local L = LibStub("AceLocale-3.0"):GetLocale(addonName)

--[[ Player info ]]
local CurrentPlayerIdString = UnitName("player") .. " - " .. GetRealmName()
local WarbandIdString = "Warband"

--[[ Fonts ]]
local HeaderFont = CreateFont("HeaderFont")
local FooterTextFont = CreateFont("FooterTextFont")
local InstanceNameTextFont = CreateFont("InstanceNameTextFont")
local MainTextFont = CreateFont("MainTextFont")

--[[
    PlayersData
    - [1] -- Players
        - shouldShow
        - playerName
        - playerRealm
        - data
            - [1] -- expansions
            - [1] -- raids
                - isStatistic
                - instanceId
                - quests
                - [1] -- quests
                    - isCompleted
                    - isStarted
                    - questId
                    - objectives
                    - [1] -- objectives
                        - numFulFilled
                        - numRequired
--]]
PlayersDataToShow = {}
AllPlayersData = {}

--[[-------------------------------------------------------------------------
	Copy Text Popup
---------------------------------------------------------------------------]]

local function ShowKRaidSkipTrackerCopyTextPopup(message, text)
    local popup = StaticPopupDialogs.KRaidSkipTracker_CopyTextPopup;
    if not popup then
        popup = {
            button1 = L["Close"],
            hasEditBox = true,
            editBoxWidth = 300,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3, -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
        };
        StaticPopupDialogs.KRaidSkipTracker_CopyTextPopup = popup;
    end
    popup.OnShow = function(self, data)
        local function HidePopup(self) self:GetParent():Hide() end
        local function HotkeyHandler(self, key) if IsControlKeyDown() and key == "C" then HidePopup(self) end end
        self.editBox:SetScript("OnEscapePressed", HidePopup)
        self.editBox:SetScript("OnEnterPressed", HidePopup)
        self.editBox:SetScript("OnKeyUp", HotkeyHandler)
        self.editBox:SetMaxLetters(0)
        self.editBox:SetText(text)
        self.editBox:HighlightText()
    end

    popup.text = message .. "\n\n" .. L["Use ctrl-c to copy"]
    StaticPopup_Hide("KRaidSkipTracker_CopyTextPopup");
    StaticPopup_Show("KRaidSkipTracker_CopyTextPopup");
end

--[[-------------------------------------------------------------------------
	Methods
---------------------------------------------------------------------------]]

local function MouseHandler(event, func, button, ...)
    if _G.type(func) == "function" then
        func(event, func, button, ...)
    else
        func:GetScript("OnClick")(func, button, ...)
    end

    KRaidSkipTracker.LibQTip:Release(tooltip)
    tooltip = nil
end

local function InitializeFonts()
    HeaderFont:SetFont("Fonts\\FRIZQT__.TTF", 16, "")
    FooterTextFont:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    InstanceNameTextFont:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
    MainTextFont:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
end

local function LoadData()
    AllPlayersData = KRaidSkipTracker.LibAceAddon:GetDBAllPlayersData()
end

local function GetWarbandTable()
    local allxpacsTable = {}

    -- For each xpac
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        local xpacTable = {}

        -- For each raid in xpac
        for _, raid in ipairs(xpac.raids) do
            local raidsTable = {}

            -- For each quest in raid
            for _, quest in ipairs(raid.quests) do
                local isStarted, isCompleted = false, false

                if raid.isStatistic then
                    -- If it's a statistic
                    isCompleted = IsStatisticComplete(quest.questId)
                    isStarted = isCompleted
                else
                    -- Otherwise it's a quest
                    isCompleted = IsQuestWarbandComplete(quest.questId)
                end

                -- insert the quest data into the raids table
                table.insert(raidsTable, { isStarted = isStarted, isCompleted = isCompleted, questId = quest.questId, objectives = questObjectives })
            end

            -- insert the raid data into the xpacs table
            table.insert(xpacTable, { isStatistic = raid.isStatistic, instanceId = raid.instanceId, quests = raidsTable })
        end

        -- insert the xpac table into the all xpacs table
        table.insert(allxpacsTable, xpacTable)
    end

    local lastUpdateTime = GetServerTime()

    local warbandData = { playerName = "Warband", playerRealm = "", playerClass = "(none)",
        englishClass = "(none)", playerLevel = nil, playerILevel = nil, shouldShow = true,
        lastUpdateServerTime = lastUpdateTime, data = allxpacsTable }

    return warbandData
end

local function UpdateSortedPlayersData()
    PlayersDataToShow = {}
    local insertLocation = 1
    local playerData = nil
    for _, player in pairs(AllPlayersData) do
        if (player.playerName == UnitName("player")) and (player.playerRealm == GetRealmName()) then
            playerData = player
        else
            if KRaidSkipTracker.LibAceAddon:ShouldShowOnlyCurrentRealm() and (player.playerRealm ~= GetRealmName() )then
                -- continue
            else
                table.insert(PlayersDataToShow, insertLocation, player)
                insertLocation = insertLocation + 1
            end
        end
    end

    table.sort(PlayersDataToShow, function(a, b)
        if a.playerRealm ~= b.playerRealm then
            return a.playerRealm < b.playerRealm
        end
        return a.playerName < b.playerName
    end)

    if playerData ~= nil then
        table.insert(PlayersDataToShow, 1, playerData)
    end

    local warbandData = GetWarbandTable()
    table.insert(PlayersDataToShow, 1, warbandData)
end

local function PreQueryAllQuestData()
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        for _, raid in ipairs(xpac.raids) do
            for _, quest in ipairs(raid.quests) do
                if raid.isStatistic then
                    _ = IsStatisticComplete(quest.questId) and true or false
                else
                    _ = IsQuestComplete(quest.questId) and true or false
                    _ = C_QuestLog.GetQuestObjectives(quest.questId)
                end
            end
        end
    end
end

local function AddAllPlayersProgressToTooltip(tooltip, questId, cellRow)
    tooltip:SetFont(InstanceNameTextFont)
    local cellColumn = 2 -- first column is for the instance name
    for _, player in ipairs(PlayersDataToShow) do
        if player.shouldShow then
            for _, xpac in ipairs(player.data) do
                for _, raid in ipairs(xpac) do
                    for _, quest in ipairs(raid.quests) do
                        if quest.questId == questId then
                            if raid.isStatistic then
                                if quest.isCompleted then
                                    tooltip:SetCell(cellRow, cellColumn, KRaidSkipTracker.TextIcons.GreenCheck)
                                elseif DoesQuestDataHaveAnyProgressOnAnyCharacter(questId) or not KRaidSkipTracker.LibAceAddon:ShouldHideNoProgressRaids() then
                                    -- tooltip:SetCell(cellRow, cellColumn, colorize("Incomplete", KRaidSkipTracker.Colors.Incomplete))
                                end
                            else
                                if quest.isCompleted then
                                    tooltip:SetCell(cellRow, cellColumn, KRaidSkipTracker.TextIcons.GreenCheck)
                                elseif quest.isStarted then
                                    local questObjectives = quest.objectives
                                    tooltip:SetCell(cellRow, cellColumn,
                                        GetCombinedObjectivesStringFromData(questId, questObjectives))
                                elseif DoesQuestDataHaveAnyProgressOnAnyCharacter(questId) or not KRaidSkipTracker.LibAceAddon:ShouldHideNoProgressRaids() then
                                    -- tooltip:SetCell(cellRow, cellColumn, colorize("Not Started", KRaidSkipTracker.Colors.Incomplete))
                                end
                            end
                            tooltip:SetCellScript(cellRow, cellColumn, "OnMouseUp", MouseHandler, function() end)
                            cellColumn = cellColumn + 1
                        end
                    end
                end
            end
        end
    end
end

local function AddQuestLineToTooltip(tooltip, raid, quest, shouldHighlight)
    local questId = quest.questId
    if (KRaidSkipTracker.LibAceAddon:ShouldHideNoProgressRaids() == false) or DoesQuestDataHaveAnyProgressOnAnyCharacter(questId) then
        local questName = GetQuestDisplayNameFromIdInData(questId) .. ": "
        local y, x = tooltip:AddLine()
        if shouldHighlight then
            tooltip:SetLineColor(y, 1, 1, 1, 0.1)
        end
        tooltip:SetCell(y, 1, questName)
        tooltip:SetCellScript(y, 1, "OnMouseUp", MouseHandler, function() ShowKRaidSkipTrackerCopyTextPopup(C_QuestLog.GetTitleForQuestID(questId), "https://www.wowhead.com/quest=" .. questId) end)
        tooltip:SetCellScript(y, 1, "OnEnter", MouseHandler, function()
            local hoverTooltip = KRaidSkipTracker.LibQTip:Acquire("KKeyedHoverTooltip", 1, "LEFT")
            tooltip.tooltip = hoverTooltip
            hoverTooltip:SetFont(InstanceNameTextFont)

            if not raid.isStatistic then
                hoverTooltip:AddLine(colorize(C_QuestLog.GetTitleForQuestID(questId), KRaidSkipTracker.Colors.Header))
                hoverTooltip:AddLine(colorize(L["Click for Wowhead link"], KRaidSkipTracker.Colors.FooterDark))
            else
                hoverTooltip:AddLine(colorize(L["This raid skip does not have a quest associated with it."], KRaidSkipTracker.Colors.White))
            end

            hoverTooltip:SetAutoHideDelay(0.01, tooltip)
            hoverTooltip:SmartAnchorTo(tooltip)
            hoverTooltip:Show()
        end)
        tooltip:SetCellScript(y, 1, "OnLeave", MouseHandler, function()
            if tooltip.tooltip ~= nil then
                tooltip.tooltip:Release()
                tooltip.tooltip = nil
            end
        end)

        AddAllPlayersProgressToTooltip(tooltip, questId, y)
        return true
    end
    return false
end

local function AddRaidToTooltip(tooltip, raid)
    local shouldHighlight = true
    for _, quest in ipairs(raid.quests) do
        tooltip:SetFont(MainTextFont)
        local wasAdded = AddQuestLineToTooltip(tooltip, raid, quest, shouldHighlight)
        if wasAdded then
            shouldHighlight = not shouldHighlight
        end
    end
end

local function AddExpansionToTooltip(tooltip, xpac, cellRow)
    for _, raid in ipairs(xpac) do
        if (KRaidSkipTracker.LibAceAddon:ShouldAlwaysShowAllRaidHeadings() == false) and KRaidSkipTracker.LibAceAddon:ShouldHideNoProgressRaids() and (not DoesRaidDataHaveAnyProgressOnAnyCharacter(raid.instanceId)) then
            if KRaidSkipTracker.LibAceAddon:ToggleShowDebugOutput() then
                print("Skipping raid: " .. GetRaidInstanceNameFromIdInData(raid.instanceId))
            end
        else
            tooltip:SetFont(InstanceNameTextFont)
            local y, _ = tooltip:AddLine()
            local internalRaidData = GetRaidInstanceDataFromId(raid.instanceId)
            tooltip:SetCell(y, 1, colorize(internalRaidData.instanceName, KRaidSkipTracker.Colors.SubHeader))

            tooltip:SetCellScript(y, 1, "OnMouseUp", MouseHandler, function()
                if (not EncounterJournal_OpenJournal) then
                    UIParentLoadAddOn('Blizzard_EncounterJournal')
                end
                EncounterJournal_OpenJournal(16, internalRaidData.journalInstanceId) -- 16 is mythic raid
            end)
            tooltip:SetCellScript(y, 1, "OnEnter", MouseHandler, function()
                local hoverTooltip = KRaidSkipTracker.LibQTip:Acquire("KKeyedHoverTooltip", 2, "LEFT", "RIGHT")
                tooltip.tooltip = hoverTooltip

                hoverTooltip:SetFont(HeaderFont)
                hoverTooltip:AddHeader(colorize(internalRaidData.instanceShortName, KRaidSkipTracker.Colors.Header))
                hoverTooltip:AddSeparator()

                hoverTooltip:SetFont(InstanceNameTextFont)
                local hoverY, hoverX = hoverTooltip:AddLine()
                hoverTooltip:SetCell(hoverY, hoverX, colorize(internalRaidData.instanceDescriptionText, KRaidSkipTracker.Colors.White), nil, "LEFT", 2, nil, nil, nil, 250, nil)
                hoverTooltip:AddSeparator(6, 0, 0, 0, 0)

                hoverTooltip:AddLine(colorize(L["Expansion: "], KRaidSkipTracker.Colors.White), colorize(GetExpansionFromFromRaidInstanceId(raid.instanceId), KRaidSkipTracker.Colors.White))
                hoverTooltip:AddLine(colorize(L["Containing zone: "], KRaidSkipTracker.Colors.White), colorize(C_Map.GetMapInfo(internalRaidData.locatedInZoneId).name, KRaidSkipTracker.Colors.White))
                hoverTooltip:AddLine(colorize(L["Required level to enter: "], KRaidSkipTracker.Colors.White), colorize(internalRaidData.requiredLevel, KRaidSkipTracker.Colors.White))
                hoverTooltip:AddLine(colorize(L["Number of players: "], KRaidSkipTracker.Colors.White), colorize(internalRaidData.numberOfPlayers, KRaidSkipTracker.Colors.White))
                hoverTooltip:AddSeparator(6, 0, 0, 0, 0)

                hoverTooltip:SetFont(FooterTextFont)
                hoverTooltip:AddLine(colorize(L["Click to open Adventure Journal"], KRaidSkipTracker.Colors.FooterDark))

                hoverTooltip:SetAutoHideDelay(0.01, tooltip)
                hoverTooltip:SmartAnchorTo(tooltip)
                hoverTooltip:Show()
            end)
            tooltip:SetCellScript(y, 1, "OnLeave", MouseHandler, function()
                if tooltip.tooltip ~= nil then
                    tooltip.tooltip:Release()
                    tooltip.tooltip = nil
                end
            end)

            AddRaidToTooltip(tooltip, raid)
            tooltip:AddSeparator(6, 0, 0, 0, 0)
        end
    end
end

local function GetTotalPlayersCountInData()
    local entriesInDataTable = 0
    for _ in pairs(PlayersDataToShow) do entriesInDataTable = entriesInDataTable + 1 end
    return entriesInDataTable
end

local function GetTotalPlayersCountInAllPlayersData()
    local entriesInDataTable = 0
    for _ in pairs(AllPlayersData) do entriesInDataTable = entriesInDataTable + 1 end
    return entriesInDataTable
end

local function AddPlayersToTooltip(tooltip, cellRow)
    tooltip:SetFont(InstanceNameTextFont)
    local cellColumn = 2 -- first column is for the instance name
    for _, player in pairs(PlayersDataToShow) do
        if player.shouldShow then
            tooltip:SetCell(cellRow, cellColumn, colorize(player.playerName .. "\n" .. player.playerRealm, classToColor(player.englishClass)))
            tooltip:SetCellScript(cellRow, cellColumn, "OnEnter", MouseHandler, function()
                local hoverTooltip = KRaidSkipTracker.LibQTip:Acquire("KKeyedHoverTooltip", 2, "LEFT", "RIGHT")
                tooltip.tooltip = hoverTooltip

                hoverTooltip:SetFont(InstanceNameTextFont)

                hoverTooltip:AddLine(colorize(L["Player:"], KRaidSkipTracker.Colors.White), colorize(player.playerName, KRaidSkipTracker.Colors.White))
                hoverTooltip:AddLine(colorize(L["Realm:"], KRaidSkipTracker.Colors.White), colorize(player.playerRealm, KRaidSkipTracker.Colors.White))
                if player.englishClass ~= nil then
                    hoverTooltip:AddLine(colorize(L["Class:"], KRaidSkipTracker.Colors.White), colorize(player.playerClass, classToColor(player.englishClass)))
                else
                    hoverTooltip:AddLine(colorize(L["Class:"], KRaidSkipTracker.Colors.White), colorize(L["Unknown"], KRaidSkipTracker.Colors.Grey))
                end
                if player.playerLevel ~= nil then
                    hoverTooltip:AddLine(colorize(L["Level:"], KRaidSkipTracker.Colors.White), colorize(tostring(player.playerLevel), KRaidSkipTracker.Colors.White))
                else
                    hoverTooltip:AddLine(colorize(L["Level:"], KRaidSkipTracker.Colors.White), colorize("--", KRaidSkipTracker.Colors.Grey))
                end
                if player.playerILevel ~= nil then
                    hoverTooltip:AddLine(colorize(L["iLevel:"], KRaidSkipTracker.Colors.White), colorize(tostring(math.floor(player.playerILevel + 0.5)), KRaidSkipTracker.Colors.White))
                else
                    hoverTooltip:AddLine(colorize(L["iLevel:"], KRaidSkipTracker.Colors.White), colorize("--", KRaidSkipTracker.Colors.Grey))
                end
                if player.lastUpdateServerTime ~= nil then
                    hoverTooltip:AddLine(colorize(L["Last Synced:"], KRaidSkipTracker.Colors.White), colorize(date(L["%m/%d/%y %H:%M:%S"], player.lastUpdateServerTime), KRaidSkipTracker.Colors.White))
                else
                    hoverTooltip:AddLine(colorize(L["Last Synced:"], KRaidSkipTracker.Colors.White), colorize(L["Unknown"], KRaidSkipTracker.Colors.Grey))
                end

                hoverTooltip:SetAutoHideDelay(0.01, tooltip)
                hoverTooltip:SmartAnchorTo(tooltip)
                hoverTooltip:Show()
            end)
            tooltip:SetCellScript(cellRow, cellColumn, "OnLeave", MouseHandler, function()
                if tooltip.tooltip ~= nil then
                    tooltip.tooltip:Release()
                    tooltip.tooltip = nil
                end
            end)
            cellColumn = cellColumn + 1
        end
    end
end

--[[-------------------------------------------------------------------------
	KAutoMark public methods
---------------------------------------------------------------------------]]

local function PopulateTooltip(tooltip)
    UpdateSortedPlayersData()
    tooltip:SetCellMarginH(10) -- must be done before any data is added
    local playersCount = GetTotalPlayersCountInData()
    for i = 1, playersCount do tooltip:AddColumn("CENTER") end

    tooltip:SetFont(HeaderFont)
    local y, x = tooltip:AddLine()
    tooltip:SetCell(y, 1, colorize("K Raid Skip Tracker", KRaidSkipTracker.Colors.Header))

    tooltip:SetCellScript(y, 1, "OnEnter", MouseHandler, function()
        local hoverTooltip = KRaidSkipTracker.LibQTip:Acquire("KKeyedHoverTooltip", 2, "LEFT", "RIGHT")
        tooltip.tooltip = hoverTooltip
        local totalToons = GetTotalPlayersCountInAllPlayersData();

        hoverTooltip:SetFont(InstanceNameTextFont)
        hoverTooltip:AddLine(colorize(L["Total Shown Characters: "], KRaidSkipTracker.Colors.White), colorize(tostring(playersCount), KRaidSkipTracker.Colors.White))
        hoverTooltip:AddLine(colorize(L["Total Tracked Characters: "], KRaidSkipTracker.Colors.White), colorize(tostring(totalToons), KRaidSkipTracker.Colors.White))
        hoverTooltip:AddSeparator()
        hoverTooltip:AddLine(colorize(" ", nil), colorize(C_AddOns.GetAddOnMetadata("KRaidSkipTracker", "Version"), KRaidSkipTracker.Colors.Grey))

        hoverTooltip:SetAutoHideDelay(0.01, tooltip)
        hoverTooltip:SmartAnchorTo(tooltip)
        hoverTooltip:Show()
    end)
    tooltip:SetCellScript(y, 1, "OnLeave", MouseHandler, function()
        if tooltip.tooltip ~= nil then
            tooltip.tooltip:Release()
            tooltip.tooltip = nil
        end
    end)

    AddPlayersToTooltip(tooltip, y)
    tooltip:AddSeparator()

    PlayerData = PlayersDataToShow[1]
    for _, xpac in ipairs(PlayerData.data) do
        AddExpansionToTooltip(tooltip, xpac)
    end

    tooltip:SetFont(FooterTextFont)
    tooltip:AddLine(colorize(L["Right click icon for options"], KRaidSkipTracker.Colors.FooterDark))
end
KRaidSkipTracker.PopulateTooltip = PopulateTooltip

local function UpdateCurrentPlayerData()
    local allxpacsTable = {}

    -- For each xpac
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        local xpacTable = {}

        -- For each raid in xpac
        for _, raid in ipairs(xpac.raids) do
            local raidsTable = {}

            -- For each quest in raid
            for _, quest in ipairs(raid.quests) do
                local isStarted, isCompleted = false, false

                if raid.isStatistic then
                    -- If it's a statistic
                    isCompleted = IsStatisticComplete(quest.questId)
                    isStarted = isCompleted
                else
                    -- Otherwise it's a quest
                    isCompleted = IsQuestComplete(quest.questId)
                    isStarted = isCompleted or IsQuestInLog(quest.questId)
                end

                local questObjectives = C_QuestLog.GetQuestObjectives(quest.questId)

                -- insert the quest data into the raids table
                table.insert(raidsTable, { isStarted = isStarted, isCompleted = isCompleted, questId = quest.questId, objectives = questObjectives })

                if KRaidSkipTracker.LibAceAddon:ShouldShowDebugOutput() then
                    local questObjectives = C_QuestLog.GetQuestObjectives(quest.questId)
                    local objectivesString = GetCombinedObjectivesString(quest.questId, questObjectives)
                    print(quest.questId .. " | " .. tostring(isStarted) .. " | " .. tostring(isCompleted) .. " | " .. objectivesString)
                end
            end

            -- insert the raid data into the xpacs table
            table.insert(xpacTable, { isStatistic = raid.isStatistic, instanceId = raid.instanceId, quests = raidsTable })
        end

        -- insert the xpac table into the all xpacs table
        table.insert(allxpacsTable, xpacTable)
    end

    local playerClass, englishClass = UnitClass("player")
    local playerLevel = UnitLevel("player")
    local overallILevel, _ = GetAverageItemLevel();
    local lastUpdateTime = GetServerTime()

    -- assign the all xpacs table to the player data
    local previousShouldShow = true
    if AllPlayersData[CurrentPlayerIdString] ~= nil then
        previousShouldShow = AllPlayersData[CurrentPlayerIdString].shouldShow
    end

    AllPlayersData[CurrentPlayerIdString] = nil
    AllPlayersData[CurrentPlayerIdString] = { playerName = UnitName("player"), playerRealm = GetRealmName(), playerClass =
        playerClass, englishClass = englishClass, playerLevel = playerLevel, playerILevel = overallILevel, shouldShow =
        previousShouldShow, lastUpdateServerTime = lastUpdateTime, data = allxpacsTable }
end
KRaidSkipTracker.UpdateCurrentPlayerData = UpdateCurrentPlayerData

local function GetAllPlayersData()
    return AllPlayersData
end
KRaidSkipTracker.GetAllPlayersData = GetAllPlayersData

local function DeleteAllPlayersData()
    AllPlayersData = nil
end
KRaidSkipTracker.DeleteAllPlayersData = DeleteAllPlayersData

local function DeletePlayerData(playerName, playerRealm)
    local CurrentPlayerIdString = playerName .. " - " .. playerRealm
    if AllPlayersData[CurrentPlayerIdString] ~= nil then
        AllPlayersData[CurrentPlayerIdString] = nil
    end
end
KRaidSkipTracker.DeletePlayerData = DeletePlayerData

local function TogglePlayerVisibility(playerName, playerRealm)
    local CurrentPlayerIdString = playerName .. " - " .. playerRealm
    if AllPlayersData[CurrentPlayerIdString] ~= nil then
        AllPlayersData[CurrentPlayerIdString].shouldShow = not AllPlayersData[CurrentPlayerIdString].shouldShow
    end
end
KRaidSkipTracker.TogglePlayerVisibility = TogglePlayerVisibility

local function Initialize()
    InitializeFonts()
    LoadData()
    PreQueryAllQuestData()
end
KRaidSkipTracker.Initialize = Initialize
