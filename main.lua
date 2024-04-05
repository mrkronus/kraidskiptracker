--
-- Addon data initialization
--
local addonName, KRaidSkipTracker = ...

--
-- LibDB initialization
--
local LibQTip = LibStub('LibQTip-1.0')
local LibDataBroker = LibStub("LibDataBroker-1.1")

function tip_OnClick(clickedframe, button)
    if button == "RightButton" then
        -- do nothing for now
    end
end

local function tip_OnEnter(self)
    local tooltip = LibQTip:Acquire("KKeyedTooltip", 2, "LEFT", "RIGHT")
    self.tooltip = tooltip

    local headerFont = CreateFont("headerFont")
    headerFont:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
    
    local headerSubTextFont = CreateFont("headerSubTextFont")
    headerSubTextFont:SetFont("Fonts\\FRIZQT__.TTF", 9, "")

    local subHeaderTextFont = CreateFont("subHeaderTextFont")
    subHeaderTextFont:SetFont("Fonts\\FRIZQT__.TTF", 13, "")
    
    local mainTextFont = CreateFont("mainTextFont")
    mainTextFont:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
    
    local newLinFont = CreateFont("newLinFont")
    newLinFont:SetFont("Fonts\\FRIZQT__.TTF", 8, "")

    tooltip:SetHeaderFont(headerFont)
    tooltip:AddHeader("|cFFFFD700K Raid Skip Tracker|r")
    
    tooltip:SetFont(newLinFont)
    tooltip:AddLine("\n")

    tooltip:SetFont(subHeaderTextFont)
    tooltip:AddLine("", format("|cffffff00%s|r", UnitName("player")))

    local raidSkipsNames, raidSkipsQuestData = GetRaidSkipsQuestData()

    for _, raidValues in ipairs(RaidOrder) do
        tooltip:SetFont(subHeaderTextFont)
        tooltip:AddLine(format("|cffffff00%s|r", raidSkipsNames[raidValues]))

        for _,  v in  ipairs(raidSkipsQuestData[raidValues]) do
            tooltip:SetFont(mainTextFont)
            if v.isStatistic == true then
                local statisticVal = GetStatistic(v.questId)
                if(statisticVal == nil or statisticVal == "--" or tonumber(statisticVal) == 0) then
                    tooltip:AddLine(format("%s:", v.keyName), format("Incomplete"))
                else
                    tooltip:AddLine(format("%s:", v.keyName), format("\124cff00ff00Acquired\124r"))
                end
            else
                local questValue = C_QuestLog.IsQuestFlaggedCompleted(v.questId)
                if questValue == true then
                    tooltip:AddLine(format("%s:", v.keyName), format("\124cff00ff00Acquired\124r"))                    
                else
                    local questText, questObjectiveType, isFinished, numFulfilled, numRequired = GetQuestObjectiveInfo(v.questId, 1, false)
                    tooltip:AddLine(format("%s:", v.keyName), format("%i/%i", numFulfilled, numRequired))     
                end
            end
        end
        tooltip:SetFont(newLinFont)
        tooltip:AddLine("\n")
    end

    tooltip:SmartAnchorTo(self)
    tooltip:Show()
end

local function tip_OnLeave(self)
    LibQTip:Release(self.tooltip)
    self.tooltip = nil
end

local dataobj = LibDataBroker:NewDataObject("K Keyed", {
    type = "launcher",
    icon = [[Interface/Icons/Inv_misc_key_15]],
    OnClick = tip_OnClick,
    OnLeave = tip_OnLeave,
    OnEnter = tip_OnEnter
})

--
-- LibIcon initialization
--
local icon = LibStub("LibDBIcon-1.0", true)
icon:Register("K Keyed", dataobj, KKeyedDB)
icon:Show("K Keyed")
