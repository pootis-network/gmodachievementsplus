AchievementsPlus:RegisterAchievement ("many_dupes", "Advanced Advanced Duplicator", "Have over 30 advanced duplicator dupes.", "vgui/gmod_tool")
AchievementsPlus:AddAchievementHook ("many_dupes", "AchievementsCheck", function ()
	local dupes = file.Find ("adv_duplicator/*")
	if #dupes > 10 then
		AchievementsPlus:AddAchievementCount ("many_dupes")
	end
end)