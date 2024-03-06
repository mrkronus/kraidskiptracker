--
-- Creates and returns the raid skips quest data
-- struct used to query data in RefreshRaidSkipsData()
--

local addonName, KRaidSkipTracker = ...
local function GetRaidSkipsQuestData()

    local raidSkipsQuestData = {}
    table.insert(raidSkipsQuestData, "Blackrock Foundary");
    local raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 37029, isStatistic = false },
                        { keyName = "Heroic", questId = 37030, isStatistic = false },
                        { keyName = "Mythic", questId = 37031, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "Hellfire Citadel");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal Upper Citadel", questId = 39499, isStatistic = false },
                        { keyName = "Heroic Upper Citadel", questId = 39500, isStatistic = false },
                        { keyName = "Mythic Upper Citadel", questId = 39501, isStatistic = false },
                        { keyName = "Normal Destructor's Rise", questId = 39502, isStatistic = false },
                        { keyName = "Heroic Destructor's Rise", questId = 39504, isStatistic = false },
                        { keyName = "Mythic Destructor's Rise", questId = 39505, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "The Emerald Nightmare");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 44283, isStatistic = false },
                        { keyName = "Heroic", questId = 44284, isStatistic = false },
                        { keyName = "Mythic", questId = 44285, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "The Nighthold");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 45381, isStatistic = false },
                        { keyName = "Heroic", questId = 45382, isStatistic = false },
                        { keyName = "Mythic", questId = 45383, isStatistic = false } }
            
    table.insert(raidSkipsQuestData, "Tomb of Sargeras");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 47725, isStatistic = false },
                        { keyName = "Heroic", questId = 47726, isStatistic = false },
                        { keyName = "Mythic", questId = 47727, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "Antorus, the Burning Throne");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal Imonar", questId = 49032, isStatistic = false },
                        { keyName = "Heroic Imonar", questId = 49075, isStatistic = false },
                        { keyName = "Mythic Imonar", questId = 49076, isStatistic = false },
                        { keyName = "Heroic Aggramar", questId = 49134, isStatistic = false },
                        { keyName = "Normal Aggramar", questId = 49133, isStatistic = false },
                        { keyName = "Mythic Aggramar", questId = 49135, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "Ny'alotha, the Waking City");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 58373, isStatistic = false },
                        { keyName = "Heroic", questId = 58374, isStatistic = false },
                        { keyName = "Mythic", questId = 58375, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "Battle of Dazar'alor");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Mythic", questId = 13382, isStatistic = true } }
    
    table.insert(raidSkipsQuestData, "Castle Nathria");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 62054, isStatistic = false },
                        { keyName = "Heroic", questId = 62055, isStatistic = false },
                        { keyName = "Mythic", questId = 62056, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "Sanctum of Domination");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 64597, isStatistic = false },
                        { keyName = "Heroic", questId = 64598, isStatistic = false },
                        { keyName = "Mythic", questId = 64599, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "Sepulcher of the First Ones");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 65764, isStatistic = false },
                        { keyName = "Heroic", questId = 65763, isStatistic = false },
                        { keyName = "Mythic", questId = 65762, isStatistic = false } }
    
    table.insert(raidSkipsQuestData, "Vault of the Incarnates");
    raidKeys = raidSkipsQuestData[#raidSkipsQuestData]
    raidSkipsQuestData[raidKeys] = { { keyName = "Normal", questId = 71018, isStatistic = false },
                        { keyName = "Heroic", questId = 71019, isStatistic = false },
                        { keyName = "Mythic", questId = 71020, isStatistic = false } }

    return raidSkipsQuestData
end


--
-- Usable data struct of the skips a character has
--                    
local RaidSkipsData = {}
local function RefreshRaidSkipsData()

    local raidSkipsQuestData = GetRaidSkipsQuestData()
    for _, raidValues in ipairs(raidSkipsQuestData) do

        -- add the name of the raid
        table.insert(raidSkipsQuestData, raidValues);

        for _,  v in  ipairs(raidSkipsQuestData[raidValues]) do

            -- find the actual data
            raidSkips = raidSkipsQuestData[#raidSkipsQuestData]
            skipName = {}
            skipValue = {}

            if v.isStatistic == true then
                local statisticVal = GetStatistic(v.questId)
                skipName = v.keyName
                if(statisticVal == nil or statisticVal == "--" or tonumber(statisticVal) == 0) then
                    skipValue = 0
                else
                    skipValue = 1
                end
            else
                local questValue = C_QuestLog.IsQuestFlaggedCompleted(v.questId)
                skipName = v.keyName
                keyValue = questValue
            end

            -- append to the data struct
            raidSkipsQuestData[raidSkips] = { keyName = skipName, keyValue = skipValue }

        end

        RaidSkipsData = raidSkipsQuestData
    end

end

function KRaidSkipTracker:GetRaidSkipData()

    if (RaidSkipsData == nil) then
        RefreshRaidSkipsData()
    end

    return RaidSkipsData

end
