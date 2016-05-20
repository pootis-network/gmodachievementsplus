AchievementsPlus:RegisterAchievement ("high_ping", "Clogged Tubes", "Have a high ping.", "vgui/notices/error")
AchievementsPlus:AddAchievementHook ("high_ping", "Think", function ()
	if LocalPlayer():Ping () > 400 then
		AchievementsPlus:AddAchievementCount ("high_ping")
	end
end)