AchievementsPlus:RegisterAchievement ("discover_noclip", "Discover Noclip", "Learn to noclip.", "gui/gmod_logo")
AchievementsPlus:AddAchievementHook ("discover_noclip", "Think", function ()
	if LocalPlayer():GetMoveType () == MOVETYPE_NOCLIP then
		AchievementsPlus:AddAchievementCount ("discover_noclip")
	end
end)