AchievementsPlus:RegisterAchievement ("die_1000", "Kilodeath", "Die 1000 times.", "", 1000)
AchievementsPlus:AddAchievementHook ("die_1000", "LocalPlayerKilled", function (Message)
	AchievementsPlus:AddAchievementCount ("die_1000")
end)