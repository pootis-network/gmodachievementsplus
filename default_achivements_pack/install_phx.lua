AchievementsPlus:RegisterAchievement ("install_phx", "Phoenix Storms", "Install the Phoenix Storms model pack.", "vgui/gmod_tool")
AchievementsPlus:AddAchievementHook ("install_phx", "AchievementsCheck", function ()
	if file.Exists ("../addons/phoenix-storms/info.txt") then
		AchievementsPlus:AddAchievementCount ("install_phx")
	end
end)