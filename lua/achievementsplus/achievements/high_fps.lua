AchievementsPlus:RegisterAchievement ("high_fps", "Fast Renderer", "Have a high framerate.")
AchievementsPlus:AddAchievementHook ("high_fps", "Think", function ()
	if 1 / RealFrameTime () >= 60 then
		AchievementsPlus:AddAchievementCount ("high_fps")
	end
end)