AchievementsPlus:RegisterAchievement ("install_wire", "Wiremod", "Install the Wiremod addon.", "vgui/gmod_tool")
AchievementsPlus:AddAchievementHook ("install_wire", "AchievementsCheck", function ()
	if file.Exists ("../addons/wire/info.txt") then
		AchievementsPlus:AddAchievementCount ("install_wire")
	end
end)