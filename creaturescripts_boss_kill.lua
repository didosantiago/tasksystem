local taskBoss = {
	[1] = "the snapper",
	[3] = "grandpa troll",
	[3] = "hide",
	[4] = "boneless skeleton",
	[5] = "minotaur berserker",
	[6] = "esmeralda",
	[7] = "fleshcrawler",
	[8] = "ribstride",
	[9] = "the bloodweb",
	[10] = "thul",
	[11] = "the old widow",
	[12] = "hemming",
	[12] = "tormentor",
	[14] = "flameborn",
	[15] = "fazzrah",
	[16] = "tromphonyte",
	[17] = "sulphur scuttler",
	[18] = "bruise payne",
	[19] = "the many",
	[20] = "the noxious spawn",
	[21] = "gorgo",
	[22] = "stonecracker",
	[23] = "leviathan",
	[24] = "kerberos",
	[25] = "ethershreck",
	[26] = "paiz the pauperizer",
	[27] = "bretzecutioner",
	[28] = "zanakeph",
	[29] = "tiquandas revenge",
	[30] = "demodras",
	[31] = "necropharus",
	[32] = "the horned fox",
}

local bossKillCount = Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.SnapperCount
local pendingBossKillStorage = Storage.Quest.U8_5.KillingInTheNameOf.PendingBossKill

local deathEvent = CreatureEvent("KillingInTheNameOfBossDeath")
function deathEvent.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local targetName = creature:getName():lower()

	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		for i, bossName in ipairs(taskBoss) do
			if targetName == bossName then
				if player:getStorageValue(bossKillCount + i) < 1 then
					player:setStorageValue(bossKillCount + i, 1)
					player:setStorageValue(pendingBossKillStorage, -1) -- Clear pending boss kill flag
					player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have successfully defeated the boss and cleared your pending task.")
					local currentPoints = player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.Points)
					if currentPoints < 0 then
						currentPoints = 0
					end
					player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.Points, currentPoints + 1) -- Award points after boss kill
					end
				end
			end
		end)
	return true
end

deathEvent:register()

local serverstartup = GlobalEvent("KillingInTheNameOfBossDeathStartup")
function serverstartup.onStartup()
	for _, bossName in pairs(taskBoss) do
		local mType = MonsterType(bossName)
		if not mType then
			logger.error("[KillingInTheNameOfBossDeathStartup] boss with name {} is not a valid MonsterType", bossName)
		else
			mType:registerEvent("KillingInTheNameOfBossDeath")
		end
	end
end
serverstartup:register()