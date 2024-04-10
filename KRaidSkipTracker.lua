local addonName, KRaidSkipTracker = ...

local HeaderFont = CreateFont("HeaderFont")
HeaderFont:SetFont("Fonts\\FRIZQT__.TTF", 14, "")

local HeaderSubTextFont = CreateFont("HeaderSubTextFont")
HeaderSubTextFont:SetFont("Fonts\\FRIZQT__.TTF", 9, "")

local SubHeaderTextFont = CreateFont("SubHeaderTextFont")
SubHeaderTextFont:SetFont("Fonts\\FRIZQT__.TTF", 13, "")

local MainTextFont = CreateFont("MainTextFont")
MainTextFont:SetFont("Fonts\\FRIZQT__.TTF", 10, "")

local NewLineFont = CreateFont("NewLineFont")
NewLineFont:SetFont("Fonts\\FRIZQT__.TTF", 8, "")

local function AddQuestLineToTooltip(tooltip, raid, quest)
    local questName = quest.questName .. ": "
    local questId = quest.questId

    if raid.isStatistic then
        if IsStatisticComplete(questId) then
            tooltip:AddLine(questName, "\124cff00ff00Acquired\124r")
        else
            if LibAceAddon:ShouldShowNotStarted() then
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
                if LibAceAddon:ShouldShowNotStarted() then
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
    if LibAceAddon:ShouldShowNotStarted() or DoesExpansionHaveAnyProgress(xpac) then
        for _, raid in ipairs(xpac.raids) do
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

    tooltip:SetFont(NewLineFont)
    tooltip:AddLine("\n")

    tooltip:SetFont(SubHeaderTextFont)
    tooltip:AddLine("", format("|cffffff00%s|r", UnitName("player")))

    for _, xpac in ipairs(KRaidSkipTracker.questDataByExpansion) do
        AddExpanstionToTooltip(tooltip, xpac)
    end
end
