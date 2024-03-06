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
        PrintKeysToChat()
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
    tooltip:AddHeader("|cFFFFD700K Keyed|r")

    tooltip:SetFont(headerSubTextFont)
    tooltip:AddLine("|cFFF5F5F5Right click to show in chat|r")
    
    tooltip:SetFont(newLinFont)
    tooltip:AddLine("\n")

    -- for _, raidValues in ipairs(RaidSkipsQuestData) do
    --     tooltip:SetFont(subHeaderTextFont)
    --     tooltip:AddLine(format("|cffffff00%s|r", raidValues))
    --     for _,  v in  ipairs(RaidSkipsQuestData[raidValues]) do
    --         tooltip:SetFont(mainTextFont)
    --         if v.isStatistic == true then
    --             local statisticVal = GetStatistic(v.questId)
    --             if(statisticVal == nil or statisticVal == "--" or tonumber(statisticVal) == 0) then
    --                 tooltip:AddLine(format("%s:", v.keyName), format("\124cffff0000No\124r"))
    --             else
    --                 tooltip:AddLine(format("%s:", v.keyName), format("\124cff00ff00Yes\124r"))
    --             end
    --         else
    --             local questValue = C_QuestLog.IsQuestFlaggedCompleted(v.questId)
    --             tooltip:AddLine(format("%s:", v.keyName), format("%s", questValue and "\124cff00ff00Yes\124r" or "\124cffff0000No\124r"))
    --         end
    --     end
    --     tooltip:SetFont(newLinFont)
    --     tooltip:AddLine("\n")
    -- end

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

--
-- Slash command registration
--
SLASH_KEYS1 = "/keys"
SlashCmdList["KEYS"] = function(msg)
    PrintKeysToChat()
end

--
-- Slash command worker method
--
function PrintKeysToChat()

    local raidskips = KRaidSkipTracker:GetRaidSkipData()

    print("\n")
    for _, raidValues in ipairs(raidskips) do
        print(raidValues)
        for _,  v in raidskips[raidValues] do
            print(format("%s: %s", v.keyName, C_QuestLog.IsQuestFlaggedCompleted(v.questId) and "\124cff00ff00Yes\124r" or "\124cffff0000No\124r"))
        end
        print("\n")
    end
end