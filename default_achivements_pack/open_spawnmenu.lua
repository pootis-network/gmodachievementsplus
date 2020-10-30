AchievementsPlus:RegisterAchievement ("open_spawnmenu", "QQ More", "Discover the spawn menu.", "gui/gmod_logo")
AchievementsPlus:AddAchievementHook ("open_spawnmenu", "SpawnMenuOpen", function ()
	AchievementsPlus:AddAchievementCount ("open_spawnmenu")
end)