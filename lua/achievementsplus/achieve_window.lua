AchievementsPlus.Notifications = {}
AchievementsPlus.Notifications.NotificationQueue = {}

function AchievementsPlus.Notifications:Add(title, text, material)
    table.insert(self.NotificationQueue, {
        title = title,
        text = text,
        material = material
    })
end

function AchievementsPlus.Notifications:Pop()
    table.remove(self.NotificationQueue, next(self.NotificationQueue))
end

AchievementsPlus:AddEventHook("AchievementUnlocked", "AchievementsPlus.Notifications.AchievementUnlocked", function(id)
    AchievementsPlus.Notifications:Add("Achievement Unlocked!", AchievementsPlus:GetAchievementName(id), AchievementsPlus:GetAchievementMaterial(id))
end)

local NOTIFICATIONPANEL = {}

function NOTIFICATIONPANEL:Init()
    self.Notification = nil
    self.LastNotificationTime = 0
    self:SetSize(240, 90)
    self:SetPos(ScrW() - self:GetWide(), ScrH())
    self.Title = vgui.Create("DLabel", self)
    self.Text = vgui.Create("DLabel", self)
    self.Text2 = vgui.Create("DLabel", self)
    self.Icon = vgui.Create("DImage", self)
    self.Title:SetTextColor(Color(255, 255, 255, 255))
    self.Text:SetTextColor(Color(180, 180, 180, 255))
    self.Text2:SetTextColor(Color(180, 180, 180, 255))
    self.Icon:SetKeepAspect(true)
    self.Title:SetFont("DefaultBold")
    self.Text:SetFont("DefaultBold")
    self.Text2:SetFont("DefaultBold")
    self.LaidOut = false
end

function NOTIFICATIONPANEL:PerformLayout()
    self.LaidOut = true
    self.Title:SetPos(88, 20)
    self.Title:SetSize(150, 20)
    self.Text:SetPos(88, 40)
    self.Text:SetSize(140, 20)
    self.Text2:SetPos(88, 52)
    self.Text2:SetSize(140, 20)
    self.Icon:SetPos(14, 14)
    self.Icon:SetSize(64, 64)
end

function NOTIFICATIONPANEL:Paint()
    draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(104, 106, 101, 255))
    draw.RoundedBox(0, 1, 1, self:GetWide() - 2, self:GetTall() - 2, Color(47, 49, 45, 255))

    return true
end

function NOTIFICATIONPANEL:Think()
    if not self.Notification then
        if not self.LaidOut then return end
        self.Notification = next(AchievementsPlus.Notifications.NotificationQueue)

        if self.Notification then
            AchievementsPlus.Notifications:Pop()
            self.LastNotificationTime = RealTime()
            self.Title:SetText(self.Notification.title)
            local lines = {}
            local bits = string.Explode(" ", self.Notification.text)
            local newline = nil
            local wordcount = 0

            for k, v in pairs(bits) do
                local oldline = newline

                if newline then
                    newline = newline .. " " .. v
                else
                    newline = v
                end

                wordcount = wordcount + 1
                local reqw, reqh = surface.GetTextSize(newline)

                if reqw > self.Text:GetWide() and wordcount > 1 then
                    table.insert(lines, oldline)
                    newline = v
                    wordcount = 1
                end
            end

            table.insert(lines, newline)
            self.Text:SetText(lines[1] or "")
            self.Text2:SetText(lines[2] or "")
            self.Icon:SetImage(self.Notification.material)
        end
    end

    local DeltaTime = RealTime() - self.LastNotificationTime

    if DeltaTime > 5 then
        self:SetPos(ScrW() - self:GetWide(), ScrH())
        self.Notification = nil
    else
        if DeltaTime < 1 then
            self:SetPos(ScrW() - self:GetWide(), ScrH() - DeltaTime * self:GetTall())
        elseif DeltaTime < 4 then
            self:SetPos(ScrW() - self:GetWide(), ScrH() - self:GetTall())
        elseif DeltaTime < 5 then
            self:SetPos(ScrW() - self:GetWide(), ScrH() - (5 - DeltaTime) * self:GetTall())
        end
    end
end

AchievementsPlus:AddEventHook("AchievementsPlusLoaded", "AchievementsPlus.Notifications.Load", function()
    vgui.Register("AchievementsPlusNotification", NOTIFICATIONPANEL, "DPanel")
    AchievementsPlus.Notifications.NotificationPanel = vgui.Create("AchievementsPlusNotification")
end)

AchievementsPlus:AddEventHook("AchievementsPlusUnloaded", "AchievementsPlus.Notifications.Unload", function()
    if AchievementsPlus.Notifications.NotificationPanel then
        AchievementsPlus.Notifications.NotificationPanel:Remove()
        AchievementsPlus.Notifications.NotificationPanel = nil
    end
end)