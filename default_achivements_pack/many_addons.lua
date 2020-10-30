AchievementsPlus:RegisterAchievement ("many_addons", "Addon King", "Have over 10 addons.", "gui/gmod_logo")
AchievementsPlus:AddAchievementHook ("many_addons", "AchievementsCheck", function ()
	local addons = file.FindDir ("../../garrysmod/addons/*")
	if #addons > 10 then
		AchievementsPlus:AddAchievementCount ("many_addons")
	end
end)