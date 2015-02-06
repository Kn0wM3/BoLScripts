--[[
		Ryze the Dark Mage by Kn0wM3
		Hope you enjoy!
		Please report bugs on the Forum!(http://forum.botoflegends.com/topic/50262-freescriptsxorbsacrmma-ryze-the-dark-mage-released-6022015/)
	
	Features:
		Combo Mode
		Harass Mode/Toggle
		Farming with Spells
		Lane Clear with spells
		Killsteal using Q,W,E,Ignite
		Auto GapCloser W
		Packet Casting of Q,W,E
		Supports all AP Items
		Supports SxOrbWalk,SAC:R,MMA
		AutoUpdate
		Damage Calculations
		
	To Do(SOON):
		SkinHack
		Overall Improvements
		Your Suggestions
	
	Known Bugs:
		None
		
	Changelog
	
		1.0 -Release
		1.01 -Added Scripter Panel
--]]

if myHero.charName ~= "Ryze" then return end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("PCFDEDFIBBG") 

require "SxOrbWalk"
require "VPrediction" 

_G.AUTOUPDATE = true
_G.USESKINHACK = false


local version = "1.01"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Kn0wM3/BoLScripts/blob/master/Ryze the Dark Mage.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Ryze the Dark Mage:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if _G.AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/Kn0wM3/BoLScripts/blob/master/Ryze the Dark Mage.Version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available "..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

local ts
local Qready, Wready, Eready, Rready = false
local Qrange, Wrange, Erange = 625, 600, 325

local KillText = {}
local KillTextColor = ARGB(250, 255, 38, 1)
local KillTextList = {		
						"Harass Him!", 					-- 01
						"Wait for your CD's!",					-- 02
						"Kill! - AA", 							-- 03
						"Kill! - Ignite",						-- 04
						"Kill! - (Q)",							-- 05 
						"Kill! - (W)",							-- 06
						"Kill! - (E)",							-- 07
						"Kill! - (Q)+(W)",						-- 08
						"Kill! - (Q)+(E)",						-- 09
						"Kill! - (W)+(E)",						-- 10
						"Kill! - (Q)+(W)+(E)"					-- 11
					}

local Items = {
	BWC = { id = 3144, range = 400, reqTarget = true, slot = nil },
	HGB = { id = 3146, range = 400, reqTarget = true, slot = nil },
	BFT = { id = 3188, range = 750, reqTarget = true, slot = nil },
}

local GapCloserList = {
	{charName = "Aatrox", spellName = "AatroxQ", name = "Q"},
	{charName = "Akali", spellName = "AkaliShadowDance", name = "R"},
	{charName = "Alistar", spellName = "Headbutt", name = "W"},
	{charName = "Fiora", spellName = "FioraQ", name = "R"},
	{charName = "Diana", spellName = "DianaTeleport", name = "W"},
	{charName = "Elise", spellName = "EliseSpiderQCast", name = "W"},
	{charName = "Fizz", spellName = "FizzPiercingStrike", name = "Q"},
	{charName = "Gragas", spellName = "GragasE", name = "E"},
	{charName = "Hecarim", spellName = "HecarimUlt", name = "R"},
	{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", name = "E"},
	{charName = "Irelia", spellName = "IreliaGatotsu", name = "Q"},
	{charName = "Jax", spellName = "JaxLeapStrike", name = "Q"},
	{charName = "Khazix", spellName = "KhazixE", name = "E"},
	{charName = "Khazix", spellName = "khazixelong", name = "Evolved E"},
	{charName = "LeBlanc", spellName = "LeblancSlide", name = "W"},
	{charName = "LeBlanc", spellName = "LeblancSlideM", name = "UltW"},
	{charName = "LeeSin", spellName = "BlindMonkQTwo", name = "Q"},
	{charName = "Leona", spellName = "LeonaZenithBlade", name = "E"},
	{charName = "Malphite", spellName = "UFSlash", name = "R"},
	{charName = "Pantheon", spellName = "Pantheon_LeapBash", name = "R"},
	{charName = "Poppy", spellName = "PoppyHeroicCharge", name = "W"},
	{charName = "Renekton", spellName = "RenektonSliceAndDice", name = "E"},
	{charName = "Riven", spellName = "RivenTriCleave", name = "E"},
	{charName = "Sejuani", spellName = "SejuaniArcticAssault", name = "E"},
	{charName = "Tryndamere", spellName = "slashCast", name = "E"},
	{charName = "Vi", spellName = "ViQ", name = "Q"},
	{charName = "MonkeyKing", spellName = "MonkeyKingNimbus", name = "Q"},
	{charName = "XinZhao", spellName = "XenZhaoSweep", name = "Q"},
	{charName = "Yasuo", spellName = "YasuoDashWrapper", name = "E"},
}

function OnLoad()
	Menu()
	
	Variables()
	
	killstring = {}
	
	Target = GetCustomTarget()
	SxOrb:ForceTarget(Target)
	
	if myHero:GetSpellData(SUMMONER_1).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_1  
	elseif myHero:GetSpellData(SUMMONER_2).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_2  
	end
end

function OnTick()
	Checks()
	
	if Config.combo.combo then Combo(Target) end
	if Config.harass.harass or Config.harass.harass2 then Harass(Target) end
	if Config.ks.ks then KillSteal() end
	if Config.farm.FarmCS or Config.farm.FarmCS2 and not Config.combo.combo and not Config.harass.harass and not Config.harass.harass2 then LastHitMode() end
	if Config.farm.ClearCS or Config.farm.ClearCS2 and not Config.combo.combo and not Config.harass.harass and not Config.harass.harass2 then LaneClearMode() end
	if Config.misc.zhonyas.zhonyas then Zhonyas() end
	if Config.draw.drawDD and not Config.draw.mdraw then DmgCalc() end
	--if Config.misc.autoLevel then AutoLevel() end
end

function OnDraw()
	if not myHero.dead and not Config.draw.mdraw then
		if Config.draw.drawQ and Qready then
			DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, RGB(Config.draw.qColor[2], Config.draw.qColor[2], Config.draw.qColor[4]))
		end
		if Config.draw.drawW and Wready then
			DrawCircle(myHero.x, myHero.y, myHero.z, Wrange, RGB(Config.draw.wColor[2], Config.draw.wColor[3], Config.draw.wColor[4]))
		end
		if Config.draw.drawE and Eready then
			DrawCircle(myHero.x, myHero.y, myHero.z, Erange, RGB(Config.draw.eColor[2], Config.draw.eColor[3], Config.draw.eColor[4]))
		end
		if Config.draw.drawDD then
			for i = 1, heroManager.iCount do
				local enemy = heroManager:GetHero(i)
				if ValidTarget(enemy) and enemy ~= nil then
					local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
					local PosX = barPos.x - 60
					local PosY = barPos.y - 10
					DrawText(KillTextList[KillText[i]], 20, PosX, PosY, KillTextColor)
				end
			end
		end
	end
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil then
		if Config.combo.useItems then
			UseItems(unit)
		end
		if Config.combo.combomode == 1 then
		if Config.combo.qMenu.useQ and Qready then
			CastQ(unit)
		end
		if Config.combo.rMenu.useR and Rready then
			CastSpell(_R)
		end
		if Config.combo.wMenu.useW and Wready and not Config.combo.wMenu.safeW then
			CastW(unit)
		-- elseif Config.combo.wMenu.useW and Wready and Config.combo.wMenu.safeW then
			-- if isFacing(unit, myHero, Wrange) then
				-- CastW(unit)
			-- end
		end
		if Config.combo.eMenu.useE and Eready then
			CastE(unit)
			end
		end
		if Config.combo.combomode == 2 then
		if Config.combo.wMenu.useW and Wready and not Config.combo.wMenu.safeW then
			CastW(unit)
		-- elseif Config.combo.wMenu.useW and Wready and Config.combo.wMenu.safeW then
			-- if isFacing(unit, myHero, wRange) then
				-- CastW(unit)
			-- end
		end
		if Config.combo.qMenu.useQ and Qready then
			CastQ(unit)
		end
		if Config.combo.rMenu.useR and Rready then
			CastSpell(_R)
		end
		if Config.combo.eMenu.useE and Eready then
			CastE(unit)
			end
		end
	end
end

function Harass(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Config.harass.qMenu.useQ and Qready then
			CastQ(unit)
		end
		if Config.harass.eMenu.useE and Eready then
			CastE(unit)
		end
	end
end

function LastHitMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil then
				if ValidTarget(minion, Qrange) and Config.farm.qMenu.useQ and Qready and getDmg("Q", minion, myHero) >= minion.health and getDmg("AD", minion, myHero) < minion.health then
					CastSpell(_Q, minion)
				end
				if ValidTarget(minion, Erange) and Config.farm.eMenu.useE and Eready and getDmg("E", minion, myHero) >= minion.health then 
					CastSpell(_E, minion)
				end
				if ValidTarget(minion, Wrange) and Config.farm.wMenu.useW and not Config.farm.wMenu.safeW and Wready and getDmg("W", minion, myHero) >= minion.health and getDmg("AD", minion, myHero) < minion.health then 
					CastSpell(_W, minion)
			end
		end
	end
end	

function LaneClearMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil and ValidTarget(minion, Qrange) and Config.farm.qMenu.useQ2 and Qready and getDmg("AD", minion, myHero) < minion.health then
				if getDmg("Q", minion, myHero) >= minion.health then
					CastSpell(_Q, minion)
				elseif getDmg("Q", minion, myHero) < minion.health then
					CastSpell(_Q, minion)
			end	
		end
			if minion ~= nil and ValidTarget(minion, wRange) and Config.farm.rMenu.useR and Rready then
				CastSpell(_R)
			end
			if minion ~= nil and ValidTarget(minion, Erange) and Config.farm.eMenu.useE2 and Eready then
				if getDmg("E", minion, myHero) >= minion.health then
					CastSpell(_E, minion)
				elseif getDmg("E", minion, myHero) < minion.health then
					CastSpell(_E, minion)
			end
		end
			if minion ~= nil and ValidTarget(minion, Wrange) and Config.farm.wMenu.useW2 and not Config.farm.wMenu.safeW and Wready and not getDmg("AD", minion, myHero) >= minion.health then
				if getDmg("W", minion, myHero) >= minion.health then
					CastSpell(_W, minion)
				elseif getDmg("W", minion, myHero) < minion.health then
					CastSpell(_W, minion)
			end
		end
	end
end

function CastQ(unit)
	if unit ~= nil and unit.type == myHero.type and GetDistance(unit) <= Qrange then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = unit.networkID}):send()
		else
		CastSpell(_Q, unit)
		end
	end
end

function CastW(unit)
	if unit ~= nil and unit.type == myHero.type and GetDistance(unit) <= Wrange then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _W, targetNetworkId = unit.networkID}):send()
		else
		CastSpell(_W, unit)
		end
	end
end

function CastE(unit)
	if unit ~= nil and unit.type == myHero.type and GetDistance(unit) <= Erange then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send()
		else
		CastSpell(_E, unit)
		end
	end
end

function KillSteal()
	for _, enemy in ipairs(GetEnemyHeroes()) do	
		local IDMG = (50 + (20 * myHero.level))
		local qDmg = getDmg("Q", enemy, myHero)
		local wDmg = getDmg("W", enemy, myHero)
		local eDmg = getDmg("E", enemy, myHero)
		
		if ValidTarget(enemy, 700) and enemy ~= nil and enemy.team ~= player.team and not enemy.dead and enemy.visible then
			if enemy.health <= qDmg and ValidTarget(enemy, Qrange) and Qready then
				CastQ(enemy)
			elseif enemy.health <= wDmg and ValidTarget(enemy, Wrange) and Wready then
				CastW(enemy)
				
			elseif enemy.health <= eDmg and ValidTarget(enemy, Erange) and Eready then
				CastE(enemy)
			elseif enemy.health <= (qDmg + wDmg) and ValidTarget(enemy, Qrange) and Wready and Qready then
				CastW(enemy)
				CastQ(enemy)
			elseif enemy.health <= (qDmg + eDmg) and ValidTarget(enemy, Qrange) and Eready and Qready then
				CastE(enemy)
				CastQ(enemy)
			elseif enemy.health <= (wDmg + eDmg) and ValidTarget(enemy, Wrange) and Wready and Eready then
				CastW(enemy)
				CastE(enemy)
		end
		if Config.ks.autoIgnite then AutoIgnite(enemy) end
		end
	end
end

function DmgCalc()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
			if ValidTarget(enemy) and enemy ~= nil then
				aaDmg 		= ((getDmg("AD", enemy, myHero)))
				qDmg 		= ((getDmg("Q", enemy, myHero)) or 0)	
				wDmg		= ((getDmg("W", enemy, myHero)) or 0)	
				eDmg		= ((getDmg("E", enemy, myHero)) or 0)	
				iDmg 		= ((ignite and getDmg("IGNITE", enemy, myHero)) or 0)	-- Ignite
	-- Set Kill Text --	
					-- "Kill! - AA" --
					if enemy.health <= aaDmg
						then
							KillText[i] = 3
							end
					-- "Kill! - Ignite" --
					if enemy.health <= iDmg
						then
							 if IREADY then KillText[i] = 4
							 else KillText[i] = 2
							 end
					-- "Kill! - (Q)" --
					elseif enemy.health <= qDmg
						then
							if Qready then KillText[i] = 5
							else KillText[i] = 2
							end
					--	"Kill! - (W)" --
					elseif enemy.health <= wDmg
						then
							if Wready then KillText[i] = 6
							else KillText[i] = 2
							end
					-- "Kill! - (E)" --
					elseif enemy.health <= eDmg
						then
							if Eready then KillText[i] = 7
							else KillText[i] = 2
							end
					-- "Kill! - (Q)+(W)" --
					elseif enemy.health <= (qDmg+wDmg)
						then
							if Qready and Wready then KillText[i] = 8
							else KillText[i] = 2
							end
					-- "Kill! - (Q)+(E)" --
					elseif enemy.health <= (qDmg+eDmg)
						then
							if Qready and Eready then KillText[i] = 9
							else KillText[i] = 2
							end
					-- "Kill! - (W)+(E)" --
					elseif enemy.health <= (wDmg+eDmg)
						then
							if Wready and Eready then KillText[i] = 10
							else KillText[i] = 2
							end
					-- "Kill! - (Q)+(W)+(E)" --
					elseif enemy.health <= (qDmg+wDmg+eDmg)
						then
							if Qready and Wready and Eready then KillText[i] = 11
							else KillText[i] = 2
							end
					-- "Harass your enemy!" -- 
					else KillText[i] = 1				
			end
		end
	end
end

function AutoIgnite(unit)
	if ValidTarget(unit, 600) and unit.health <= 50 + (20 * myHero.level) then
		if Igniteready then
			CastSpell(Ignite.slot, unit)
		end
	end
end

function Zhonyas()
	local zSlot = GetInventorySlotItem(3157)
		if zSlot ~= nil and myHero:CanUseSpell(zSlot) == READY then
			local zrange = Config.misc.zhonyas.zRange
			local zamount = Config.misc.zhonyas.zAmount
			local health = myHero.health
			local maxHealth = myHero.maxHealth
				if ((health/maxHealth)*100) <= Config.misc.zhonyas.zhonyasunder and CountEnemyHeroInRange(zrange) <= zamount then
			CastSpell(zSlot)
		end
	end
end

function Checks()
	Qready = (myHero:CanUseSpell(_Q) == READY)
	Wready = (myHero:CanUseSpell(_W) == READY)
	Eready = (myHero:CanUseSpell(_E) == READY)
	Rready = (myHero:CanUseSpell(_R) == READY)
	
	Ignite = { name = "summonerdot", range = 600, slot = nil }
	Igniteready = (Ignite.slot ~= nil and myHero:CanUseSpell(Ignite.slot) == READY)
	
	TargetSelector:update()
	Target = GetCustomTarget()
	SxOrb:ForceTarget(Target)
	
	if VIP_USER and Config.draw.lfc.lfc then _G.DrawCircle = DrawCircle2 
		else _G.DrawCircle = _G.oldDrawCircle end
end

function Menu()
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2	
	
	VP = VPrediction()
	
	Config = scriptConfig("Ryze the Dark Mage", "Ryze1") 
	Config:addSubMenu("[Ryze the Dark Mage]: Combo Settings", "combo")
		Config.combo:addParam("combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.combo:addParam("combomode", "Combo Mode List", SCRIPT_PARAM_LIST, 1, {"R>Q>W>E", "R>W>Q>E"})
		Config.combo:addParam("useItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addSubMenu("Q Settings", "qMenu")
				Config.combo.qMenu:addParam("useQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addSubMenu("W Settings", "wMenu")
				Config.combo.wMenu:addParam("useW", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addSubMenu("E Settings", "eMenu")
				Config.combo.eMenu:addParam("useE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addSubMenu("R Settings", "rMenu")	
				Config.combo.rMenu:addParam("useR", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("[Ryze the Dark Mage]: Harass Settings", "harass")
		Config.harass:addParam("toggleHarass", "Toggle Harass Mode(requires reload)", SCRIPT_PARAM_ONOFF, false)
			if Config.harass.toggleHarass then
				Config.harass:addParam("harass2", "Harass Toggle Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("V"))
			else
				Config.harass:addParam("harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			end
			Config.harass:addSubMenu("Q Settings", "qMenu")
				Config.harass.qMenu:addParam("useQ", "Use Q to Harass", SCRIPT_PARAM_ONOFF, true)
			Config.harass:addSubMenu("E Settings", "eMenu")
				Config.harass.eMenu:addParam("useE", "Use E to Harass", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("[Ryze the Dark Mage]: Farm Settings", "farm")
		Config.farm:addParam("toggleFarm", "Toggle Farm Mode(requires reload)", SCRIPT_PARAM_ONOFF, false)
			if Config.farm.toggleFarm then
				Config.farm:addParam("FarmCS2", "Farm Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("C"))
			else
				Config.farm:addParam("FarmCS", "Farm Mode", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
			end
		Config.farm:addParam("toggleClear", "Toggle Clear Mode(requires reload)", SCRIPT_PARAM_ONOFF, false)
			if Config.farm.toggleClear then
				Config.farm:addParam("ClearCS2", "Clear Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("V"))
			else
				Config.farm:addParam("ClearCS", "Lane Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
			end
			Config.farm:addSubMenu("Q Settings", "qMenu")
				Config.farm.qMenu:addParam("useQ", "Use Q to LastHit", SCRIPT_PARAM_ONOFF, true)
				Config.farm.qMenu:addParam("useQ2", "Use Q to WaveClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm:addSubMenu("E Settings", "eMenu")
				Config.farm.eMenu:addParam("useE", "Use E to LastHit", SCRIPT_PARAM_ONOFF, false)
				Config.farm.eMenu:addParam("useE2", "Use E to WaveClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm:addSubMenu("W Settings", "wMenu")
				Config.farm.wMenu:addParam("safeW", "Safe W", SCRIPT_PARAM_ONOFF, false)
				Config.farm.wMenu:addParam("useW", "Use W to LastHit", SCRIPT_PARAM_ONOFF, false)
				Config.farm.wMenu:addParam("useW2", "Use W to LaneClear", SCRIPT_PARAM_ONOFF, false)
			Config.farm:addSubMenu("R Settings", "rMenu")
				Config.farm.rMenu:addParam("useR", "Use R to LaneClear", SCRIPT_PARAM_ONOFF, false)
				
	Config:addSubMenu("[Ryze the Dark Mage]: Misc Settings", "misc")
		Config.misc:addSubMenu("GapCloser Spells", "ES2")
			for i, enemy in ipairs(GetEnemyHeroes()) do
				for _, champ in pairs(GapCloserList) do
					if enemy.charName == champ.charName then
						Config.misc.ES2:addParam(champ.spellName, "GapCloser "..champ.charName.." "..champ.name, SCRIPT_PARAM_ONOFF, true)
					end
				end
			end
		Config.misc:addParam("UG", "Auto W on enemy GapCloser (W)", SCRIPT_PARAM_ONOFF, true)
		Config.misc:addParam("usePackets", "Use Packets (VIP Only!)", SCRIPT_PARAM_ONOFF, true)
			Config.misc:addSubMenu("Zhonyas", "zhonyas")
				Config.misc.zhonyas:addParam("zhonyas", "Auto Zhonyas", SCRIPT_PARAM_ONOFF, true)
				Config.misc.zhonyas:addParam("zhonyasunder", "Use Zhonyas under % health", SCRIPT_PARAM_SLICE, 20, 0, 100 , 0)
				Config.misc.zhonyas:addParam("zRange", "Use Zhonyas if x Enemies are in x Range", SCRIPT_PARAM_SLICE, 500, 0, 800, 0)
				Config.misc.zhonyas:addParam("zAmount", "Use Zhonyas if x Enemies are near", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)

	Config:addSubMenu("[Ryze the Dark Mage]: Killsteal Settings", "ks")
		Config.ks:addParam("ks", "Use SmartKS", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("useR", "Use R to KS(Risky!)", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("autoIgnite", "Auto Ignite to KS", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("[Ryze the Dark Mage]: Draw Setttings", "draw")
		Config.draw:addParam("mdraw", "Disable all Drawings", SCRIPT_PARAM_ONOFF, false)
		Config.draw:addParam("drawDD", "Draw Dmg Text", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("qColor", "Draw (Q) Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
		Config.draw:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("wColor", "Draw (W) Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
		Config.draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("eColor", "Draw (E) Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})

		Config.draw:addSubMenu("Lag Free Circles", "lfc")	
			Config.draw.lfc:addParam("lfc", "Lag Free Circles", SCRIPT_PARAM_ONOFF, true)
			Config.draw.lfc:addParam("CL", "Quality", 4, 75, 75, 2000, 0)
			Config.draw.lfc:addParam("Width", "Width", 4, 1, 1, 10, 0)

	Config:addSubMenu("[Ryze the Dark Mage]: Orbwalker", "Orbwalking")
		SxOrb:LoadToMenu(Config.Orbwalking)
		
	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, Wrange, DAMAGE_MAGIC, true)
	TargetSelector.name = "Ryze"
	Config:addTS(TargetSelector)

end

function Variables()
	
	Ignite = { name = "summonerdot", range = 600, slot = nil }
		
	enemyMinions = minionManager(MINION_ENEMY, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
	
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2	
	
	
	if myHero:GetSpellData(SUMMONER_1).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_2
	end

end

function UseItems(unit)
	if unit ~= nil then
		for _, item in pairs(Items) do
			item.slot = GetInventorySlotItem(item.id)
			if item.slot ~= nil then
				if item.reqTarget and GetDistance(unit) < item.range then
					CastSpell(item.slot, unit)
				elseif not item.reqTarget then
					if (GetDistance(unit) - getHitBoxRadius(myHero) - getHitBoxRadius(unit)) < 50 then
						CastSpell(item.slot)
					end
				end
			end
		end
	end
end

function getHitBoxRadius(target)
	return GetDistance(target.minBBox, target.maxBBox)/2
end

function GetCustomTarget()
 	TargetSelector:update() 	
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
	return TargetSelector.target
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
  radius = radius or 300
  quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
  quality = 2 * math.pi / quality
  radius = radius*.92
  
  local points = {}
  for theta = 0, 2 * math.pi + quality, quality do
    local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
    points[#points + 1] = D3DXVECTOR2(c.x, c.y)
  end
  
  DrawLines2(points, width or 1, color or 4294967295)
end

function round(num) 
  if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
  local vPos1 = Vector(x, y, z)
  local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
  local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
  local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
  
  if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
    DrawCircleNextLvl(x, y, z, radius, Config.draw.lfc.Width, color, Config.draw.lfc.CL) 
	end
end

function OnProcessSpell(unit, spell)
	if Config.misc.UG and Wready then
		for _, x in pairs(GapCloserList) do
			if unit and unit.team ~= myHero.team and unit.type == myHero.type and spell then
				if spell.name == x.spellName and Config.misc.ES2[x.spellName] and ValidTarget(unit, Wrange) then
					if spell.target and spell.target.isMe then
						CastW(unit)
					elseif not spell.target then
						local endPos1 = Vector(unit.visionPos) + 300 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
						local endPos2 = Vector(unit.visionPos) + 100 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
						if (GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos1) or GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos2))  then
							CastW(unit)
						end
					end
				end
			end
		end
	end
end
