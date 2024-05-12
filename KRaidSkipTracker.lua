local addonName, KRaidSkipTracker = ...

--[[-------------------------------------------------------------------------
	Variables
---------------------------------------------------------------------------]]

--[[ Player info]]
local CurrentPlayerIdString = UnitName("player") .. " - " .. GetRealmName()

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
	Methods
---------------------------------------------------------------------------]]

local function MouseHandler(event, func, button, ...)
	local name = func

	if _G.type(func) == "function" then
		func(event, func,button, ...)
	else
		func:GetScript("OnClick")(func,button, ...)
	end

	LibQTip:Release(tooltip)
	tooltip = nil
end

function KRaidSkipTracker.GetAllPlayersData()
    return AllPlayersData
end

function KRaidSkipTracker.GetCurrentDataVersion()
    return C_AddOns.GetAddOnMetadata("KRaidSkipTracker", "Version")
end

function KRaidSkipTracker.InitializeFonts()
    HeaderFont:SetFont("Fonts\\FRIZQT__.TTF", 16, "")
    FooterTextFont:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    InstanceNameTextFont:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
    MainTextFont:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
end

function KRaidSkipTracker.LoadData()
    AllPlayersData = LibAceAddon:GetDBAllPlayersData()
end

function UpdateSortedPlayersData()
    PlayersDataToShow = {}
    local insertLocation = 1
    local playerData = nil
    for _, player in pairs(AllPlayersData) do
        if(player.playerName == UnitName("player") and player.playerRealm == GetRealmName()) then
            playerData = player
        else
            if(LibAceAddon:ShouldShowOnlyCurrentRealm() and player.playerRealm ~= GetRealmName()) then
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

    if(playerData ~= nil) then
       table.insert(PlayersDataToShow, 1, playerData)
    end
end

function KRaidSkipTracker.PreQueryAllQuestData()
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

function KRaidSkipTracker.Initialize()
    KRaidSkipTracker.InitializeFonts()
    KRaidSkipTracker.LoadData()
    KRaidSkipTracker.PreQueryAllQuestData()
end

local function AddQuestLineToTooltip(tooltip, raid, quest)
    local questId = quest.questId
    local questName = GetQuestDisplayNameFromIdInData(questId) .. ": "

    if raid.isStatistic then
        if quest.isCompleted then
            tooltip:AddLine(questName, "\124cff00ff00Acquired\124r")
        elseif DoesQuestDataHaveAnyProgressOnAnyCharacter(questId) or not LibAceAddon:ShouldHideNotStarted() then
            tooltip:AddLine(questName, "\124cFFA9A9A9Incomplete\124r")
        end
    else
        if quest.isCompleted then
            tooltip:AddLine(questName, format("\124cff00ff00Acquired\124r"))
        elseif quest.isStarted then
            local questObjectives = C_QuestLog.GetQuestObjectives(questId)
            tooltip:AddLine(questName, GetCombinedObjectivesString(questId, questObjectives))
        elseif DoesQuestDataHaveAnyProgressOnAnyCharacter(questId) or not LibAceAddon:ShouldHideNotStarted() then
            tooltip:AddLine(questName, format("\124cFFA9A9A9Not Started\124r"))
        end
    end
end

local function AddRaidToTooltip(tooltip, raid)
    tooltip:SetFont(MainTextFont)
    for _, quest in ipairs(raid.quests) do
        AddQuestLineToTooltip(tooltip, raid, quest)
    end
end

local function AddExpansionToTooltip(tooltip, xpac)
    for _, raid in ipairs(xpac) do
        if LibAceAddon:ShouldHideNotStarted() and (not DoesRaidDataHaveAnyProgressOnAnyCharacter(raid.instanceId)) then
            if LibAceAddon:ToggleShowDebugOutput() then
                print("Skipping raid: " .. GetRaidInstanceNameFromIdInData(raid.instanceId))
            end
        else
            tooltip:SetFont(InstanceNameTextFont)
            tooltip:AddLine(format("|cffffff00%s|r", GetRaidInstanceNameFromIdInData(raid.instanceId)))
            AddRaidToTooltip(tooltip, raid)
            tooltip:AddSeparator(6,0,0,0,0)
        end
    end
end

function KRaidSkipTracker.PopulateTooltip(tooltip)
    UpdateSortedPlayersData()
    local playersCount = KRaidSkipTracker.GetTotalPlayersCountInData()
    for i=1,playersCount do tooltip:AddColumn("RIGHT") end

    tooltip:SetFont(HeaderFont)
    local y, x = tooltip:AddLine()
    tooltip:SetCell(y, 1, "|cFFFFD700K Raid Skip Tracker|r")

    KRaidSkipTracker.AddPlayersToTooltip(tooltip, y)
    tooltip:AddSeparator()

    PlayerData = PlayersDataToShow[1]
    for _, xpac in ipairs(PlayerData.data) do
       AddExpansionToTooltip(tooltip, xpac)
    end

    tooltip:SetFont(FooterTextFont)
    tooltip:AddLine("|cFFF5F5F5Right click icon for options|r")
end

function KRaidSkipTracker.GetTotalPlayersCountInData()
    local entriesInDataTable = 0
    for _ in pairs(PlayersDataToShow) do entriesInDataTable = entriesInDataTable + 1 end
    return entriesInDataTable
end

function KRaidSkipTracker.AddPlayersToTooltip(tooltip, cellRow)
    tooltip:SetFont(InstanceNameTextFont)
    local cellColumn = 2 -- first column is for the instance name
    for _, players in pairs(PlayersDataToShow) do
        tooltip:SetCell(cellRow, cellColumn, format("|cffffff00%s|r", players.playerName .. "\n" .. players.playerRealm))
        tooltip:SetCellScript(cellRow, cellColumn, "OnMouseUp", MouseHandler, function() print("click") end)
        cellColumn = cellColumn + 1
    end
end

function KRaidSkipTracker.UpdateCurrentPlayerData()
    local allxpacsTable = {}

    -- For each xpac
    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        local xpacTable = {}

        -- For each raid in xpac
        for _, raid in ipairs(xpac.raids) do
            local raidsTable = {}

            -- For each quest in raid
            for _, quest in ipairs(raid.quests) do
                local objectives = {}
                local isStarted, isCompleted = false, false

                if raid.isStatistic then
                    -- If it's a statistic
                    isCompleted = IsStatisticComplete(quest.questId)
                    isStarted = isCompleted
                else
                    -- Otherwise it's a quest
                    isCompleted = IsQuestComplete(quest.questId)
                    isStarted = isCompleted
                    local questObjectives = C_QuestLog.GetQuestObjectives(quest.questId)

                    -- For each objective of the quest
                    local objectiveIndex = 1
                    for _, objective in ipairs(questObjectives) do
                        if objective then
                            local numFulfilled, numRequired = GetQuestObjectivesCompleted(quest.questId, objectiveIndex)
                            objectives[objectiveIndex] = { numFulfilled = numFulfilled, numRequired = numRequired }
                            objectiveIndex = objectiveIndex + 1
                            isStarted = isStarted or (numFulfilled > 0)
                        end
                    end
                end

                -- insert the quest data into the raids table
                table.insert(raidsTable, { isStarted = isStarted, isCompleted = isCompleted, questId = quest.questId, objectives = objectives })

                if LibAceAddon:ShouldShowDebugOutput() then
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

    -- assign the all xpacs table to the player data
    AllPlayersData[CurrentPlayerIdString] = nil
    AllPlayersData[CurrentPlayerIdString] = { playerName = UnitName("player"), playerRealm = GetRealmName(), shouldShow = true, data = allxpacsTable}

end
