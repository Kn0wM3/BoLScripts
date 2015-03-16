--[[
	Akali Elo Shower by Kn0wM3
	Hope you enjoy! 
	Please report bugs on the forum!(http://forum.botoflegends.com/topic/47828-)
	
	
	Features:
		Combo Mode 
		Harass Mode/Toggle
		Farming with Spells
		Lane Clear with spells
		Killsteal using Q,E,R,Ignite
		Packet Casting of Q,E,R
		Left Click Target Focus
		Auto GapCloser W
		Chase R
		Auto W if x Enemies are in x Range
		Auto W if x % Health, if x Enemies are in x Range
		Supports all AP Items
		Supports SxOrbWalk,SAC:R,MMA
		AutoUpdate
		Damage Calculations
		
	To Do(SOON):
		SkinHack
		Overall Improvements
		
	Known Bugs:
		None
	
	Changelog:
	
		1.0 -Release
		1.01 -Fixed a few Bugs
		1.1 -Fixed Bugs, Improved Killsteal
		1.2 -DmgCalculations(95% Credits go to kokosik1221, I just optimizied it for this Script)
		1.3 -Added AutoW(W if x enemies are in x range, LifeSafe W if x enemies are in x range at x Health)
				-Added PacketCasting of Q,E,R
				-Reworked Combo, Harass, Farm Menu
		1.31 -Fixed Zhonyas Bug
		1.32 -Fixed Zhonyas
				 -Fixed LifeSafe W
				 -Fixed other bugs
		1.4 -Scripter Panel
		1.5 -New DamageCalculations
		    -Auto W GapCloser
		    -Fixed Items
]]

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("REHFFJHDEJH") 

if myHero.charName ~= "Akali" then return end

require "SxOrbWalk"
require "VPrediction"

_G.AUTOUPDATE = true

local version = "1.61"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Kn0wM3/BoLScripts/master/Akali Elo Shower.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Akali Elo Shower:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if _G.AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/Kn0wM3/BoLScripts/master/Akali%20Elo%20Shower.Version")
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
local Qready, Wready, Eready, Rready, mma, sac = false
local Qrange, Erange, Rrange = 600, 325, 700

local KillText = {}
local KillTextColor = ARGB(250, 255, 38, 1)
local KillTextList = {		
						"Harass Him!", 							-- 01
						"Kill! - AA", 							-- 02
						"Kill! - Ignite",						-- 03
						"Kill! - (Q)",							-- 04
						"Kill! - (E)",							-- 05
						"Kill! - (R)",							-- 06
						"Kill! - (Q)+(E)",						-- 07
						"Kill! - (Q)+(R)",						-- 08
						"Kill! - (E)+(R)",						-- 09
						"Kill! - (Q)+(R)+(E)"					-- 10
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
	{charName = "Amumu", spellName = "BandageToss", name = "Q"},
	{charName = "Fiora", spellName = "FioraQ", name = "Q"},
	{charName = "Diana", spellName = "DianaTeleport", name = "W"},
	{charName = "Elise", spellName = "EliseSpiderQCast", name = "W"},
	{charName = "FiddleSticks", spellName = "Crowstorm", name = "R"},
	{charName = "Fizz", spellName = "FizzPiercingStrike", name = "Q"},
	{charName = "Gragas", spellName = "GragasE", name = "E"},
	{charName = "Hecarim", spellName = "HecarimUlt", name = "R"},
	{charName = "JarvanIV", spellName = "JarvanIVDragonStrike", name = "E"},
	{charName = "Irelia", spellName = "IreliaGatotsu", name = "Q"},
	{charName = "Jax", spellName = "JaxLeapStrike", name = "Q"},
	{charName = "Katarina", spellName = "ShadowStep", name = "E"},
	{charName = "Kassadin", spellName = "RiftWalk", name = "R"},
	{charName = "Khazix", spellName = "KhazixE", name = "E"},
	{charName = "Khazix", spellName = "khazixelong", name = "Evolved E"},
	{charName = "LeBlanc", spellName = "LeblancSlide", name = "W"},
	{charName = "LeBlanc", spellName = "LeblancSlideM", name = "UltW"},
	{charName = "LeeSin", spellName = "BlindMonkQTwo", name = "Q"},
	{charName = "Leona", spellName = "LeonaZenithBlade", name = "E"},
	{charName = "Malphite", spellName = "UFSlash", name = "R"},
	{charName = "Nautilus", spellName = "NautilusAnchorDrag", name = "Q"},
	{charName = "Pantheon", spellName = "Pantheon_LeapBash", name = "R"},
	{charName = "Poppy", spellName = "PoppyHeroicCharge", name = "W"},
	{charName = "Renekton", spellName = "RenektonSliceAndDice", name = "E"},
	{charName = "Riven", spellName = "RivenTriCleave", name = "E"},
	{charName = "Sejuani", spellName = "SejuaniArcticAssault", name = "E"},
	{charName = "Shen", spellName = "ShenShadowDash", name = "E"},
	{charName = "Tristana", spellName = "RocketJump", name = "W"},
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
    if Config.skills.qMenu.autoQ then AutoQ() end
    if Config.skills.qMenu.farmQ2 then FarmQ() end
    if Config.skills.wMenu.autoE then AutoE() end
    if Config.skills.wMenu.farmE2 then FarmE() end
	if Config.skills.wMenu.useAutoW and Wready then AutoW() end
	if Config.ks.ks then KillSteal() end
	if Config.farm.FarmCS or Config.farm.FarmCS2 then LastHitMode() end
	if Config.farm.ClearCS or Config.farm.ClearCS2 then LaneClearMode() end
	if Config.misc.zhonyas.zhonyas then Zhonyas() end
	if Config.draw.DD and not Config.draw.mdraw then DmgCalc() end
end

function OnDraw()
	if not myHero.dead and not Config.draw.mdraw then
		if Config.draw.drawQ and Qready then
			DrawCircle(myHero.x, myHero.y, myHero.z, Qrange, RGB(Config.draw.qColor[2], Config.draw.qColor[2], Config.draw.qColor[4]))
		end
		if Config.draw.drawE and Eready then
			DrawCircle(myHero.x, myHero.y, myHero.z, Erange, RGB(Config.draw.eColor[2], Config.draw.eColor[3], Config.draw.eColor[4]))
		end
		if Config.draw.drawR and Rready then
			DrawCircle(myHero.x, myHero.y, myHero.z, Rrange, RGB(Config.draw.rColor[2], Config.draw.rColor[3], Config.draw.rColor[4]))
		end
        if Config.draw.myHero then
            DrawCircle(myHero.x, myHero.y, myHero.z, TrueRange(), RGB(Config.draw.myColor[2], Config.draw.myColor[3], Config.draw.myColor[4]))
        end
        if Config.draw.Target and Target ~= nil then
            DrawCircle(Target.x, Target.y, Target.z, 80, ARGB(255, 10, 255, 10))
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

function CountEnemyHeroInRange(range)
	local enemyInRange = 0
		for i = 1, heroManager.iCount, 1 do
			local hero = heroManager:getHero(i)
				if ValidTarget(hero,range) then
			enemyInRange = enemyInRange + 1
			end
		end
	return enemyInRange
end

function AutoW()
	local wRange = Config.skills.wMenu.wRange
	local amount = Config.skills.wMenu.wCount
	local health = myHero.health
	local maxHealth = myHero.maxHealth
		if CountEnemyHeroInRange(wRange) >= amount then
			CastSpell(_W, myHero.x, myHero.z)
		elseif ((health/maxHealth)*100) <= Config.skills.wMenu.wHealth and CountEnemyHeroInRange(wRange) <= amount then
			CastSpell(_W, myHero.x, myHero.z)
	end
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Config.combo.useItems then
			UseItems(unit)
		end
		if Config.skills.rMenu.useR and Config.skills.rMenu.chaseR and Config.skills.wMenu.useW and Wready and Rready then
			ChaseR(unit)
			CastSpell(_W, myHero.x, myHero.z)
		else 
			ChaseR(unit)
		end
		if Config.skills.rMenu.useR and Config.skills.wMenu.useW and Wready and Rready then
			CastR(unit)
			CastSpell(_W, myHero.x, myHero.z)
		else 
			CastR(unit)
		end
		if Config.skills.qMenu.useQ then
			CastQ(unit)
		end
		if Config.skills.eMenu.useE then
			CastE(unit)
		end
	end
end

function Harass(unit)
	if ValidTarget(unit) and unit ~= nil and unit.type == myHero.type then
		if Config.skills.qMenu.useQ then 
		CastQ(unit)
		end
		if Config.skills.eMenu.useE then
		CastE(unit)
		end
	end
end

function LastHitMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil then
				if ValidTarget(minion, Qrange) and Config.skills.qMenu.useQ and Qready and not GetDistance(minion) <= Erange and not Eready and getDmg("Q", minion, myHero) >= minion.health then
					CastSpell(_Q, minion)
				end
				if ValidTarget(minion, Erange) and Config.skills.eMenu.useE and Eready and getDmg("E", minion, myHero) >= minion.health then 
					CastSpell(_E, minion)
			end
		end
	end
end

function LaneClearMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil and ValidTarget(minion, Qrange) then
				if Qready and Config.skills.qMenu.useQ2 then
					if getDmg("Q", minion, myHero) >= minion.health then
						CastSpell(_Q, minion)
					else CastSpell(_Q, minion)
					end
				end
				if ValidTarget(minion, Erange) and Eready and Config.skills.eMenu.useE2 then
					if getDmg("E", minion, myHero) >= minion.health then
						then CastSpell(E, minion)
					else CastSpell(_E, minion)
				end
			end
		end
	end
end

function CastQ(unit)
	if unit ~= nil and unit.type == myHero.type and GetDistance(unit) <= Qrange and Qready then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _Q, targetNetworkId = unit.networkID}):send()
		else
			CastSpell(_Q, unit)
		end
	end
end

function AutoQ()
    for _, enemy in ipairs(GetEnemyHeroes()) do 
        if enemy ~= nil and ValidTarget(enemy, Qrange) then
            if GetDistance(enemy) <= Qrange and Qready then
                if VIP_USER and Config.misc.usePackets then
                    Packet("S_CAST", {spellId = _Q, targetNetworkId = enemy.networkID}):send()
                else
                    CastSpell(_Q, enemy)
                end
            end
        end
    end
end

function FarmQ()
    enemyMinions:update()
    for i, minion in pairs(enemyMinions.objects) do
        if minion ~= nil then
            if ValidTarget(minion, Qrange) and Qready and getDmg("Q", minion, myHero) >= minion.health then
                CastSpell(_Q, minion)
            end
        end
    end
end

function CastE(unit)
	if unit ~= nil and unit.type == myHero.type and GetDistance(unit) <= Erange and Eready then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send() 
		else
			CastSpell(_E, unit)
		end
	end
end

function AutoE()
	for _, enemy in ipairs(GetEnemyHeroes()) do 
        if enemy ~= nil and ValidTarget(enemy, Erange) then
            if GetDistance(enemy) <= Erange and Eready then
                if VIP_USER and Config.misc.usePackets then
                    Packet("S_CAST", {spellId = _E}):send()
                else
                    CastSpell(_E)
                end
            end
        end
    end
end

function FarmE()
    enemyMinions:update()
    for i, minion in pairs(enemyMinions.objects) do
        if minion ~= nil then
            if ValidTarget(minion, Erange) and Eready and getDmg("E", minion, myHero) >= minion.health then 
                CastSpell(_E)
            end
        end
    end
end

function CastR(unit)
	if unit ~= nil and unit.type == myHero.type and GetDistance(unit) <= Rrange and Rready then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _R, targetNetworkId = unit.networkID}):send() 
		else
			CastSpell(_R, unit)
		end
	end
end

function ChaseR(unit)
	if unit ~= nil and unit.type == myHero.type and GetDistance(unit) <= Config.skills.rMenu.chaseRange and Rready then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _R, targetNetworkId = unit.networkID}):send() 
		else
			CastSpell(_R, unit)
		end
	end
end

function KillSteal()
	for _, enemy in ipairs(GetEnemyHeroes()) do	
			local IDMG = (50 + (20 * myHero.level))
			local qDmg = getDmg("Q", enemy, myHero)
			local eDmg = getDmg("E", enemy, myHero)
			local rDmg = getDmg("R", enemy, myHero)
			local dfgslot = GetInventorySlotItem(3128)
			local dfgready = (DFGSlot ~= nil and myHero:CanUseSpell(DFGSlot) == READY)
		if enemy ~= nil and ValidTarget(enemy, Rrange) then
			if enemy.health <= qDmg and ValidTarget(enemy, Qrange) and Qready then
				CastQ(enemy)
			elseif enemy.health <= (qDmg + eDmg) and ValidTarget(enemy, Erange) and Qready and Eready then
				CastQ(enemy)
				CastE(enemy)
			elseif enemy.health <= (qDmg + rDmg) and ValidTarget(enemy, Rrange) and Qready and Rready and Config.ks.useR then
				CastR(enemy)
				CastQ(enemy)
			elseif enemy.health <= (qDmg + IDMG) and ValidTarget(enemy, Qrange) and Qready and Igniteready then
				CastQ(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= eDmg and ValidTarget(enemy, Erange) and Eready then
				CastE(enemy)
			elseif enemy.health <= (eDmg + rDmg) and ValidTarget(enemy, Rrange) and Rready and Eready and Config.ks.useR then
				CastR(enemy)
				CastE(enemy)
			elseif enemy.health <= (eDmg + IDMG) and ValidTarget(enemy, Erange) and Eready and Igniteready then
				CastE(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= rDmg and ValidTarget(enemy, Rrange) and Rready and Config.ks.useR then
				CastR(enemy)
			elseif enemy.health <= (rDmg + IDMG) and ValidTarget(enemy, Rrange) and Rready and Igniteready and Config.ks.useR then
				CastR(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (qDmg + eDmg + rDmg + IDMG) and ValidTarget(enemy, Rrange) and Qready and Eready and Rready and Config.ks.useR then
				CastR(enemy)
				CastQ(enemy)
				CastE(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (qDmg + eDmg + rDmg) and ValidTarget(enemy, Rrange) and Qready and Eready and Rready and Config.ks.useR then
				CastR(enemy)
				CastE(enemy)
				CastQ(enemy)
			end
			if Config.ks.autoignite then AutoIgnite(enemy) end
		end
	end
end

function DmgCalc()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
			if ValidTarget(enemy) and enemy ~= nil then
				aaDmg 		= ((getDmg("AD", enemy, myHero)))
				qDmg 		= ((getDmg("Q", enemy, myHero)) or 0)	
				rDmg		= ((getDmg("R", enemy, myHero)) or 0)	
				eDmg		= ((getDmg("E", enemy, myHero)) or 0)	
				iDmg 		= ((ignite and getDmg("IGNITE", enemy, myHero)) or 0)
	-- Set Kill Text --	
					-- "Kill! - AA" --
					if enemy.health <= aaDmg
						then
							KillText[i] = 2
							
					-- "Kill! - Ignite" --
					if enemy.health <= iDmg
						then
							 KillText[i] = 3
							 
					-- "Kill! - (Q)" --
					elseif enemy.health <= qDmg
						then
							KillText[i] = 4
							
					-- "Kill! - (E)" --
					elseif enemy.health <= eDmg
						then
							KillText[i] = 5
							
					-- "Kill! - (R)" --
					elseif enemy.health <= rDmg
						then
							KillText[i] = 6
							
					-- "Kill! - (Q)+(E)" --
					elseif enemy.health <= (qDmg+eDmg)
						then
							KillText[i] = 7
							
					-- "Kill! - (Q)+(R)" --
					elseif enemy.health <= (qDmg+rDmg)
						then
							KillText[i] = 8
							
					-- "Kill! - (R)+(E)" --
					elseif enemy.health <= (rDmg+eDmg)
						then
							KillText[i] = 9
							
					-- "Kill! - (Q)+(R)+(E)" --
					elseif enemy.health <= (qDmg+rDmg+eDmg)
						then
							KillText[i] = 10
							
					-- "Harass your enemy!" -- 
					else KillText[i] = 1
				end
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
	
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, Rrange) then
		Target = SelectedTarget
	else
		Target = GetCustomTarget()
	end
	TargetSelector:update()
	SxOrb:ForceTarget(Target)
	
	if sac or mma then
		SxOrb.SxOrbMenu.General.Enabled = false
	end
	
	if Config.draw.lfc.lfc then _
		G.DrawCircle = DrawCircle2 
	else 
		_G.DrawCircle = _G.oldDrawCircle 
	end
end

function Menu()
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2	
	
	VP = VPrediction()
	
	Config = scriptConfig("Akali Elo Shower", "Akali1") 
	Config:addSubMenu("[Akali Elo Shower]: Combo Settings", "combo")
		Config.combo:addParam("combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.combo:addParam("focus", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("combomode", "Combo Mode List", SCRIPT_PARAM_LIST, 1, {"RQWE", "QRWE"})
		Config.combo:addParam("useItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("[Akali Elo Shower]: Harass Settings", "harass")
		Config.harass:addParam("harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		Config.harass:addParam("harass2", "Harass Toggle Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("U"))
	
	Config:addSubMenu("[Akali Elo Shower]: Farm Settings", "farm")
		Config.farm:addParam("toggleFarm", "Toggle Farm Mode(requires reload)", SCRIPT_PARAM_ONOFF, false)
				Config.farm:addParam("FarmCS2", "Farm Mode", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("C"))
				Config.farm:addParam("FarmCS", "Toggle Farm Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("C"))
				Config.farm:addParam("ClearCS2", "Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, GetKey("V"))
				Config.farm:addParam("ClearCS", "Toggle Lane Clear Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, GetKey("V"))

	Config:addSubMenu("[Akali Elo Shower]: Skill Settings", "skills")
		Config.skills:addSubMenu("Q Settings", "qMenu")
			Config.skills.qMenu:addParam("useQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.skills.qMenu:addParam("useQ2", "Use Q to Harass", SCRIPT_PARAM_ONOFF, false)
			Config.skills.qMenu:addParam("autoQ", "Use Q to Auto Harass", SCRIPT_PARAM_ONOFF, false)
			Config.skills.qMenu:addParam("farmQ", "Use Q to LastHit", SCRIPT_PARAM_ONOFF, true)
			Config.skills.qMenu:addParam("farmQ2", "Use Q to Auto LastHit", SCRIPT_PARAM_ONOFF, false)
			Config.skills.qMenu:addParam("clearQ", "Use Q to LaneClear", SCRIPT_PARAM_ONOFF, true)
		Config.skills:addSubMenu("W Settings", "wMenu")
			Config.skills.wMenu:addParam("useW", "Use W after ULT", SCRIPT_PARAM_ONOFF, true)
			Config.skills.wMenu:addParam("useAutoW", "Use Auto W", SCRIPT_PARAM_ONOFF, false)
			Config.skills.wMenu:addParam("wCount", "Auto W if x Enemies are near", SCRIPT_PARAM_SLICE, 2, 0, 5 ,0) 
			Config.skills.wMenu:addParam("wRange", "Auto W Range", SCRIPT_PARAM_SLICE, 300, 0, 1200, 0)
			Config.skills.wMenu:addParam("wHealth", "Auto W if Health is under %", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
			Config.skills.wMenu:addParam("wCount2", "Auto LifeSafe W if x Enemies are near", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
		Config.skills:addSubMenu("E Settings", "eMenu")
			Config.skills.eMenu:addParam("useE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.skills.eMenu:addParam("useE2", "Use E to Harass", SCRIPT_PARAM_ONOFF, true)
			Config.skills.eMenu:addParam("autoE", "Use E to Auto Harass", SCRIPT_PARAM_ONOFF, true)
			Config.skills.eMenu:addParam("farmE", "Use E to LastHit", SCRIPT_PARAM_ONOFF, true)
			Config.skills.eMenu:addParam("farmE2", "Use E to Auto LastHit", SCRIPT_PARAM_ONOFF, false)
			Config.skills.eMenu:addParam("clearE", "Use E to LaneClear", SCRIPT_PARAM_ONOFF, true)
		Config.skills:addSubMenu("R Settings", "rMenu")
			Config.skills.rMenu:addParam("useR", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.skills.rMenu:addParam("chaseR", "Use R to Chase", SCRIPT_PARAM_ONOFF, false)
			Config.skills.rMenu:addParam("chaseRange", "Ult Chase Range", SCRIPT_PARAM_SLICE, 350, 0, 700, 0)
	
	Config:addSubMenu("[Akali Elo Shower]: Misc Settings", "misc")
		Config.misc:addSubMenu("GapCloser Spells", "ES2")
			for i, enemy in ipairs(GetEnemyHeroes()) do
				for _, champ in pairs(GapCloserList) do
					if enemy.charName == champ.charName then
						Config.misc.ES2:addParam(champ.spellName, "GapCloser "..champ.charName.." "..champ.name, SCRIPT_PARAM_ONOFF, true)
					end
				end
			end
		Config.misc:addParam("UG", "Auto W on enemy GapCloser (W)", SCRIPT_PARAM_ONOFF, true)
		if VIP_USER then
		Config.misc:addParam("usePackets", "Use Packets (VIP Only!)", SCRIPT_PARAM_ONOFF, true)
		end
			Config.misc:addSubMenu("Zhonyas", "zhonyas")
				Config.misc.zhonyas:addParam("zhonyas", "Auto Zhonyas", SCRIPT_PARAM_ONOFF, true)
				Config.misc.zhonyas:addParam("zhonyasunder", "Use Zhonyas under % health", SCRIPT_PARAM_SLICE, 20, 0, 100 , 0)
				Config.misc.zhonyas:addParam("zRange", "Use Zhonyas if x Enemies are in x Range", SCRIPT_PARAM_SLICE, 500, 0, 800, 0)
				Config.misc.zhonyas:addParam("zAmount", "Use Zhonyas if x Enemies are near", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)

	Config:addSubMenu("[Akali Elo Shower]: Killsteal Settings", "ks")
		Config.ks:addParam("ks", "Use SmartKS", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("useR", "Use R to KS(Risky!)", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("autoignite", "Auto Ignite to KS", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("[Akali Elo Shower]: Draw Setttings", "draw")
		Config.draw:addParam("mdraw", "Disable all Drawings", SCRIPT_PARAM_ONOFF, false)
		Config.draw:addParam("DD", "Draw Dmg Text", SCRIPT_PARAM_ONOFF, true)
        Config.draw:addParam("Target", "Draw Circle around Target", SCRIPT_PARAM_ONOFF, true)
        Config.draw:addParam("myHero", "Draw AA Range", SCRIPT_PARAM_ONOFF, false)
        Config.draw:addParam("myColor", "AA Range Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
		Config.draw:addParam("drawQ", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("qColor", "Draw (Q) Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
		Config.draw:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("eColor", "Draw (E) Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
		Config.draw:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("rColor", "Draw (R) Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
		Config.draw:addSubMenu("Lag Free Circles", "lfc")	
			Config.draw.lfc:addParam("lfc", "Lag Free Circles", SCRIPT_PARAM_ONOFF, true)
			Config.draw.lfc:addParam("CL", "Quality", 4, 75, 75, 2000, 0)
			Config.draw.lfc:addParam("Width", "Width", 4, 1, 1, 10, 0)
	Config:addSubMenu("[Akali Elo Shower]: Orbwalker", "Orbwalking")
		SxOrb:LoadToMenu(Config.Orbwalking)
		
	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, Rrange, DAMAGE_MAGIC, true)
	TargetSelector.name = "Akali"
	Config:addTS(TargetSelector)
	
	if _G.MMA_Loaded then
		print("<b><font color=\"#FF0000\">Akali Elo Shower:</font></b> <font color=\"#FFFFFF\">MMA Support Loaded.</font>")
		mma = true
	end	
	if _G.AutoCarry then
		print("<b><font color=\"#FF0000\">Akali Elo Shower:</font></b> <font color=\"#FFFFFF\">SAC Support Loaded.</font>")
		sac = true
	end

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

function TrueRange()
    return myHero.range + GetDistance(myHero, myHero.minBBox)
end

function GetCustomTarget()
 	TargetSelector:update() 	
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
	return TargetSelector.target
end

function OnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN and Config.combo.focus then
		local dist = 0
		local Selecttarget = nil
		for i, enemy in ipairs(GetEnemyHeroes()) do
			if ValidTarget(enemy) then
				if GetDistance(enemy, mousePos) <= dist or Selecttarget == nil then
					dist = GetDistance(enemy, mousePos)
					Selecttarget = enemy
				end
			end
		end
		if Selecttarget and dist < 300 then
			if SelectedTarget and Selecttarget.charName == SelectedTarget.charName then
				SelectedTarget = nil
				if Config.combo.focus then 
					print("Target unselected: "..Selecttarget.charName) 
				end
			else
				SelectedTarget = Selecttarget
				if Config.combo.focus then 
					print("New target selected: "..Selecttarget.charName) 
				end
			end
		end
	end
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
						CastSpell(_W, myHero.x, myHero.z)
					elseif not spell.target then
						local endPos1 = Vector(unit.visionPos) + 300 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
						local endPos2 = Vector(unit.visionPos) + 100 * (Vector(spell.endPos) - Vector(unit.visionPos)):normalized()
						if (GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos1) or GetDistanceSqr(myHero.visionPos, unit.visionPos) > GetDistanceSqr(myHero.visionPos, endPos2))  then
							CastSpell(_W, myHero.x, myHero.z)
						end
					end
				end
			end
		end
	end
end
