AchievementsPlus:RegisterAchievement ("low_fps", "Failure To Render", "Have a low framerate.", "vgui/notices/error")
AchievementsPlus:AddAchievementHook ("low_fps", "Think", function ()
	if 1 / RealFrameTime () < 10 then
		AchievementsPlus:AddAchievementCount ("low_fps")
	end
end)