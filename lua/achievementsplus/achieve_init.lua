include ("achievements.lua")
include ("achieve_notifications.lua")
include ("achieve_window.lua")

concommand.Add ("achievements_reload", function (_, _, _)
	include ("achievementsplus/achieve_init.lua")
end)