AchievementsPlus:AddEventHook ("PlayerKilled", "AchievementsPlus.PlayerEvents", function (Message)
	local victim = Message:ReadEntity ()
	if victim:EntIndex () == LocalPlayer ():EntIndex () then
		AchievementsPlus:CallHook ("LocalPlayerKilled")
	end
end)

AchievementsPlus:AddEventHook ("PlayerKilledSelf", "AchievementsPlus.PlayerEvents", function (Message)
	local victim = Message:ReadEntity ()
	if victim:EntIndex () == LocalPlayer ():EntIndex () then
		AchievementsPlus:CallHook ("LocalPlayerKilled")
	end
end)

AchievementsPlus:AddEventHook ("PlayerKilledByPlayer", "AchievementsPlus.PlayerEvents", function (Message)
	local victim = Message:ReadEntity ()
	if victim:EntIndex () == LocalPlayer ():EntIndex () then
		AchievementsPlus:CallHook ("LocalPlayerKilled")
	end
end)