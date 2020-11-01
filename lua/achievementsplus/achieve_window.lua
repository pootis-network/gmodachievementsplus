local ACHIEVEMENTSPANEL = {}

function ACHIEVEMENTSPANEL:Init()
    self:SetTitle("Achievements")
    self:SetSize(ScrW() * 0.75, ScrH() * 0.75)
    self:SetPos((ScrW() - self:GetWide()) / 2, (ScrH() - self:GetTall()) / 2)
    self:SetSizable(true)
    self:MakePopup()
    self:SetVisible(false)
end

AchievementsPlus:AddEventHook("AchievementsPlusLoaded", "AchievementsWindow.Create", function()
    vgui.Register("AchievementsPlusWindow", ACHIEVEMENTSPANEL, "DFrame")
    AchievementsPlus:HookAchievements()
    AchievementsPlus.AchievementsPanel = vgui.Create("Achievements") -- vgui.Create ("AchievementsPlusWindow")
    AchievementsPlus:UnhookAchievements()
    AchievementsPlus.AchievementsPanel:SetVisible(false)
    AchievementsPlus.AchievementsPanel:SetDeleteOnClose(false)
    AchievementsPlus.AchievementsPanel:SetSize(500, 600)
    AchievementsPlus.AchievementsPanel:Center()
    AchievementsPlus.AchievementsPanel:MakePopup()

    function AchievementsPlus.AchievementsPanel:DestroyControls()
        self.PanelList:Remove()
        self.ProgressPanel:Remove()
        self.TotalProgress:Remove()
        self.ProgressLabel:Remove()
        self.PanelList = nil
        self.ProgressPanel = nil
        self.TotalProgress = nil
        self.ProgressLabel = nil
    end

    AchievementsPlus.AchievementsPanel.OldCreateControls = AchievementsPlus.AchievementsPanel.CreateControls

    function AchievementsPlus.AchievementsPanel:CreateControls()
        self:OldCreateControls()
        local items = self.PanelList:GetItems()

        for k = 0, #items - 1 do
            local v = items[k + 1]
            v.Icon:Remove()
            v.Icon = nil
            v.Icon = vgui.Create("DImage", v)
            v.Icon:SetBGColor(Color(255, 0, 0, 255))
            v.Icon:SetPos(5, 5)
            v.Icon:SetSize(64, 64)
            local material = AchievementsPlus:GetAchievementMaterial(AchievementsPlus.MapIDsToNames[k])

            if not material or string.len(material) == 0 then
                material = ""
            end

            v.Icon:SetKeepAspect(true)
            v.Icon:SetImage(material)

            function v.Icon:SetAchievement(id)
            end
        end
    end
end)

AchievementsPlus:AddEventHook("AchievementsPlusUnloaded", "AchievementsWindow.Destroy", function()
    if AchievementsPlus.AchievementsPanel ~= nil then
        AchievementsPlus.AchievementsPanel:Remove()
        AchievementsPlus.AchievementsPanel = nil
    end
end)

AchievementsPlus:AddEventHook("AchievementProgress", "AchievementsWindow.Update", function()
    local fTotal = 0
    local fAttained = 0

    for k, v in pairs(AchievementsPlus.Achievements) do
        fTotal = fTotal + 1
        fAttained = fAttained + v.count / v.goal
    end

    AchievementsPlus.AchievementsPanel.TotalProgress:SetMax(fTotal)
    AchievementsPlus.AchievementsPanel.TotalProgress:SetValue(fAttained)
    AchievementsPlus.AchievementsPanel.ProgressLabel:SetText(Format("You have unlocked %i out of %i achievements!", fAttained, fTotal))
    AchievementsPlus:HookAchievements()
    local items = AchievementsPlus.AchievementsPanel.PanelList:GetItems()

    for k = 0, #items - 1 do
        local v = items[k + 1]
        achievements.GetCount(k)
        achievements.GetGoal(k)

        if achievements.IsAchieved(k) then
            v.m_bDull = false
        else
            v.m_bDull = true
        end

        v:SetNumber(k)
        v:PerformLayout()
    end

    AchievementsPlus:UnhookAchievements()
    AchievementsPlus.AchievementsPanel.PanelList:Rebuild()
end)

concommand.Add("achievements_show", function()
    AchievementsPlus:HookAchievements()
    AchievementsPlus.AchievementsPanel:DestroyControls()
    AchievementsPlus.AchievementsPanel:CreateControls()
    AchievementsPlus:UnhookAchievements()
    AchievementsPlus.AchievementsPanel:PerformLayout()
    AchievementsPlus.AchievementsPanel:SetVisible(true)
end)

concommand.Add("achievements_reset", function()
    for k, v in pairs(AchievementsPlus.Achievements) do
        v.count = 0
    end

    AchievementsPlus:CallHook("AchievementsCheck")
end)

function AchievementsPlus.AchievementsPlusPanel(Panel)
    Panel:ClearControls()

    Panel:AddControl("Label", {
        Text = "Achievements Plus - !cake"
    })

    Panel:AddControl("Button", {
        Text = "Show Achievements",
        Label = "Open Achievements List",
        Command = "achievements_show"
    })

    Panel:AddControl("Button", {
        Text = "Reset Achievements",
        Label = "Reset All Achievements",
        Command = "achievements_reset"
    })
end

hook.Add("SpawnMenuOpen", "AchievementsPlus.SpawnMenuOpen", function()
    AchievementsPlus.AchievementsPlusPanel(GetControlPanel("AchievementsPlus"))
end)

hook.Add("PopulateToolMenu", "AchievementsPlus.PopulateToolMenu", function()
    spawnmenu.AddToolMenuOption("Utilities", "Achievements", "Achievements", "Achievements", "", "", AchievementsPlus.AchievementsPlusPanel)
end)