include ("achievements.lua")
include ("achievementnotifications.lua")
include ("achievementswindow.lua")

concommand.Add ("achievements_reload", function (_, _, _)
	include ("achievementsplus/achievements_init.lua")
end)