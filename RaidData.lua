--
-- Addon data initialization
--
local addonName, KRaidSkipTracker = ...

-- List of raid IDs, in order 
-- from https://wowpedia.fandom.com/wiki/InstanceID
local RaidOrder =
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
    2569, -- DF: Aberrus, the Shadowed Crucible
    0000, -- DF: Amirdrassil, the Dream's Hope
}

KRaidSkipTracker.questDataByExpansion =
{
    {
        expansionName = EXPANSION_NAME5,
        raids =
        {
            -- WOD: Blackrock Foundry
            {
                instanceName = "WOD: Blackrock Foundry", instanceId = 1205, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 37029 },
                    { questName = "Heroic", questId = 37030 },
                    { questName = "Mythic", questId = 37031 }
                }
            },

            -- WOD: Hellfire Citadel
            {
                instanceName = "WOD: Hellfire Citadel", instanceId = 1448, isStatistic = false,
                quests =
                {
                    { questName = "Normal Upper Citadel", questId = 39499 },
                    { questName = "Heroic Upper Citadel", questId = 39500 },
                    { questName = "Mythic Upper Citadel", questId = 39501 },
                    { questName = "Normal Destructor's Rise", questId = 39502 },
                    { questName = "Heroic Destructor's Rise", questId = 39504 },
                    { questName = "Mythic Destructor's Rise", questId = 39505 }
                },
            },
        }
    },
    {
        expansionName = EXPANSION_NAME6,
        raids =
        {
            -- Legion: The Emerald Nightmare
            {
                instanceName = "Legion: The Emerald Nightmare", instanceId = 1520, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 44283 },
                    { questName = "Heroic", questId = 44284 },
                    { questName = "Mythic", questId = 44285 }
                }
            },

            -- Legion: The Nighthold
            {
                instanceName = "Legion: The Nighthold", instanceId = 1530, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 45381 },
                    { questName = "Heroic", questId = 45382 },
                    { questName = "Mythic", questId = 45383 }
                }
            },

            -- Legion: Tomb of Sargeras
            {
                instanceName = "Legion: Tomb of Sargeras", instanceId = 1676, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 47725 },
                    { questName = "Heroic", questId = 47726 },
                    { questName = "Mythic", questId = 47727 }
                }
            },

            -- Legion: Antorus, the Burning Throne
            {
                instanceName = "Legion: Antorus, the Burning Throne", instanceId = 1712, isStatistic = false,
                quests =
                {
                    { questName = "Normal Imonar", questId = 49032 },
                    { questName = "Heroic Imonar", questId = 49075 },
                    { questName = "Mythic Imonar", questId = 49076 },
                    { questName = "Heroic Aggramar", questId = 49134 },
                    { questName = "Normal Aggramar", questId = 49133 },
                    { questName = "Mythic Aggramar", questId = 49135 }
                },
            },
        }
    },
    {
        expansionName = EXPANSION_NAME7,
        raids =
        {
            -- BFA: Ny'alotha, the Waking City
            {
                instanceName = "BFA: Ny'alotha, the Waking City", instanceId = 2217, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 58373 },
                    { questName = "Heroic", questId = 58374 },
                    { questName = "Mythic", questId = 58375 } 
                }
            },

            -- BFA: Battle of Dazar'alor
            {
                instanceName = "BFA: Battle of Dazar'alor", instanceId = 2070, isStatistic = true,
                quests =
                {
                    { questName = "Mythic", questId = 13382 }
                }
            },
        }
    },
    {
        expansionName = EXPANSION_NAME8,
        raids =
        {
            -- SL: Castle Nathria
            {
                instanceName = "SL: Castle Nathria", instanceId = 2296, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 62054 },
                    { questName = "Heroic", questId = 62055 },
                    { questName = "Mythic", questId = 62056 }
                }
            },
            -- SL: Sanctum of Domination
            {
                instanceName = "SL: Sanctum of Domination", instanceId = 2450, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 64597 },
                    { questName = "Heroic", questId = 64598 },
                    { questName = "Mythic", questId = 64599 }
                }
            },
            -- SL: Sepulcher of the First Ones
            {
                instanceName = "SL: Sepulcher of the First Ones", instanceId = 2481, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 65764 },
                    { questName = "Heroic", questId = 65763 },
                    { questName = "Mythic", questId = 65762 }
                }
            },
        }
    },
    {
        expansionName = EXPANSION_NAME9,
        raids =
        {
            -- DF: Vault of the Incarnates
            {
                instanceName = "DF: Vault of the Incarnates", instanceId = 2522, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 71018 },
                    { questName = "Heroic", questId = 71019 },
                    { questName = "Mythic", questId = 71020 }
                }
            },

            -- DF: Aberrus, the Shadowed Crucible
            {
                instanceName = "DF: Aberrus, the Shadowed Crucible", instanceId = 2569, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 76083 },
                    { questName = "Heroic", questId = 76085 },
                    { questName = "Mythic", questId = 76086 }
                }
            },

            -- DF: Amirdrassil, the Dream's Hope
            {
                instanceName = "DF: Amirdrassil, the Dream's Hope", instanceId = 2569, isStatistic = false,
                quests =
                {
                    { questName = "Normal", questId = 78600 },
                    { questName = "Heroic", questId = 78601 },
                    { questName = "Mythic", questId = 78602 }
                }
            },
        }
    }
}
