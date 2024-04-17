local addonName, KRaidSkipTracker = ...

local AllPlayersData = {}
local CurrentPlayerIdString = UnitName("player") .. " - " .. GetRealmName()

local HeaderFont = CreateFont("HeaderFont")
local HeaderSubTextFont = CreateFont("HeaderSubTextFont")
local SubHeaderTextFont = CreateFont("SubHeaderTextFont")
local MainTextFont = CreateFont("MainTextFont")
local NewLineFont = CreateFont("NewLineFont")

function KRaidSkipTracker.GetAllPlayersData()
    return AllPlayersData
end

function KRaidSkipTracker.GetCurrentDataVersion()
    return GetAddOnMetadata("KRaidSkipTracker", "Version")
end

function KRaidSkipTracker.InitializeFonts()
    HeaderFont:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
    HeaderSubTextFont:SetFont("Fonts\\FRIZQT__.TTF", 9, "")
    SubHeaderTextFont:SetFont("Fonts\\FRIZQT__.TTF", 12, "")
    MainTextFont:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    NewLineFont:SetFont("Fonts\\FRIZQT__.TTF", 6, "")
end

function KRaidSkipTracker.LoadData()
    AllPlayersData = LibAceAddon:GetDBAllPlayersData()
end

function KRaidSkipTracker.QueryAllQuestData()
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
    KRaidSkipTracker.QueryAllQuestData()
end

local function AddQuestLineToTooltip(tooltip, raid, quest)
    local questId = quest.questId
    local questName = GetQuestDisplayNameFromIdInData(questId) .. ": "

    if raid.isStatistic then
        if IsStatisticComplete(questId) then
            tooltip:AddLine(questName, "\124cff00ff00Acquired\124r")
        else
            if not LibAceAddon:ShouldHideNotStarted() then
                tooltip:AddLine(questName, "\124cFFA9A9A9Incomplete\124r")
            end
        end
    else
        if IsQuestComplete(questId) then
            tooltip:AddLine(questName, format("\124cff00ff00Acquired\124r"))
        else
            if HasStartedAnyQuestObjective(questId) then
                local questObjectives = C_QuestLog.GetQuestObjectives(questId)
                tooltip:AddLine(questName, GetCombinedObjectivesString(questId, questObjectives))
            else
                if not LibAceAddon:ShouldHideNotStarted() then
                    tooltip:AddLine(questName, format("\124cFFA9A9A9Not Started\124r"))
                end
            end
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
        if LibAceAddon:ShouldHideNotStarted() and not DoesRaidHaveAnyProgress(raid) then
            -- continue
        else
            tooltip:SetFont(SubHeaderTextFont)
            tooltip:AddLine(format("|cffffff00%s|r", GetRaidInstanceNameFromIdInData(raid.instanceId)))
            AddRaidToTooltip(tooltip, raid)
            tooltip:SetFont(NewLineFont)
            tooltip:AddLine("\n")
        end
    end
end

function KRaidSkipTracker.PopulateTooltip(tooltip)
    tooltip:SetHeaderFont(HeaderFont)
    tooltip:AddHeader("|cFFFFD700K Raid Skip Tracker|r")

    tooltip:SetFont(HeaderSubTextFont)
    tooltip:AddLine("|cFFF5F5F5Right click for options|r")

    tooltip:SetFont(SubHeaderTextFont)
    tooltip:AddLine("", format("|cffffff00%s|r", UnitName("player") .. "\n" .. GetRealmName()))

    local playerData = AllPlayersData[CurrentPlayerIdString]
    for _, xpac in ipairs(playerData.data) do
        AddExpansionToTooltip(tooltip, xpac)
    end
end

function KRaidSkipTracker.GetTotalPlayersCountInData()
    local entriesInDataTable = 0
    for _ in pairs(AllPlayersData) do entriesInDataTable = entriesInDataTable + 1 end

    local currentPlayerIsInTable = false
    for _, players in ipairs(AllPlayersData) do
        if players.playerName == UnitName("player") and players.playerRealm == GetRealmName() then
            currentPlayerIsInTable = true
            break
        end
    end

    if not currentPlayerIsInTable then
        entriesInDataTable = entriesInDataTable + 1
    end

    return entriesInDataTable
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
                    isCompleted = IsStatisticComplete(quest.questId) and true or false
                    isStarted = isCompleted
                else
                    -- Otherwise it's a quest
                    isCompleted = IsQuestComplete(quest.questId) and true or false
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
