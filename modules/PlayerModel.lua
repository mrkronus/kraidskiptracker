--[[-------------------------------------------------------------------------
    ProgressLogic.lua
    Handles step completion logic, quest status evaluation, and override helpers
---------------------------------------------------------------------------]]

local _, Addon = ...


--[[-------------------------------------------------------------------------
    Globals and Constants
---------------------------------------------------------------------------]]

local kprint = Addon.kprint

local statusTextures = {
    complete   = "Interface\\RaidFrame\\ReadyCheck-Ready",
    active     = "Interface\\Buttons\\UI-CheckBox-Check",
    onQuest    = "Interface\\RaidFrame\\ReadyCheck-NotReady",
    incomplete = "Interface\\RaidFrame\\ReadyCheck-NotReady"
}


--[[-------------------------------------------------------------------------
    Module Table
---------------------------------------------------------------------------]]

Addon.ProgressLogic = {}
local ProgressLogic = Addon.ProgressLogic


--[[-------------------------------------------------------------------------
    Player Context Helpers
---------------------------------------------------------------------------]]

--- Returns the player's faction ("Alliance" or "Horde")
function ProgressLogic:GetFaction()
    return UnitFactionGroup("player")
end

--- Returns the player's current level
function ProgressLogic:GetPlayerLevel()
    return UnitLevel("player")
end

--- Constructs the evaluation context (level, faction)
function ProgressLogic:GetContext()
    return {
        level = self:GetPlayerLevel(),
        faction = self:GetFaction()
    }
end


--[[-------------------------------------------------------------------------
    Quest ID Resolution
---------------------------------------------------------------------------]]

--- Resolves faction-specific quest ID
-- If questID is a table, returns the faction's ID; otherwise returns the number
function ProgressLogic:ResolveFactionalQuestID(questID, faction)
    if type(questID) == "table" then
        return questID[faction:lower()]
    end
    return questID
end


--[[-------------------------------------------------------------------------
    Step Completion Evaluation
---------------------------------------------------------------------------]]

--- Evaluates whether a step is complete based on context and sibling steps
-- Supports chained, parallel, choice, and nested steps
function ProgressLogic:IsStepComplete(step, ctx, steps, index)
    if step.dependsOnNext and steps and index then
        local nextStep = steps[index + 1]
        if nextStep then
            local status = self:GetStepStatus(nextStep, ctx, true, steps, index + 1)
            if status == "active" or status == "complete" then
                return true
            end
        end
    end

    if type(step.completed) == "function" then
        local ok, result = pcall(step.completed, ctx)
        return ok and result or false
    end

    if step.questID then
        local id = self:ResolveFactionalQuestID(step.questID, ctx.faction)
        return C_QuestLog.IsQuestFlaggedCompleted(id)
    end

    local children = step.steps or {}
    if step.type == "parallel" then
        for i, sub in ipairs(children) do
            if not self:IsStepComplete(sub, ctx, children, i) then
                return false
            end
        end
        return true
    elseif step.type == "choice" and step.options then
        for i, opt in ipairs(step.options) do
            if self:IsStepComplete(opt, ctx, step.options, i) then
                return true
            end
        end
        return false
    elseif next(children) then
        for i, sub in ipairs(children) do
            if not self:IsStepComplete(sub, ctx, children, i) then
                return false
            end
        end
        return true
    end

    return false
end


--[[-------------------------------------------------------------------------
    Status Evaluation
---------------------------------------------------------------------------]]

--- Resolves step status: "complete", "onQuest", "active", or fallback
function ProgressLogic:GetStepStatus(step, ctx, useFallback, steps, index)
    if self:IsStepComplete(step, ctx, steps, index) then
        return "complete"
    end

    local questID = step.questID and self:ResolveFactionalQuestID(step.questID, ctx.faction)
    local isOnQuest = questID and C_QuestLog.IsOnQuest(questID)

    if isOnQuest then return "onQuest"
    elseif step.active then return "active"
    elseif step.title and string.find(step.title, "Quest") then return "onQuest"
    elseif useFallback then
        local prev = index and index > 1 and steps[index - 1]
        local prevComplete = prev and self:IsStepComplete(prev, ctx, steps, index - 1)
        return prevComplete and "active" or "incomplete"
    end

    return nil
end

--- Returns texture path for status indicator
function ProgressLogic:GetStatusTexture(status)
    return statusTextures[status] or statusTextures["active"]
end


--[[-------------------------------------------------------------------------
    Manual Override Support
---------------------------------------------------------------------------]]

--- Manually marks a step as complete via quest ID, useful for external sync
function ProgressLogic:MarkStepCompleteByQuestID(questID)
    local zoneID = Addon.UnlockData and Addon.UnlockData.activeZoneID
    if not zoneID then return end

    local steps = Addon.UnlockData:GetSteps(zoneID)
    Addon.UnlockData:WalkSteps(steps, function(step)
        local resolvedID = self:ResolveFactionalQuestID(step.questID, self:GetFaction())
        if resolvedID == questID then
            if type(step.completed) ~= "function" then
                step.completed = function(_) return true end
            else
                step._manualComplete = true
            end
        end
    end)
end
