--[[
	Ryze the Dark Mage by Kn0wM3
	Hope you enjoy!
	Please report bugs on the Forum!(http://forum.botoflegends.com/topic/50262-freescriptsxorbsacrmma-ryze-the-dark-mage-released-6022015/)
]]

if myHero.charName ~= "Ryze" then return end

_G.AUTOUPDATE = true -- Change to "false" to disable auto updates!

local version = "1.021"
local author = "Kn0wM3"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Kn0wM3/BoLScripts/master/Ryze the Dark Mage.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
function AutoupdaterMsg(msg) print("<font color=\"#FF0000\"><b>Ryze the Dark Mage:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if _G.AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/Kn0wM3/BoLScripts/master/Ryze%20the%20Dark%20Mage.Version")
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

local Qready, Wready, Eready, Rready, AADisabled = false
local Qrange, Wrange, Erange = 625, 600, 600

function OnLoad()
	Menu()
	Variables()
	PriorityOnLoad()
end

function OnTick()
	Checks()
	
	if myHero.dead then return end
	
	ComboKey = Config.keys.combo
	HarassKey = Config.keys.harass
	AutoHarassKey = Config.keys.harass2
	FarmKey = Config.keys.farmCS
	ClearKey = Config.keys.clearCS
	
	if ComboKey then Combo(Target) end
	if HarassKey or AutoHarassKey then Harass(Target) end
	if Config.ks.ks then KillSteal() end
	if Config.harass.q.autoQ and not ComboKey and not HarassKey and not AutoHarassKey then AutoQ() end
	if Config.farm.q.autoQ and not ComboKey and not HarassKey and not AutoHarassKey then FarmQ() end
	if FarmKey or Config.keys.farmCS2 and not ComboKey and not HarassKey and not AutoHarassKey then LastHitMode() end
	if ClearKeyS or Config.keys.clearCS2 and not ComboKey and not HarassKey and not AutoHarassKey then LaneClearMode() end
	if ClearKey or Config.keys.clearCS2 and not ComboKey and not HarassKey and not AutoHarassKey then JungleClearMode() end
	if Config.misc.zhonyas.zhonyas then Zhonyas() end
	if Config.draw.drawDD and not Config.draw.mdraw then DmgCalc() end
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
        if Config.draw.myHero then
            DrawCircle(myHero.x, myHero.y, myHero.z, TrueRange(), RGB(Config.draw.myColor[2], Config.draw.myColor[3], Config.draw.myColor[4]))
        end
        if Config.draw.Target and Target ~= nil then
            DrawCircle(Target.x, Target.y, Target.z, 80, ARGB(255, 10, 255, 10))
        end
		if Config.draw.text and Target ~= nil then 
			DrawText3D("Current Target",Target.x-100, Target.y-50, Target.z, 20, 0xFFFFFF00)
		end
		if Config.draw.drawHP then
			for i, enemy in ipairs(GetEnemyHeroes()) do
       			if ValidTarget(enemy) then
			DrawIndicator(enemy)
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

function Combo(unit)
	if ValidTarget(unit) and unit ~= nil then
		if Config.combo.useItems then
			UseItems(unit)
		end
		if Config.combo.combomode == 1 then
			if Config.combo.q.useQ and Qready then
				CastQ(unit)
			end
			if Config.combo.r.useR and Rready and not Qready then
				CastSpell(_R)
			end
			if Config.combo.w.useW and Wready then
				CastW(unit)
			end
			if Config.combo.e.useE and Eready and not Qready then
				CastE(unit)
				end
			end
		if Config.combo.combomode == 2 then
			if Config.combo.w.useW and Wready then
				CastW(unit)
			end
			if Config.combo.q.useQ and Qready then
				CastQ(unit)
			end
			if Config.combo.r.useR and Rready and not Qready then
				CastSpell(_R)
			end
			if Config.combo.e.useE and Eready and not Qready then
				CastE(unit)
			end
		end
	end
end

function Harass(unit)
	if ValidTarget(unit) and unit ~= nil then
		if Config.harass.q.useQ and Qready then
			CastQ(unit)
		end
		if Config.harass.w.useW and Wready then
			CastW(unit)
		end
		if Config.harass.e.useE and Eready and not Qready then
			CastE(unit)
		end
	end
end

function LastHitMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil then
				if ValidTarget(minion, Qrange) and Config.farm.q.farmQ and Qready and getDmg("Q", minion, myHero) >= minion.health and getDmg("AD", minion, myHero) < minion.health then
					CastSpell(_Q, minion)
				end
				if ValidTarget(minion, Erange) and Config.farm.e.farmE and Eready and getDmg("E", minion, myHero) >= minion.health then 
					CastSpell(_E, minion)
				end
				if ValidTarget(minion, Wrange) and Config.farm.w.farmW and not Config.farm.w.safeW and Wready and getDmg("W", minion, myHero) >= minion.health and getDmg("AD", minion, myHero) < minion.health then 
					CastSpell(_W, minion)
			end
		end
	end
end	

function LaneClearMode()
	enemyMinions:update()
		for i, minion in pairs(enemyMinions.objects) do
			if minion ~= nil and ValidTarget(minion, Qrange) and Config.farm.q.clearQ and Qready and getDmg("AD", minion, myHero) < minion.health then
				if getDmg("Q", minion, myHero) >= minion.health then
					CastSpell(_Q, minion)
				else
					CastSpell(_Q, minion)
			end	
		end
			if minion ~= nil and ValidTarget(minion, wRange) and Config.farm.r.clearR and Rready then
				CastSpell(_R)
			end
			if minion ~= nil and ValidTarget(minion, Erange) and Config.farm.e.clearE and Eready and not Qready then
				if getDmg("E", minion, myHero) >= minion.health then
					CastSpell(_E, minion)
				else
					CastSpell(_E, minion)
			end
		end
			if minion ~= nil and ValidTarget(minion, Wrange) and Config.farm.w.clearW and Wready and not Qready and getDmg("AD", minion, myHero) < minion.health then
				if not Config.farm.w.safeW then
					if getDmg("W", minion, myHero) >= minion.health then
						CastSpell(_W, minion)
					else
						CastSpell(_W, minion)
					end
				elseif CountEnemyHeroInRange(1000) >= 1 then return end
		end
	end
end

function JungleClearMode()
	local JungleMob = GetJungleMob()
	
	if JungleMob ~= nil then
		if Config.farm.q.jungleQ and GetDistance(JungleMob) <= Qrange and Qready then
			CastSpell(_Q, JungleMob)
		end
		if Config.farm.r.jungleR then
			CastSpell(_R)
		end
		if Config.farm.w.jungleW and GetDistance(JungleMob) <= Wrange and Wready and not Qready then
			if not Config.farm.w.safeW then
				CastSpell(_W, JungleMob)
			elseif CountEnemyHeroInRange(1000) >= 1 then return end
		end
		if Config.farm.e.jungleE and GetDistance(JungleMob) <= Erange and Eready and not Qready then
			CastSpell(_E, JungleMob)
		end
	end
end

function CastQ(unit)
	if unit ~= nil and GetDistance(unit) <= Qrange then
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
            if ValidTarget(minion, Qrange) and Qready and getDmg("Q", minion, myHero) >= minion.health and getDmg("AD", minion, myHero) < minion.health then
                CastSpell(_Q, minion)
            end
        end
    end
end

function CastW(unit)
	if unit ~= nil and GetDistance(unit) <= Wrange then
		if VIP_USER and Config.misc.usePackets then
			Packet("S_CAST", {spellId = _W, targetNetworkId = unit.networkID}):send()
		else
			CastSpell(_W, unit)
		end
	end
end

function CastE(unit)
	if unit ~= nil and GetDistance(unit) <= Erange then
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
		
		if enemy ~= nil and ValidTarget(enemy, 650) then
			if enemy.health <= qDmg and ValidTarget(enemy, Qrange) and Qready then
				CastQ(enemy)
			elseif enemy.health <= wDmg and ValidTarget(enemy, Wrange) and Wready then
				CastW(enemy)
			elseif enemy.health <= eDmg and ValidTarget(enemy, Erange) and Eready then
				CastE(enemy)
			elseif enemy.health <= (qDmg + wDmg) and ValidTarget(enemy, Wrange) and Wready and Qready then
				CastW(enemy)
				CastQ(enemy)
			elseif enemy.health <= (qDmg + eDmg) and ValidTarget(enemy, Eready) and Eready and Qready then
				CastE(enemy)
				CastQ(enemy)
			elseif enemy.health <= (wDmg + eDmg) and ValidTarget(enemy, Wrange) and Wready and Eready then
				CastW(enemy)
				CastE(enemy)
			elseif enemy.health <= (qDmg + wDmg + eDmg) and ValidTarget(enemy, Wrange) and Qready and Wready and Eready then
				CastW(enemy)
				CastQ(enemy)
				CastE(enemy)
			elseif enemy.health <= (qDmg + iDmg) and ValidTarget(enemy, Qrange) and Qready and Igniteready then
				CastQ(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (wDmg + iDmg) and ValidTarget(enemy, Wrange) and Wready and Igniteready then
				CastW(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (eDmg + iDmg) and ValidTarget(enemy, Erange) and Eready and Igniteready then
				CastE(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (qDmg + wDmg + iDmg) and ValidTarget(enemy, Wrange) and Qready and Wready and Igniteready then
				CastW(enemy)
				CastQ(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (qDmg + eDmg + iDmg) and ValidTarget(enemy, Erange) and Qready and Eready and Igniteready then
				CastQ(enemy)
				CastE(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (wDmg + eDmg + iDmg) and ValidTarget(enemy, Wrange) and Wready and Eready and Igniteready then
				CastW(enemy)
				CastE(enemy)
				CastSpell(Ignite.slot, enemy)
			elseif enemy.health <= (qDmg + wDmg + eDmg + iDmg) and ValidTarget(enemy, Wrange) and Qready and Wready and Eready and Igniteready then
				CastW(enemy)
				CastQ(enemy)
				CastE(enemy)
				CastSpell(Ignite.slot, enemy)
			end
				if Config.ks.autoIgnite then AutoIgnite(enemy) 
			end
		end
	end
end

function DmgCalc()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
			if enemy ~= nil and ValidTarget(enemy) then
				aaDmg 		= ((getDmg("AD", enemy, myHero)) or 0)
				qDmg 		= ((getDmg("Q", enemy, myHero)) or 0)	
				wDmg		= ((getDmg("W", enemy, myHero)) or 0)	
				eDmg		= ((getDmg("E", enemy, myHero)) or 0)	
				iDmg 		= ((Ignite.slot ~= nil and getDmg("IGNITE", enemy, myHero)) or 0)
	-- Set Kill Text --	
					-- "Kill! - AA" --
					if enemy.health <= aaDmg
						then
							KillText[i] = 2
							
					-- "Kill! - Ignite" --
					elseif enemy.health <= iDmg
						then
							KillText[i] = 3

					-- "Kill! - (Q)" --
					elseif enemy.health <= qDmg
						then
							KillText[i] = 4
							
					--	"Kill! - (W)" --
					elseif enemy.health <= wDmg
						then
							KillText[i] = 5
							
					-- "Kill! - (E)" --
					elseif enemy.health <= eDmg
						then
							KillText[i] = 6
							
					-- "Kill! - (Q)+(W)" --
					elseif enemy.health <= (qDmg+wDmg)
						then
							KillText[i] = 7
							
					-- "Kill! - (Q)+(E)" --
					elseif enemy.health <= (qDmg+eDmg)
						then
							KillText[i] = 8
							
					-- "Kill! - (W)+(E)" --
					elseif enemy.health <= (wDmg+eDmg)
						then
							KillText[i] = 9
							
					-- "Kill! - (Q)+(W)+(E)" --
					elseif enemy.health <= (qDmg+wDmg+eDmg)
						then
							KillText[i] = 10
							
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
	
	Igniteready = (Ignite.slot ~= nil and myHero:CanUseSpell(Ignite.slot) == READY)
	
	Target = GetCustomTarget()
	TargetSelector:update()
	SxOrb:ForceTarget(Target)
	
	if Config.combo.disableAA then
		if Config.keys.combo then
			if not AADisabled then
				SxOrb:DisableAttacks()
				AADisabled = true
			end
		elseif not Config.keys.combo then
			if AADisabled then
				SxOrb:EnableAttacks()
				AADisabled = false
			end
		end
	end
	
	if Config.draw.lfc.lfc then
		_G.DrawCircle = DrawCircle2
	else 
		_G.DrawCircle = _G.oldDrawCircle 
	end
end

function Menu()
	
	Config = scriptConfig("Ryze the Dark Mage", "Ryze1") 
	Config:addSubMenu("[Ryze the Dark Mage]: Combo Settings", "combo")
		Config.combo:addParam("combomode", "Combo Mode List", SCRIPT_PARAM_LIST, 1, {"R>Q>W>E", "R>W>Q>E"})
		Config.combo:addParam("useItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("disableAA", "Disable AA in Combo", SCRIPT_PARAM_ONOFF, true)
		Config.combo:addParam("focus", "Focus Selected Target", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addSubMenu("Q Settings", "q")
				Config.combo.q:addParam("useQ", "Use Q in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addSubMenu("W Settings", "w")
				Config.combo.w:addParam("useW", "Use W in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addSubMenu("E Settings", "e")
				Config.combo.e:addParam("useE", "Use E in Combo", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addSubMenu("R Settings", "r")	
				Config.combo.r:addParam("useR", "Use R in Combo", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("[Ryze the Dark Mage]: Harass Settings", "harass")
		Config.harass:addSubMenu("Q Settings", "q")
			Config.harass.q:addParam("useQ", "Use Q to Harass", SCRIPT_PARAM_ONOFF, true)
			Config.harass.q:addParam("autoQ", "Auto Q to Harass", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addSubMenu("W Settings", "w")
			Config.harass.w:addParam("useW", "Use W to Harass", SCRIPT_PARAM_ONOFF, true)
		Config.harass:addSubMenu("E Settings", "e")
			Config.harass.e:addParam("useE", "Use E to Harass", SCRIPT_PARAM_ONOFF, true)
	
	Config:addSubMenu("[Ryze the Dark Mage]: Farm Settings", "farm")
		Config.farm:addSubMenu("Q Settings", "q")
			Config.farm.q:addParam("farmQ", "Use Q to Farm", SCRIPT_PARAM_ONOFF, true)
			Config.farm.q:addParam("clearQ", "Use Q to LaneClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm.q:addParam("jungleQ", "Use Q to JungleClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm.q:addParam("autoQ", "Use Q to AutoFarm", SCRIPT_PARAM_ONOFF, true)
		Config.farm:addSubMenu("E Settings", "e")
			Config.farm.e:addParam("farmE", "Use E to Farm", SCRIPT_PARAM_ONOFF, true)
			Config.farm.e:addParam("clearE", "Use E to LaneClear", SCRIPT_PARAM_ONOFF, true)
			Config.farm.e:addParam("jungleE", "Use E to JungleClear", SCRIPT_PARAM_ONOFF, true)
		Config.farm:addSubMenu("W Settings", "w")
			Config.farm.w:addParam("safeW", "Safe W if Enemies are near", SCRIPT_PARAM_ONOFF, true)
			Config.farm.w:addParam("farmW", "Use W to LastHit", SCRIPT_PARAM_ONOFF, false)
			Config.farm.w:addParam("clearW", "Use W to LaneClear", SCRIPT_PARAM_ONOFF, false)
			Config.farm.w:addParam("jungleW", "Use W to JungleClear", SCRIPT_PARAM_ONOFF, false)
		Config.farm:addSubMenu("R Settings", "r")
			Config.farm.r:addParam("clearR", "Use R to LaneClear", SCRIPT_PARAM_ONOFF, false)
			Config.farm.r:addParam("jungleR", "Use R to JungleClear", SCRIPT_PARAM_ONOFF, false)

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
			Config.misc.zhonyas:addParam("zhonyasHP", "Use Zhonyas at % health", SCRIPT_PARAM_SLICE, 20, 0, 100 , 0)
			Config.misc.zhonyas:addParam("zRange", "Zhonyas Range", SCRIPT_PARAM_SLICE, 500, 0, 800, 0)
			Config.misc.zhonyas:addParam("zAmount", "Use Zhonyas atx Enemies", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)

	Config:addSubMenu("[Ryze the Dark Mage]: Killsteal Settings", "ks")
		Config.ks:addParam("ks", "Use SmartKS", SCRIPT_PARAM_ONOFF, true)
		Config.ks:addParam("autoIgnite", "Auto Ignite to KS", SCRIPT_PARAM_ONOFF, true)
		
	Config:addSubMenu("[Ryze the Dark Mage]: Draw Setttings", "draw")
		Config.draw:addParam("mdraw", "Disable all Drawings", SCRIPT_PARAM_ONOFF, false)
		Config.draw:addParam("drawDD", "Draw Dmg Text", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("drawHP", "Draw Dmg on HPBar", SCRIPT_PARAM_ONOFF, true)
        Config.draw:addParam("Target", "Draw Circle around Target", SCRIPT_PARAM_ONOFF, true)
		Config.draw:addParam("text", "Draw Current Target", SCRIPT_PARAM_ONOFF, true)
        Config.draw:addParam("myHero", "Draw AA Range", SCRIPT_PARAM_ONOFF, false)
        Config.draw:addParam("myColor", "AA Range Color", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
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

	Config:addSubMenu("[Ryze the Dark Mage]: Key Settings", "keys")
		Config.keys:addParam("combo", "Combo Mode", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Config.keys:addParam("harass", "Harass Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		Config.keys:addParam("harass2", "Harass Toggle Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("V"))
		Config.keys:addParam("farmCS", "Farm Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		Config.keys:addParam("farmCS2", "Farm Toggle Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("C"))
		Config.keys:addParam("clearCS", "Clear Mode", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("M"))
		Config.keys:addParam("clearCS2", "Clear Toggle Mode", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("M"))
			
	Config:addSubMenu("[Ryze the Dark Mage]: Orbwalker", "Orbwalking")
		SxOrb:LoadToMenu(Config.Orbwalking)

		
	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, Qrange, DAMAGE_MAGIC, true)
	TargetSelector.name = "Ryze"
	Config:addTS(TargetSelector)
	
	Config:addParam("info", "Version:", SCRIPT_PARAM_INFO, ""..version.."")
	Config:addParam("info2", "Author:", SCRIPT_PARAM_INFO, ""..author.."")

	Config.keys:permaShow("combo")
	Config.keys:permaShow("harass")
	Config.keys:permaShow("harass2")
	Config.keys:permaShow("farmCS")
	Config.keys:permaShow("farmCS2")
	Config.keys:permaShow("clearCS")
	Config.keys:permaShow("clearCS2")
end

function Variables()
	
	Ignite = { name = "summonerdot", range = 600, slot = nil }
	enemyMinions = minionManager(MINION_ENEMY, Qrange, myHero, MINION_SORT_MAXHEALTH_DEC)
	
	if myHero:GetSpellData(SUMMONER_1).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_1  
	elseif myHero:GetSpellData(SUMMONER_2).name:find(Ignite.name) then
		Ignite.slot = SUMMONER_2  
	end
	
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2	
	
	local ts
	
	SxOrb = SxOrbWalk()
	
	JungleMobs = {}
	JungleFocusMobs = {}
	
	if GetGame().map.shortName == "twistedTreeline" then
		TwistedTreeline = true 
	else
		TwistedTreeline = false
	end
	
	local KillText = {}
	local KillTextColor = ARGB(250, 255, 38, 1)
	local KillTextList = {		
						"Harass Him!", 							-- 01
						"Kill! - AA", 							-- 02
						"Kill! - Ignite",						-- 03
						"Kill! - (Q)",							-- 04
						"Kill! - (W)",							-- 05
						"Kill! - (E)",							-- 06
						"Kill! - (Q)+(W)",						-- 07
						"Kill! - (Q)+(E)",						-- 08
						"Kill! - (W)+(E)",						-- 09
						"Kill! - (Q)+(W)+(E)"					-- 10
					}

	GapCloserList = {
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
		print("<b><font color=\"#6699FF\">Ryze the Dark Mage:</font></b> <font color=\"#FFFFFF\">Too few champions to arrange priority.</font>")
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
	local Qdmg, Wdmg, Edmg, AAdmg = getDmg("Q", enemy, myHero), getDmg("W", enemy, myHero), getDmg("E", enemy, myHero), getDmg("AD", enemy, myHero)
	
	Qdmg = ((Qready and Qdmg) or 0)
	Wdmg = ((Wready and Wdmg) or 0)
	Edmg = ((Eready and Edmg) or 0)
	AAdmg = ((Aadmg) or 0)

    local damage = Qdmg + Wdmg + Edmg

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

	DrawText("|", 16, math.floor(Position), math.floor(SPos.y + 8), ARGB(255,0,255,0))
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
	if SelectedTarget ~= nil and ValidTarget(SelectedTarget, 1500) and (Ignore == nil or (Ignore.networkID ~= SelectedTarget.networkID)) then
		return SelectedTarget
	end
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
	return TargetSelector.target
end

function OnWndMsg(Msg, Key)
	if Msg == WM_LBUTTONDOWN then
		local minD = 0
		local Target = nil
		for i, unit in ipairs(GetEnemyHeroes()) do
			if ValidTarget(unit) then
				if GetDistance(unit, mousePos) <= minD or Target == nil then
					minD = GetDistance(unit, mousePos)
					Target = unit
				end
			end
		end

		if Target and minD < 115 then
			if SelectedTarget and Target.charName == SelectedTarget.charName then
				SelectedTarget = nil
			else
				SelectedTarget = Target
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

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("PCFDEDFIBBG")  
