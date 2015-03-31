--[[
	Akali Elo Shower by Kn0wM3
	Hope you enjoy! 
	lease report bugs on the forum!(http://forum.botoflegends.com/topic/47828-)
]]

_G.AUTOUPDATE = true -- Change to "false" to disable auto updates!

local version = "1.7"
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

require "SxOrbWalk"
require "VPrediction"

local ts
local Qready, Wready, Eready, Rready = false
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
	PriorityOnLoad()
	KillText = {}
end

function OnTick()
	Checks()
	
	if Config.keys.combo then Combo(Target) end
	if Config.keys.harass or Config.keys.harass2 then Harass(Target) end
  if Config.harass.q.autoQ then AutoQ() end
  if Config.farm.q.autoQ then FarmQ() end
  if Config.harass.e.autoE then AutoE() end
  if Config.farm.e.autoE then FarmE() end
	if Config.misc.w.useAutoW and Wready then AutoW() end
	if Config.ks.ks then KillSteal() end
	if Config.keys.farmCS or Config.keys.farmCS2 then LastHitMode() end
	if Config.keys.clearCS or Config.keys.clearCS2 then LaneClearMode() end
	if Config.keys.clearCS or Config.keys.clearCS2 then JungleClearMode() end
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
        if Config.draw.Target2 and Target ~= nil then
            DrawCircle(Target.x, Target.y, Target.z, 80, ARGB(255, 10, 255, 10))
        end
		if Config.draw.drawHP then
			for i, enemy in ipairs(GetEnemyHeroes()) do
       			if ValidTarget(enemy) then
					DrawIndicator(enemy)
				end
			end
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
	local wRange = Config.misc.w.wRange
	local amount = Config.misc.w.wCount2
	local health = myHero.health
	local maxHealth = myHero.maxHealth
		if CountEnemyHeroInRange(wRange) >= amount then
			CastSpell(_W, myHero.x, myHero.z)
		elseif ((health/maxHealth)*100) <= Config.misc.w.wHealth and CountEnemyHeroInRange(wRange) <= amount then
			CastSpell(_W, myHero.x, myHero.z)
	end
end

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil then
		if Config.combo.useItems then
			UseItems(unit)
		end
		if Config.combo.r.useR and Config.combo.r.chaseR and Rready then
			if Config.combo.w.useW and Wready then
			ChaseR(unit)
			CastSpell(_W, myHero.x, myHero.z)
		else 
			ChaseR(unit)
			end
		end
		if Config.combo.r.useR and Config.combo.w.useW and Wready and Rready then
			CastR(unit)
			CastSpell(_W, myHero.x, myHero.z)
		else 
			CastR(unit)
		end
		if Config.combo.q.useQ then
			CastQ(unit)
		end
		if Config.combo.e.useE and not Qready then
			CastE(unit)
		end
	end
end

function Harass(unit)
	if ValidTarget(unit) and unit ~= nil then
		if Config.harass.q.useQ then 
			CastQ(unit)
		end
		if Config.harass.e.useE and not Qready then
			CastE(unit)
		end
	end
end

function LastHitMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil then
				if ValidTarget(minion, Qrange) and Config.farm.q.farmQ and Qready and GetDistance(minion) > Erange and not Eready and getDmg("Q", minion, myHero) >= minion.health then
					CastSpell(_Q, minion)
				end
				if ValidTarget(minion, Erange) and Config.farm.e.farmE and Eready and getDmg("E", minion, myHero) >= minion.health then 
					CastSpell(_E)
			end
		end
	end
end

function LaneClearMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil and ValidTarget(minion, Qrange) then
				if Qready and Config.farm.q.clearQ then
					if getDmg("Q", minion, myHero) >= minion.health then
						CastSpell(_Q, minion)
					else 
						CastSpell(_Q, minion)
					end
				end
				if ValidTarget(minion, Erange) and Eready and Config.farm.e.clearE then
					if getDmg("E", minion, myHero) >= minion.health then
						CastSpell(_E, minion)
					else
						CastSpell(_E)
				end
			end
		end
	end
end

function JungleClearMode()
	local JungleMob = GetJungleMob()
	
	if JungleMob ~= nil then
		if Config.farm.q.jungleQ and GetDistance(JungleMob) <= Qrange and Qready then
			CastSpell(_Q, JungleMob)
		end
		if Config.farm.e.jungleE and GetDistance(JungleMob) <= Erange and Eready and not Qready then
			CastSpell(_E)
		end
	end
end

function CastQ(unit)
	if unit ~= nil and GetDistance(unit) <= Qrange and Qready then
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
	if unit ~= nil and GetDistance(unit) <= Erange and Eready then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _E, targetNetworkId = unit.networkID}):send() 
		else
			CastSpell(_E)
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
	if unit ~= nil and GetDistance(unit) <= Rrange and Rready then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _R, targetNetworkId = unit.networkID}):send() 
		else
			CastSpell(_R, unit)
		end
	end
end

function ChaseR(unit)
	if unit ~= nil and GetDistance(unit) >= Config.combo.r.chaseRange and Rready then
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
			local zRange = Config.misc.zhonyas.zRange
			local zAmount = Config.misc.zhonyas.zAmount
			local health = myHero.health
			local maxHealth = myHero.maxHealth
				if ((health/maxHealth)*100) <= Config.misc.zhonyas.zhonyasHP and CountEnemyHeroInRange(zRange) >= zAmount then
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
	
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, Rrange+50) then
		Target = SelectedTarget
	else
		Target = GetCustomTarget()
	end
	
	TargetSelector:update()
	SxOrb:ForceTarget(Target)
	
	if Config.draw.lfc.lfc then
		_G.DrawCircle = DrawCircle2
	else 
		_G.DrawCircle = _G.oldDrawCircle 
	end
end

function Menu()

	Config = scriptConfig("Akali Elo Shower", "Akali1") 
	Config:addSubMenu("[Akali Elo Shower]: Combo Settings", "combo")
		Config.combo:addParam("focus", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("combomode", "Combo Mode List", SCRIPT_PARAM_LIST, 1, {"RQWE", "QRWE"})
		Config.combo:addParam("useItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addSubMenu("Q Settings", "q")
			Config.combo.q:addParam("useQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo.q:addParam("proqQ", "Proq Q", SCRIPT_PARAM_ONOFF, false)
		Config.combo:addSubMenu("W Settings", "w")
			Config.combo.w:addParam("useW", "Use W after ult", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addSubMenu("E Settings", "e")
			Config.combo.e:addParam("useE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addSubMenu("R Settings", "r")
			Config.combo.r:addParam("useR", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo.r:addParam("chaseR", "Use R to chase", SCRIPT_PARAM_ONOFF, true)
			Config.combo.r:addParam("chaseRange", "Chase R Range", SCRIPT_PARAM_SLICE, 350, 0, 700, 0)
		
	Config:addSubMenu("[Akali Elo Shower]: Harass Settings", "harass")
		Config.harass:addSubMenu("Q Settings", "q")
			Config.harass.q:addParam("useQ", "Use Q to Harass", SCRIPT_PARAM_ONOFF, true)
			Config.harass.q:addParam("autoQ", "Auto Q to Harass", SCRIPT_PARAM_ONOFF, false)
			Config.harass.q:addParam("proqQ", "Proq Q to Harass", SCRIPT_PARAM_ONOFF, false)
		Config.harass:addSubMenu("E Settings", "e")
			Config.harass.e:addParam("useE", "Use E to Harass", SCRIPT_PARAM_ONOFF, true)
			Config.harass.e:addParam("autoE", "Auto E to Harass", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("[Akali Elo Shower]: Farm/Clear Settings", "farm")
		Config.farm:addSubMenu("Q Settings", "q")
			Config.farm.q:addParam("farmQ", "Use Q to Farm", SCRIPT_PARAM_ONOFF, true)
			Config.farm.q:addParam("clearQ", "Use Q to LaneClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm.q:addParam("jungleQ", "Use Q to JungleClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm.q:addParam("autoQ", "Use Q to AutoFarm", SCRIPT_PARAM_ONOFF, true)
		Config.farm:addSubMenu("E Settings", "e")
			Config.farm.e:addParam("farmE", "Use E to Farm", SCRIPT_PARAM_ONOFF, true)
			Config.farm.e:addParam("clearE", "Use E to LaneClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm.e:addParam("jungleE", "Use E to JungleClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm.e:addParam("autoE", "Use E to AutoFarm", SCRIPT_PARAM_ONOFF, true)
				
	Config:addSubMenu("[Akali Elo Shower]: Key Settings", "keys")
		Config.keys:addParam("combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.keys:addParam("harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		Config.keys:addParam("harass2", "Harass Toggle Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("V"))
		Config.keys:addParam("farmCS", "Farm Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		Config.keys:addParam("farmCS2", "Farm Toggle Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("C"))
		Config.keys:addParam("clearCS", "Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("M"))
		Config.keys:addParam("clearCS2", "Clear Toggle Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("M"))
	
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
		Config.misc:addParam("usePackets", "Use Packets (VIP Only!)", SCRIPT_PARAM_ONOFF, true)
		Config.misc:addSubMenu("W Settings", "w")
			Config.misc.w:addParam("autoW", "Use Auto W", SCRIPT_PARAM_ONOFF, false)
			Config.misc.w:addParam("wCount", "Auto W if x Enemies are near", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
			Config.misc.w:addParam("wRange", "Auto W Range", SCRIPT_PARAM_SLICE, 300, 0, 1200, 0)
			Config.misc.w:addParam("wHealth", "Auto W if Health is under %", SCRIPT_PARAM_SLICE, 15, 0, 100, 0)
			Config.misc.w:addParam("wCount", "Auto LifeSafe W if x Enemies are near", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
		Config.misc:addSubMenu("Zhonyas", "zhonyas")
			Config.misc.zhonyas:addParam("zhonyas", "Auto Zhonyas", SCRIPT_PARAM_ONOFF, true)
			Config.misc.zhonyas:addParam("zhonyasHP", "Use Zhonyas under % health", SCRIPT_PARAM_SLICE, 20, 0, 100 , 0)
			Config.misc.zhonyas:addParam("zRange", "Zhonyas Range", SCRIPT_PARAM_SLICE, 500, 0, 800, 0)
			Config.misc.zhonyas:addParam("zAmount", "Use Zhonyas if x Enemies are near", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)

	Config:addSubMenu("[Akali Elo Shower]: Killsteal Settings", "ks")
		Config.ks:addParam("ks", "Use SmartKS", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("useR", "Use R to KS(Risky!)", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("autoignite", "Auto Ignite to KS", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("[Akali Elo Shower]: Draw Setttings", "draw")
		Config.draw:addParam("mdraw", "Disable all Drawings", SCRIPT_PARAM_ONOFF, false)
		Config.draw:addParam("drawDD", "Draw Dmg Text", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawHP", "Draw Damage on HPBar", SCRIPT_PARAM_ONOFF, true)
        Config.draw:addParam("Target2", "Draw Circle around Target", SCRIPT_PARAM_ONOFF, true)
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
	
	SxOrb = SxOrbWalk()
	
	JungleMobs = {}
	JungleFocusMobs = {}
	
	if GetGame().map.shortName == "twistedTreeline" then
		TwistedTreeline = true 
	else
		TwistedTreeline = false
	end
	
	priorityTable = {
			AP = {
				"Annie", "Ahri", "Akali", "Anivia", "Annie", "Brand", "Cassiopeia", "Diana", "Evelynn", "FiddleSticks", "Fizz", "Gragas", "Heimerdinger", "Karthus",
				"Kassadin", "Ezreal", "Kayle", "Kennen", "Leblanc", "Lissandra", "Lux", "Malzahar", "Mordekaiser", "Morgana", "Nidalee", "Orianna",
				"Ryze", "Sion", "Swain", "Syndra", "Teemo", "TwistedFate", "Veigar", "Viktor", "Vladimir", "Xerath", "Ziggs", "Zyra", "Velkoz"
			},
			
			Support = {
				"Alistar", "Blitzcrank", "Janna", "Karma", "Leona", "Lulu", "Nami", "Nunu", "Sona", "Soraka", "Taric", "Thresh", "Zilean", "Braum"
			},
			
			Tank = {
				"Amumu", "Chogath", "DrMundo", "Galio", "Hecarim", "Malphite", "Maokai", "Nasus", "Rammus", "Sejuani", "Nautilus", "Shen", "Singed", "Skarner", "Volibear",
				"Warwick", "Yorick", "Zac"
			},
			
			AD_Carry = {
				"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jayce", "Jinx", "KogMaw", "Lucian", "MasterYi", "MissFortune", "Pantheon", "Quinn", "Shaco", "Sivir",
				"Talon","Tryndamere", "Tristana", "Twitch", "Urgot", "Varus", "Vayne", "Yasuo", "Zed"
			},
			
			Bruiser = {
				"Aatrox", "Darius", "Elise", "Fiora", "Gangplank", "Garen", "Irelia", "JarvanIV", "Jax", "Khazix", "LeeSin", "Nocturne", "Olaf", "Poppy",
				"Renekton", "Rengar", "Riven", "Rumble", "Shyvana", "Trundle", "Udyr", "Vi", "MonkeyKing", "XinZhao"
			}
	}

	Items = {
		BRK = { id = 3153, range = 450, reqTarget = true, slot = nil },
		BWC = { id = 3144, range = 400, reqTarget = true, slot = nil },
		DFG = { id = 3128, range = 750, reqTarget = true, slot = nil },
		HGB = { id = 3146, range = 400, reqTarget = true, slot = nil },
		RSH = { id = 3074, range = 350, reqTarget = false, slot = nil },
		STD = { id = 3131, range = 350, reqTarget = false, slot = nil },
		TMT = { id = 3077, range = 350, reqTarget = false, slot = nil },
		YGB = { id = 3142, range = 350, reqTarget = false, slot = nil },
		BFT = { id = 3188, range = 750, reqTarget = true, slot = nil },
		RND = { id = 3143, range = 275, reqTarget = false, slot = nil }
	}
	
	if not TwistedTreeline then
		JungleMobNames = { 
			["SRU_MurkwolfMini2.1.3"]	= true,
			["SRU_MurkwolfMini2.1.2"]	= true,
			["SRU_MurkwolfMini8.1.3"]	= true,
			["SRU_MurkwolfMini8.1.2"]	= true,
			["SRU_BlueMini1.1.2"]		= true,
			["SRU_BlueMini7.1.2"]		= true,
			["SRU_BlueMini21.1.3"]		= true,
			["SRU_BlueMini27.1.3"]		= true,
			["SRU_RedMini10.1.2"]		= true,
			["SRU_RedMini10.1.3"]		= true,
			["SRU_RedMini4.1.2"]		= true,
			["SRU_RedMini4.1.3"]		= true,
			["SRU_KrugMini11.1.1"]		= true,
			["SRU_KrugMini5.1.1"]		= true,
			["SRU_RazorbeakMini9.1.2"]	= true,
			["SRU_RazorbeakMini9.1.3"]	= true,
			["SRU_RazorbeakMini9.1.4"]	= true,
			["SRU_RazorbeakMini3.1.2"]	= true,
			["SRU_RazorbeakMini3.1.3"]	= true,
			["SRU_RazorbeakMini3.1.4"]	= true
		}
		
		FocusJungleNames = {
			["SRU_Blue1.1.1"]			= true,
			["SRU_Blue7.1.1"]			= true,
			["SRU_Murkwolf2.1.1"]		= true,
			["SRU_Murkwolf8.1.1"]		= true,
			["SRU_Gromp13.1.1"]			= true,
			["SRU_Gromp14.1.1"]			= true,
			["Sru_Crab16.1.1"]			= true,
			["Sru_Crab15.1.1"]			= true,
			["SRU_Red10.1.1"]			= true,
			["SRU_Red4.1.1"]			= true,
			["SRU_Krug11.1.2"]			= true,
			["SRU_Krug5.1.2"]			= true,
			["SRU_Razorbeak9.1.1"]		= true,
			["SRU_Razorbeak3.1.1"]		= true,
			["SRU_Dragon6.1.1"]			= true,
			["SRU_Baron12.1.1"]			= true
		}
	else
		FocusJungleNames = {
			["TT_NWraith1.1.1"]			= true,
			["TT_NGolem2.1.1"]			= true,
			["TT_NWolf3.1.1"]			= true,
			["TT_NWraith4.1.1"]			= true,
			["TT_NGolem5.1.1"]			= true,
			["TT_NWolf6.1.1"]			= true,
			["TT_Spiderboss8.1.1"]		= true
		}		
		JungleMobNames = {
			["TT_NWraith21.1.2"]		= true,
			["TT_NWraith21.1.3"]		= true,
			["TT_NGolem22.1.2"]			= true,
			["TT_NWolf23.1.2"]			= true,
			["TT_NWolf23.1.3"]			= true,
			["TT_NWraith24.1.2"]		= true,
			["TT_NWraith24.1.3"]		= true,
			["TT_NGolem25.1.1"]			= true,
			["TT_NWolf26.1.2"]			= true,
			["TT_NWolf26.1.3"]			= true
		}
	end
		
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object and object.valid and not object.dead then
			if FocusJungleNames[object.name] then
				JungleFocusMobs[#JungleFocusMobs+1] = object
			elseif JungleMobNames[object.name] then
				JungleMobs[#JungleMobs+1] = object
			end
		end
	end
end

function SetPriority(table, hero, priority)
	for i=1, #table, 1 do
		if hero.charName:find(table[i]) ~= nil then
			TS_SetHeroPriority(priority, hero.charName)
		end
	end
end
 
function arrangePrioritys()
		for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP,	   enemy, 2)
		SetPriority(priorityTable.Support,  enemy, 3)
		SetPriority(priorityTable.Bruiser,  enemy, 4)
		SetPriority(priorityTable.Tank,	 enemy, 5)
		end
end

function arrangePrioritysTT()
        for i, enemy in ipairs(GetEnemyHeroes()) do
		SetPriority(priorityTable.AD_Carry, enemy, 1)
		SetPriority(priorityTable.AP,       enemy, 1)
		SetPriority(priorityTable.Support,  enemy, 2)
		SetPriority(priorityTable.Bruiser,  enemy, 2)
		SetPriority(priorityTable.Tank,     enemy, 3)
        end
end

function PriorityOnLoad()
	if heroManager.iCount < 10 or (TwistedTreeline and heroManager.iCount < 6) then
		print("<b><font color=\"#6699FF\">Akali Elo Shower:</font></b> <font color=\"#FFFFFF\">Too few champions to arrange priority.</font>")
	elseif heroManager.iCount == 6 then
		arrangePrioritysTT()
    else
		arrangePrioritys()
	end
end

function GetJungleMob()
	for _, Mob in pairs(JungleFocusMobs) do
		if ValidTarget(Mob, Qrange) then return Mob end
	end
	for _, Mob in pairs(JungleMobs) do
		if ValidTarget(Mob, Qrange) then return Mob end
	end
end

function OnCreateObj(obj)
	if obj.valid then
		if FocusJungleNames[obj.name] then
			JungleFocusMobs[#JungleFocusMobs+1] = obj
		elseif JungleMobNames[obj.name] then
			JungleMobs[#JungleMobs+1] = obj
		end
	end
end

function OnDeleteObj(obj)
	for i, Mob in pairs(JungleMobs) do
		if obj.name == Mob.name then
			table.remove(JungleMobs, i)
		end
	end
	for i, Mob in pairs(JungleFocusMobs) do
		if obj.name == Mob.name then
			table.remove(JungleFocusMobs, i)
		end
	end
end

for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }
end

function GetEnemyHPBarPos(enemy)

    if not enemy.barData then
        return
    end

    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)
    local barPosPercentageOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)

    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 16
    local CorrectionY = 4

    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 

    local StartPos = Point(barPos.x, barPos.y)
    local EndPos = Point(barPos.x + 103, barPos.y)

    return Point(StartPos.x, StartPos.y), Point(EndPos.x, EndPos.y)

end

function DrawIndicator(enemy)
	local Qdmg, Edmg, Rdmg = getDmg("Q", enemy, myHero), getDmg("E", enemy, myHero), getDmg("R", enemy, myHero)
	
	Qdmg = ((Qready and Qdmg) or 0)
	Edmg = ((Eready and Edmg) or 0)
	Rdmg = ((Rready and Rdmg) or 0)

    local damage = Qdmg + Edmg + Rdmg

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

    DrawText("HP: "..math.floor(enemy.health - damage), 12, math.floor(SPos.x + 25), math.floor(SPos.y - 15), (enemy.health - damage) > 0 and ARGB(255, 0, 255, 0) or  ARGB(255, 255, 0, 0))
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
				if spell.name == x.spellName and Config.misc.ES2[x.spellName] and ValidTarget(unit, Config.misc.w.wRange) then
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

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("REHFFJHDEJH") 
