local addonName, KRaidSkipTracker = ...

local AllPlayersData = {}
local CurrentPlayerIdString = UnitName("player") .. " - " .. GetRealmName()

function KRaidSkipTracker.GetAllPlayersData()
    return AllPlayersData
end

local HeaderFont = CreateFont("HeaderFont")
local HeaderSubTextFont = CreateFont("HeaderSubTextFont")
local SubHeaderTextFont = CreateFont("SubHeaderTextFont")
local MainTextFont = CreateFont("MainTextFont")
local NewLineFont = CreateFont("NewLineFont")

local function AddQuestLineToTooltip(tooltip, raid, quest)
    local questName = quest.questName .. ": "
    local questId = quest.questId

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
                local objectiveIndex = 1
                local objectivesString = "(none)"
                local questObjectives = C_QuestLog.GetQuestObjectives(questId)
                for _, objective in ipairs(questObjectives) do
                    if objective then
                        local numFulfilled, numRequired = GetQuestObjectivesCompleted(questId, objectiveIndex)
                        if objectiveIndex == 1 then
                            objectivesString = format("%i/%i", numFulfilled, numRequired)
                        else
                            objectivesString = objectivesString .. format(" | %i/%i", numFulfilled, numRequired)
                        end

                        objectiveIndex = objectiveIndex + 1
                    end
                end

                tooltip:AddLine(questName, objectivesString)
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

local function AddExpanstionToTooltip(tooltip, xpac)
    for _, raid in ipairs(xpac.raids) do
        if LibAceAddon:ShouldHideNotStarted() and not DoesRaidHaveAnyProgress(raid) then
            -- continue
        else
            tooltip:SetFont(SubHeaderTextFont)
            tooltip:AddLine(format("|cffffff00%s|r", raid.instanceName))
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

    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        AddExpanstionToTooltip(tooltip, xpac)
    end
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

function KRaidSkipTracker.UpdateCurrentPlayerData()

    AllPlayersData[GetRealmName()][UnitName("player")] = nil
    AllPlayersData[GetRealmName()][UnitName("player")] = {}

    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        local xpacsTable = {}
        xpacsTable[xpac.expansionName] = {}
        for _, raid in ipairs(xpac.raids) do
            local raidsTable = {}
            raidsTable[raid.instanceId] = {};
            for _, quest in ipairs(raid.quests) do
                local questsTable = {}
                local isStarted, isCompleted = false, false
                local objectives = {}

                if raid.isStatistic then
                    isCompleted = IsStatisticComplete(quest.questId) and true or false
                    isStarted = isCompleted
                else
                    -- TODO this isn't working to save objectives for some reason
                    isCompleted = IsQuestComplete(quest.questId) and true or false
                    isStarted = HasStartedAnyQuestObjective(quest.questId)
                    if isStarted then
                        local objectiveIndex = 1
                        local questObjectives = C_QuestLog.GetQuestObjectives(quest.questId)
                        for _, objective in ipairs(questObjectives) do
                            if objective then
                                local numFulfilled, numRequired = GetQuestObjectivesCompleted(quest.questId, objectiveIndex)
                                objectives[objectiveIndex] = { numFulfilled = numFulfilled, numRequired = numRequired }
                                objectiveIndex = objectiveIndex + 1
                            end
                        end
                    end
                end

                questsTable[quest.questId] = { isStarted = isStarted, isCompleted = isCompleted, objectives = objectives }
                table.insert(raidsTable[raid.instanceId], { isStatistic = raid.isStatistic, questsTable })
            end
            table.insert(xpacsTable[xpac.expansionName], raidsTable)
        end

        AllPlayersData[GetRealmName()][UnitName("player")] = { playerName = UnitName("player"), playerRealm = GetRealmName(), shouldShow = true, data = xpacsTable }
    end

end

function KRaidSkipTracker.Initialize()
    KRaidSkipTracker.InitializeFonts()
    KRaidSkipTracker.LoadData()
    KRaidSkipTracker.UpdateCurrentPlayerData()
end
