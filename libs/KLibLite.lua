--[[-------------------------------------------------------------------------
    Addon Data Initialization
---------------------------------------------------------------------------]]

local _, Addon = ...


--[[-------------------------------------------------------------------------
    KLib Colors
---------------------------------------------------------------------------]]

Addon.Colors = {
    -- Section Markers
    Header       = "FFFFD700",
    SubHeader    = "FFFFFF00",
    Footer       = "FFF5F5F5",
    FooterDark   = "FFA9A9A9",

    -- Status Text
    Acquired     = "FF00FF00",
    Incomplete   = "FFA9A9A9",

    -- Faction Representation
    Alliance     = "FF4A54E8",
    Horde        = "FFE50D12",

    -- Expansion Highlights
    CLASSIC      = "FFE6CC80",
    TBC          = "FF1EFF00",
    WOTLK        = "FF66ccff",
    CATA         = "FFff3300",
    MOP          = "FF00FF96",
    WOD          = "FFff8C1A",
    LEGION       = "FFA335EE",
    BFA          = "FFFF7D0A",
    SHADOWLANDS  = "FFE6CC80",
    DRAGONFLIGHT = "FF33937F",

    -- Generic Colors
    Yellow       = "FFFFFF00",
    White        = "FFFFFFFF",
    Grey         = "FFA9A9A9",
    Red          = "FFFF0000",

    -- Item Quality
    Common       = "FFFFFFFF",
    Uncommon     = "FF1EFF00",
    Rare         = "FF0070DD",
    Epic         = "FFA335EE",
    Legendary    = "FFFF8000",
    Artifact     = "FFE6CC80",
    WowToken     = "FF00CCFF",

    -- Class-Specific Colors
    DeathKnight  = "FFC41F3B",
    DemonHunter  = "FFA330C9",
    Druid        = "FFFF7D0A",
    Evoker       = "FF33937F",
    Hunter       = "FFABD473",
    Mage         = "FF69CCF0",
    Monk         = "FF00FF96",
    Paladin      = "FFF58CBA",
    Priest       = "FFFFFFFF",
    Rogue        = "FFFFF569",
    Shaman       = "FF0070DE",
    Warlock      = "FF9482C9",
    Warrior      = "FFC79C6E",

    -- Custom Tags
    Beledar      = "FFA060FF",
    NotKilled    = "FFFF0000",
    Killed       = "FF00FF00",
}


--[[-------------------------------------------------------------------------
    Colorize Utility
---------------------------------------------------------------------------]]

--- Wraps text in WoW-style color codes
---@param text string
---@param color string -- Format: "FFAABBCC" (without pipes)
---@return string
---@diagnostic disable-next-line: lowercase-global
function colorize(text, color)
    if type(text) ~= "string" then return "" end
    if type(color) ~= "string" then return text end
    return string.format("\124c%s%s\124r", color:upper(), text)
end


--[[-------------------------------------------------------------------------
    Other Global Helpers
---------------------------------------------------------------------------]]

---@diagnostic disable-next-line: lowercase-global
function classToColor(class)
    local classToColorTable =
    {
        ["DEATHKNIGHT"] = Addon.Colors.DeathKnight,
        ["DEMONHUNTER"] = Addon.Colors.DemonHunter,
        ["DRUID"] = Addon.Colors.Druid,
        ["EVOKER"] = Addon.Colors.Evoker,
        ["HUNTER"] = Addon.Colors.Hunter,
        ["MAGE"] = Addon.Colors.Mage,
        ["MONK"] = Addon.Colors.Monk,
        ["PALADIN"] = Addon.Colors.Paladin,
        ["PRIEST"] = Addon.Colors.Priest,
        ["ROGUE"] = Addon.Colors.Rogue,
        ["SHAMAN"] = Addon.Colors.Shaman,
        ["WARLOCK"] = Addon.Colors.Warlock,
        ["WARRIOR"] = Addon.Colors.Warrior,
    }

    local color = classToColorTable[class]
    if color ~= nil then
        return color
    end

    return Addon.Colors.Grey
end

---@diagnostic disable-next-line: lowercase-global
function commaFormatInt(i)
    return tostring(i):reverse():gsub("%d%d%d", "%1,"):reverse():gsub("^,", "")
end


--[[-------------------------------------------------------------------------
    TextIcons
---------------------------------------------------------------------------]]

Addon.TextIcons = {
    RedX        = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:0|t",
    GreenCheck  = "|TInterface\\RaidFrame\\ReadyCheck-Ready:0|t",
    YellowCheck = "|TInterface\\Icons\\Achievement_General:0|t",
    OrangeStar  = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t",
    Mythic      = "|TInterface\\RaidFrame\\Raid-Icon-RaidLeader:0|t",
    MythicIcon  = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:0|t", -- OrangeStar
    Heroic      = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:0|t",
    HeroicIcon  = "|TInterface\\Icons\\Achievement_General:0|t", -- YellowCheck,
    Normal      = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:0|t",
    Unknown     = "|TInterface\\Icons\\INV_Misc_QuestionMark:0|t",
}

--[[-------------------------------------------------------------------------
    KLib Fonts
---------------------------------------------------------------------------]]

-- Defines custom font objects for consistent UI usage
Addon.Fonts = {
    MainHeader = CreateFont("KLib_MainHeaderFont"),
    FooterText = CreateFont("KLib_FooterTextFont"),
    Heading    = CreateFont("KLib_HeadingFont"),
    MainText   = CreateFont("KLib_MainTextFont")
}

-- Set font attributes (font path, size, flags)
Addon.Fonts.MainHeader:SetFont("Fonts\\FRIZQT__.TTF", 16, "")
Addon.Fonts.FooterText:SetFont("Fonts\\FRIZQT__.TTF", 10, "")
Addon.Fonts.Heading:SetFont("Fonts\\FRIZQT__.TTF", 14, "")
Addon.Fonts.MainText:SetFont("Fonts\\FRIZQT__.TTF", 12, "")


--[[-------------------------------------------------------------------------
    KDebug Integration
---------------------------------------------------------------------------]]

local KDebug = _G.KDebug
if KDebug then
    Addon.kprint = KDebug.kprint
    Addon.HasKDebug = true
else
    Addon.kprint = function(...) end
    Addon.HasKDebug = false
end
