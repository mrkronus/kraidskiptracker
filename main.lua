--
-- Addon data initialization
--
local addonName, KRaidSkipTracker = ...

--
-- LibDB initialization
--
local LibQTip = LibStub('LibQTip-1.0')
local LibDataBroker = LibStub("LibDataBroker-1.1")
local LibAceAddon = LibStub("AceAddon-3.0"):NewAddon("KRaidSkipTracker", "AceConsole-3.0", "AceEvent-3.0")

local aceOptions = {
    name = "KRaidSkipTracker",
    handler = LibAceAddon,
    type = 'group',
    args = {  
        showNotStarted = {
            type = "toggle",
            name = "Show Not Started Skips",
            desc = "Toggles the display of progression for skips that have not been started yet",
            get = "ShouldShowNotStarted",
            set = "ToggleShowNotStarted",
        },
    },
}

local aceOptionsDefaults = {
    profile =  {
        showNotStarted = true,
    },
}

function LibAceAddon:ShouldShowNotStarted(info)
    return self.db.profile.showNotStarted
end

function LibAceAddon:ToggleShowNotStarted(info, value)
    self.db.profile.showNotStarted = value
end

LibAceAddon.showNotStarted = true

function LibAceAddon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("KRaidSkipTrackerDB", aceOptionsDefaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("KRaidSkipTracker", aceOptions, {"kraidskiptracker", "krst"})
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("KRaidSkipTracker", "KRaidSkipTracker")
end

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
                    if LibAceAddon:ShouldShowNotStarted() then
                        tooltip:AddLine(format("%s:", v.keyName), format("\124cFFA9A9A9Incomplete\124r"))
                    end
                else
                    tooltip:AddLine(format("%s:", v.keyName), format("\124cff00ff00Acquired\124r"))
                end
            else
                local questValue = C_QuestLog.IsQuestFlaggedCompleted(v.questId)
                if questValue == true then
                    tooltip:AddLine(format("%s:", v.keyName), format("\124cff00ff00Acquired\124r"))                    
                else
                    local questObjectives = C_QuestLog.GetQuestObjectives(v.questId)
                    local hasStartedAnyObjective = false
                    if questObjectives then
                        for _,objective in ipairs(questObjectives) do
                            if objective then
                                if objective.numFulfilled > 0 then
                                    hasStartedAnyObjective = true
                                    break
                                end
                            end
                        end
                    end

                    if hasStartedAnyObjective then
                        local objectiveIndex = 1
                        local objectivesString = "(none)"
                        for _,objective in ipairs(questObjectives) do
                            if objective then

                                local questText, questObjectiveType, isFinished, numFulfilled, numRequired = GetQuestObjectiveInfo(v.questId, objectiveIndex, false)
                                if objectiveIndex == 1 then
                                    objectivesString = format("%i/%i", numFulfilled, numRequired)
                                else
                                    objectivesString = objectivesString .. format(" | %i/%i", numFulfilled, numRequired)
                                end

                                objectiveIndex = objectiveIndex + 1
                            end

                        end

                        tooltip:AddLine(format("%s:", v.keyName), objectivesString)
                    else 
                        if LibAceAddon:ShouldShowNotStarted() then
                            tooltip:AddLine(format("%s:", v.keyName), format("\124cFFA9A9A9Not Started\124r"))
                        end
                    end
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

--
-- LibDBIcon initialization
--
local dataobj = LibDataBroker:NewDataObject("K Keyed", {
    type = "launcher",
    icon = [[Interface/Icons/Inv_misc_key_15]],
    OnClick = tip_OnClick,
    OnLeave = tip_OnLeave,
    OnEnter = tip_OnEnter
})

local libIcon = LibStub("LibDBIcon-1.0", true)
libIcon:Register("K Keyed", dataobj, KKeyedDB)
libIcon:Show("K Keyed")
