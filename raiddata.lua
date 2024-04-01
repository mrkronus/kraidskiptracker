--
-- Creates and returns the raid skips quest data
-- struct used to query data in RefreshRaidSkipsData()
--
local addonName, KRaidSkipTracker = ...

-- List of raid IDs, in order 
-- from https://wowpedia.fandom.com/wiki/InstanceID
RaidOrder = 
{
    1205, -- WOD: Blackrock Foundry
    1448, -- WOD: Hellfire Citadel
    1520, -- Legion: The Emerald Nightmare
    1530, -- Legion: The Nighthold
    1676, -- Legion: Tomb of Sargeras

    1712, -- Legion: Antorus, the Burning Throne
    2217, -- BFA: Ny'alotha, the Waking City
    2070, -- BFA: Battle of Dazar'alor
    2296, -- SL: Castle Nathria
    2450, -- SL: Sanctum of Domination

    2481, -- SL: Sepulcher of the First Ones
    2522, -- DF: Vault of the Incarnates
}

function GetRaidSkipsQuestData()

    local raidSkipsNames = {}
    local raidSkipsQuestData = {}
    
    raidSkipsNames[RaidOrder[1]] = "WOD: Blackrock Foundry"
    raidSkipsQuestData[RaidOrder[1]] = { { keyName = "Normal", questId = 37029, isStatistic = false },
                        { keyName = "Heroic", questId = 37030, isStatistic = false },
                        { keyName = "Mythic", questId = 37031, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[2]] = "WOD: Hellfire Citadel"
    raidSkipsQuestData[RaidOrder[2]] = { { keyName = "Normal Upper Citadel", questId = 39499, isStatistic = false },
                        { keyName = "Heroic Upper Citadel", questId = 39500, isStatistic = false },
                        { keyName = "Mythic Upper Citadel", questId = 39501, isStatistic = false },
                        { keyName = "Normal Destructor's Rise", questId = 39502, isStatistic = false },
                        { keyName = "Heroic Destructor's Rise", questId = 39504, isStatistic = false },
                        { keyName = "Mythic Destructor's Rise", questId = 39505, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[3]] = "Legion: The Emerald Nightmare"
    raidSkipsQuestData[RaidOrder[3]] = { { keyName = "Normal", questId = 44283, isStatistic = false },
                        { keyName = "Heroic", questId = 44284, isStatistic = false },
                        { keyName = "Mythic", questId = 44285, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[4]] = "Legion: The Nighthold"
    raidSkipsQuestData[RaidOrder[4]] = { { keyName = "Normal", questId = 45381, isStatistic = false },
                        { keyName = "Heroic", questId = 45382, isStatistic = false },
                        { keyName = "Mythic", questId = 45383, isStatistic = false } }
            
    raidSkipsNames[RaidOrder[5]] = "Legion: Tomb of Sargeras"
    raidSkipsQuestData[RaidOrder[5]] = { { keyName = "Normal", questId = 47725, isStatistic = false },
                        { keyName = "Heroic", questId = 47726, isStatistic = false },
                        { keyName = "Mythic", questId = 47727, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[6]] = "Legion: Antorus, the Burning Throne"
    raidSkipsQuestData[RaidOrder[6]] = { { keyName = "Normal Imonar", questId = 49032, isStatistic = false },
                        { keyName = "Heroic Imonar", questId = 49075, isStatistic = false },
                        { keyName = "Mythic Imonar", questId = 49076, isStatistic = false },
                        { keyName = "Heroic Aggramar", questId = 49134, isStatistic = false },
                        { keyName = "Normal Aggramar", questId = 49133, isStatistic = false },
                        { keyName = "Mythic Aggramar", questId = 49135, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[7]] = "BFA: Ny'alotha, the Waking City"
    raidSkipsQuestData[RaidOrder[7]] = { { keyName = "Normal", questId = 58373, isStatistic = false },
                        { keyName = "Heroic", questId = 58374, isStatistic = false },
                        { keyName = "Mythic", questId = 58375, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[8]] = "BFA: Battle of Dazar'alor"
    raidSkipsQuestData[RaidOrder[8]] = { { keyName = "Mythic", questId = 13382, isStatistic = true } }
    
    raidSkipsNames[RaidOrder[9]] = "SL: Castle Nathria"
    raidSkipsQuestData[RaidOrder[9]] = { { keyName = "Normal", questId = 62054, isStatistic = false },
                        { keyName = "Heroic", questId = 62055, isStatistic = false },
                        { keyName = "Mythic", questId = 62056, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[10]] = "SL: Sanctum of Domination"
    raidSkipsQuestData[RaidOrder[10]] = { { keyName = "Normal", questId = 64597, isStatistic = false },
                        { keyName = "Heroic", questId = 64598, isStatistic = false },
                        { keyName = "Mythic", questId = 64599, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[11]] = "SL: Sepulcher of the First Ones"
    raidSkipsQuestData[RaidOrder[11]] = { { keyName = "Normal", questId = 65764, isStatistic = false },
                        { keyName = "Heroic", questId = 65763, isStatistic = false },
                        { keyName = "Mythic", questId = 65762, isStatistic = false } }
    
    raidSkipsNames[RaidOrder[12]] = "DF: Vault of the Incarnates"
    raidSkipsQuestData[RaidOrder[12]] = { { keyName = "Normal", questId = 71018, isStatistic = false },
                        { keyName = "Heroic", questId = 71019, isStatistic = false },
                        { keyName = "Mythic", questId = 71020, isStatistic = false } }

    return raidSkipsNames, raidSkipsQuestData
end

function KRaidSkipTracker:GetRaidSkipData()

    return RaidSkipsData

end
