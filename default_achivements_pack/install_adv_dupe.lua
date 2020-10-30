AchievementsPlus:RegisterAchievement ("install_adv_duplicator", "Advanced Duplicator", "Install the Advanced Duplicator stool.", "vgui/gmod_tool")
AchievementsPlus:AddAchievementHook ("install_adv_duplicator", "AchievementsCheck", function ()
	if file.Exists ("../addons/Adv Duplicator/info.txt") then
		AchievementsPlus:AddAchievementCount ("install_adv_duplicator")
	end
end)