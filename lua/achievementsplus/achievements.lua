-- Made by !cake
if not AchievementsPlus then
    AchievementsPlus = {}
    AchievementsPlus.Achievements = {}
    AchievementsPlus.AchievementCount = 0
    AchievementsPlus.MapIDsToNames = {}
    AchievementsPlus.EventHooks = {}
end

if AchievementsPlus.Initialized then
    AchievementsPlus:Uninitialize()
end

timer.Create("AchievementsPlus.Initialize", 0.1, 1, function()
    AchievementsPlus:Initialize()
end)

function AchievementsPlus:Initialize()
    if self.Initialized then return end
    self.Initialized = true
    AchievementsPlus:HookFunctions()
    local achievements = file.Find("achievementsplus/achievements/*.lua", "LUA")

    for _, file in ipairs(achievements) do
        include("achievementsplus/achievements/" .. file)
    end

    self:AddEventHook("ShutDown", "AchievementsPlus.ShutDown", function()
        AchievementsPlus:Uninitialize()
    end)

    self:Load()
    self:CallHook("AchievementsPlusLoaded")
    Msg("Achievements Plus loaded.\n")
    Msg(tostring(self.AchievementCount) .. " achievements loaded.\n")
end

function AchievementsPlus:Uninitialize()
    if not self.Initialized then return end
    self:CallHook("AchievementsPlusUnloaded")
    hook.Remove("Think", "AchievementsPlus.ThinkHook")
    AchievementsPlus:Save()
    self.Achievements = {}
    self.AchievementCount = 0
    self.MapIDsToNames = {}
    self.EventHooks = {}
    self.Initialized = false
    Msg("Achievements Plus unloaded.\n")
end

-- Hooks
function AchievementsPlus:AddEventHook(event, name, func, ach)
    if not AchievementsPlus.EventHooks[event] then
        AchievementsPlus.EventHooks[event] = {}
    end

    if not AchievementsPlus.EventHooks[event][name] then
        AchievementsPlus.EventHooks[event][name] = {}
    end

    AchievementsPlus.EventHooks[event][name].func = func
    AchievementsPlus.EventHooks[event][name].ach = ach
end

function AchievementsPlus:AddAchievementHook(id, type, func)
    self:AddEventHook(type, id, func, id)
end

function AchievementsPlus:CallHook(name, arg1, ...)
    if not self.EventHooks[name] then return end

    for _, v in pairs(self.EventHooks[name]) do
        if not v.ach or (v.ach and self.Achievements[v.ach].count ~= self.Achievements[v.ach].goal) then
            v.func(arg1, ...)

            if type(arg1) == "bf_read" then
                arg1:Reset()
                arg1:ReadString()
            end
        end
    end
end

function AchievementsPlus:HookFunctions()
    if not self.OldusermessageIncomingMessage then
        self.OldusermessageIncomingMessage = usermessage.IncomingMessage
    end

    function usermessage.IncomingMessage(type, data)
        AchievementsPlus:CallHook(type, data)
        AchievementsPlus.OldusermessageIncomingMessage(type, data)
    end

    if not self.OldHookCall then
        self.OldHookCall = hook.Call
    end

    function hook.Call(name, gm, ...)
        local a, b, c, d, e, f, g, h, i, j, k = AchievementsPlus.OldHookCall(name, gm, ...)
        AchievementsPlus:CallHook(name, ...)

        return a, b, c, d, e, f, g, h, i, j, k
    end

    hook.Add("Think", "AchievementsPlus.ThinkHook", function()
        AchievementsPlus:CallHook("Think")
    end)

    hook.Add("ShutDown", "AchievementsPlus.ShutDownHook", function()
        AchievementsPlus:CallHook("ShutDown")
    end)
end

-- Achievements
function AchievementsPlus:RegisterAchievement(id, name, desc, material, goal, count)
    local creating = false

    if not self.Achievements[id] then
        creating = true
        self.MapIDsToNames[self.AchievementCount] = id
        self.AchievementCount = self.AchievementCount + 1
    end

    self.Achievements[id] = self.Achievements[id] or {}
    self.Achievements[id].name = self.Achievements[id].name or name or "Generic Achievement"
    self.Achievements[id].desc = self.Achievements[id].desc or desc or "???"
    self.Achievements[id].material = self.Achievements[id].material or material or ""

    if creating then
        self.Achievements[id].count = count or 0
        self.Achievements[id].goal = goal or 1
    else
        if self.Achievements[id].count > count then
            count = self.Achievements[id].count
        end

        if self.Achievements[id].goal > goal then
            goal = self.Achievements[id].goal
        end

        self.Achievements[id].count = count or 0
        self.Achievements[id].goal = goal or 1
    end
end

function AchievementsPlus:GetAchievementByID(id)
    return self.Achievements[self.MapIDsToNames[id]]
end

function AchievementsPlus:AddAchievementCount(id, amount)
    amount = amount or 1

    if self.Achievements[id].count ~= self.Achievements[id].goal then
        self.Achievements[id].count = self.Achievements[id].count + amount
        self:CallHook("AchievementProgress", id, amount)

        if self.Achievements[id].count == self.Achievements[id].goal then
            self:OnAchievementUnlocked(id)
        end
    end
end

function AchievementsPlus:OnAchievementUnlocked(id)
    self:CallHook("AchievementUnlocked", id)
end

function AchievementsPlus:GetAchievementCount()
    return self.AchievementCount
end

function AchievementsPlus:GetAchievementGoalCount(achid)
    if not self.Achievements[achid] then
        Msg("AchievementsPlus:GetAchievementGoalCount (" .. tostring(achid) .. "): Achievement ID is invalid.\n")

        return 1
    end

    return self.Achievements[achid].count
end

function AchievementsPlus:GetAchievementGoal(achid)
    if not self.Achievements[achid] then
        Msg("AchievementsPlus:GetAchievementGoal (" .. tostring(achid) .. "): Achievement ID is invalid.\n")

        return 1
    end

    return self.Achievements[achid].goal
end

function AchievementsPlus:GetAchievementDesc(achid)
    return self.Achievements[achid].desc
end

function AchievementsPlus:GetAchievementName(achid)
    return self.Achievements[achid].name
end

function AchievementsPlus:GetAchievementMaterial(achid)
    if not self.Achievements[achid] then
        Msg("AchievementsPlus:GetAchievementMaterial (" .. tostring(achid) .. "): Achievement ID is invalid.\n")

        return ""
    end

    return self.Achievements[achid].material
end

function AchievementsPlus:IsAchievementAchieved(achid)
    if self.Achievements[achid].count == self.Achievements[achid].goal then
        return true
    else
        return false
    end
end

-- Serialization
function AchievementsPlus:Load()
    local tbl = util.KeyValuesToTable(file.Read("achievementsplus/achievements.txt") or "")
    local achcount = 0

    for k, v in pairs(tbl) do
        self:RegisterAchievement(k, nil, nil, nil, tonumber(v.goal), tonumber(v.count))
        achcount = achcount + 1
    end

    Msg("Loaded " .. tostring(achcount) .. " saved achievements.\n")
end

function AchievementsPlus:Save()
    local tbl = {}
    local achcount = 0

    for k, v in pairs(self.Achievements) do
        tbl[k] = {}
        tbl[k].count = v.count
        tbl[k].goal = v.goal
        achcount = achcount + 1
    end

    Msg("Saved " .. tostring(achcount) .. " achievements.\n")
    file.Write("achievementsplus/achievements.txt", util.TableToKeyValues(tbl))
end

-- achievements
function AchievementsPlus:HookAchievements()
    if not self.OldachievementsCount then
        self.OldachievementsCount = achievements.Count
        self.OldachievementsGetCount = achievements.GetCount
        self.OldachievementsGetDesc = achievements.GetDesc
        self.OldachievementsGetGoal = achievements.GetGoal
        self.OldachievementsGetName = achievements.GetName
        self.OldachievementsIsAchieved = achievements.GetIsAchieved
    end

    self.VAchievementsState = 0

    function achievements.Count()
        return AchievementsPlus:GetAchievementCount()
    end

    function achievements.GetCount(id)
        if not AchievementsPlus.MapIDsToNames[id] then
            Msg("achievements.GetCount (" .. tostring(id) .. "): Achievement ID is invalid.\n")

            return 1
        end

        local goalcount = AchievementsPlus:GetAchievementGoalCount(AchievementsPlus.MapIDsToNames[id])

        if AchievementsPlus.VAchievementsState == 0 then
            AchievementsPlus.VAchievementsState = 1
            if goalcount > 0 then return goalcount end

            return 0.0000000001
        else
            AchievementsPlus.VAchievementsState = 0
        end

        return goalcount
    end

    function achievements.GetDesc(id)
        return AchievementsPlus:GetAchievementDesc(AchievementsPlus.MapIDsToNames[id])
    end

    function achievements.GetGoal(id)
        local goal = AchievementsPlus:GetAchievementGoal(AchievementsPlus.MapIDsToNames[id])

        if AchievementsPlus.VAchievementsState == 1 then
            AchievementsPlus.VAchievementsState = 2

            if AchievementsPlus:GetAchievementGoalCount(AchievementsPlus.MapIDsToNames[id]) > 0 then
                return goal
            else
                return 2
            end
        end

        return goal
    end

    function achievements.GetName(id)
        return AchievementsPlus:GetAchievementName(AchievementsPlus.MapIDsToNames[id])
    end

    function achievements.IsAchieved(id)
        return AchievementsPlus:IsAchievementAchieved(AchievementsPlus.MapIDsToNames[id])
    end
end

function AchievementsPlus:UnhookAchievements()
    achievements.Count = self.OldachievementsCount
    achievements.GetCount = self.OldachievementsGetCount
    achievements.GetDesc = self.OldachievementsGetDesc
    achievements.GetGoal = self.OldachievementsGetGoal
    achievements.GetName = self.OldachievementsGetName
    achievements.IsAchieved = self.OldachievementsIsAchieved
end