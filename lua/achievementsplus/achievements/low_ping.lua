AchievementsPlus:RegisterAchievement ("low_ping", "Broadband", "Have an uber low ping.")
AchievementsPlus:AddAchievementHook ("low_ping", "Think", function ()
	if LocalPlayer():Ping () < 10 then
		AchievementsPlus:AddAchievementCount ("low_ping")
	end
end)