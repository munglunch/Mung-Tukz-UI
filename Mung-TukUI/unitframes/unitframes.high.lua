--[[--------------------------------------------------------------------
	oUF_Tukz
	
	I'd like to thank Haste for his awesome oUF framework, without which 
	this layout would do absolutely nothing. I'd also like to thank Caellian 
	for his cleanly written oUF_Caellian which helped me as a guide to write 
	this layout. 

	Supported Units:
		Player
		Pet
		Target
		Target Target
		Focus
		Party 
		Vehicule
		Raid10
		Raid25
		Raid40
		Raid15
		Arena#
		Boss#

	Required Dependencies:
		oUF
	
----------------------------------------------------------------------]]

if not TukuiDB["unitframes"].enable == true or TukuiDB.lowversion == true then return end

------------------------------------------------------------------------
--	Textures and Medias
------------------------------------------------------------------------

local floor = math.floor
local format = string.format

local unitcolor = TukuiDB["media"].unitcolor
local unitshadowcolor = {0,0,0,0.7} -- Shadow color here

local playerClass = select(2, UnitClass("player"))
local normTex = TukuiDB["media"].normTex
local blank = TukuiDB["media"].blank
local barTex3 = TukuiDB["media"].barTex3
local glowTex = TukuiDB["media"].glowTex
local bubbleTex = TukuiDB["media"].bubbleTex
local castb = TukuiDB["media"].castb
local castb2 = TukuiDB["media"].castb2
local iamwallpaper = TukuiDB["media"].unitwall
local i2amwallpaper = TukuiDB["media"].deadwall
local cColor = TukuiDB["classy"]
local _, class = UnitClass("player")
local colorz = cColor[class]

local backdrop = {
	bgFile = TukuiDB["media"].blank,
	insets = {top = -TukuiDB.mult, left = -TukuiDB.mult, bottom = -TukuiDB.mult, right = -TukuiDB.mult},
}

local font = TukuiDB["media"].uffont
local font2 = TukuiDB["media"].superfont
local font3 = TukuiDB["media"].font
local pixel = TukuiDB["media"].pixelfont

------------------------------------------------------------------------
--	Colors
------------------------------------------------------------------------

local colors = setmetatable({
	runes = setmetatable({
		[1] = {0.69, 0.31, 0.31},
		[2] = {0.33, 0.59, 0.33},
		[3] = {0.31, 0.45, 0.63},
		[4] = {0.84, 0.75, 0.65},
	}, {__index = oUF.colors.runes}),
}, {__index = oUF.colors})

oUF.colors.class = {
	["DEATHKNIGHT"] = { 236/255,  50/255,  80/255 },
	["DRUID"]       = { 255/255, 125/255,  30/255 },
	["HUNTER"]      = {  90/255, 255/255,  90/255 },
	["MAGE"]        = {  20/255, 191/255, 255/255 },
	["PALADIN"]     = { 245/255,  40/255, 146/255 },
	["PRIEST"]      = { 248/255, 248/255, 255/255 },
	["ROGUE"]       = { 255/255, 243/255,  32/255 },
	["SHAMAN"]      = {  81/255,  81/255, 255/255 },
	["WARLOCK"]     = { 208/255,  93/255, 246/255 },
	["WARRIOR"]     = { 172/255,  102/255,  29/255 },
}

oUF.colors.power = {
		["MANA"] = {.05, .4, 1},
		["RAGE"] = {.9, .1, .1},
		["FUEL"] = {0, 0.55, 0.5},
		["FOCUS"] = {.9, .9, .1},
		["ENERGY"] = {.9, .9, .1},
		["AMMOSLOT"] = {0.8, 0.6, 0},
		["RUNIC_POWER"] = {.1, .9, .9},
		["POWER_TYPE_STEAM"] = {0.55, 0.57, 0.61},
		["POWER_TYPE_PYRITE"] = {0.60, 0.09, 0.17},
}

oUF.colors.happiness = {
		[1] = {0.93,0.07,0.07},
		[2] = {0.93,0.93,0.07},
		[3] = {0.07, 0.93, 0.07},
}
	
local UnitReactionColor = {
	[1] = { 239/255, 11/255,  11/255 }, -- Hated
	[2] = { 239/255, 11/255,  11/255 }, -- Hostile
	[3] = { 239/255, 11/255,  11/255 }, -- Unfriendly
	[4] = { 218/255, 197/255, 92/255 }, -- Neutral
	[5] = { 75/255,  255/255, 76/255 }, -- Friendly
	[6] = { 75/255,  175/255, 76/255 }, -- Honored
	[7] = { 75/255,  175/255, 76/255 }, -- Revered
	[8] = { 75/255,  175/255, 76/255 }, -- Exalted
}

oUF.colors.tapped = {0.55, 0.57, 0.61}
oUF.colors.disconnected = {0.84, 0.75, 0.65}

oUF.colors.smooth = {0.89, 0.11, 0.11, 0.65, 0.83, 0.25, 0.25, 0.25, 0.25}

local runeloadcolors = {
	[1] = {.69,.31,.31},
	[2] = {.69,.31,.31},
	[3] = {.33,.59,.33},
	[4] = {.33,.59,.33},
	[5] = {.31,.45,.63},
	[6] = {.31,.45,.63},
}

------------------------------------------------------------------------
--	Fonction (don't edit this if you don't know what you are doing!)
------------------------------------------------------------------------
local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/TukuiDB["general"].uiscale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end

function TukuiDB:Scale(x) return scale(x) end
TukuiDB.mult = mult

local SetUpAnimGroup = function(self)
	self.anim = self:CreateAnimationGroup("Flash")
	self.anim.fadein = self.anim:CreateAnimation("ALPHA", "FadeIn")
	self.anim.fadein:SetChange(1)
	self.anim.fadein:SetOrder(2)

	self.anim.fadeout = self.anim:CreateAnimation("ALPHA", "FadeOut")
	self.anim.fadeout:SetChange(-1)
	self.anim.fadeout:SetOrder(1)
end

local Flash = function(self, duration)
	if not self.anim then
		SetUpAnimGroup(self)
	end

	self.anim.fadein:SetDuration(duration)
	self.anim.fadeout:SetDuration(duration)
	self.anim:Play()
end

local StopFlash = function(self)
	if self.anim then
		self.anim:Finish()
	end
end

local menu = function(self)
	local unit = self.unit:sub(1, -2)
	local cunit = self.unit:gsub("(.)", string.upper, 1)
	if(unit == "party" or unit == "partypet") then
		ToggleDropDownMenu(1, nil, _G["PartyMemberFrame"..self.id.."DropDown"], "cursor", 0, 0)
	elseif(_G[cunit.."FrameDropDown"]) then
		ToggleDropDownMenu(1, nil, _G[cunit.."FrameDropDown"], "cursor", 0, 0)
	end
end

local SetFontString = function(parent, fontName, fontHeight, fontStyle, fontJust)  --for fontJust use numbers blank(nil)=left, 2=center, 3=right..-----
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	if fontJust == 2 then
		fs:SetJustifyH("CENTER")
	elseif fontJust == 3 then
		fs:SetJustifyH("RIGHT")
	else
		fs:SetJustifyH("LEFT")
	end
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
end

local ShortValue = function(value)
	if value >= 1e6 then
		return ("%.1fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?0+([km])$", "%1")
	else
		return value
	end
end

local function ShowThreat(self, event, unit)
	if (self.unit ~= "player") then
		return
	end
	local threat = UnitThreatSituation(self.unit)
	if (threat == 3) then
		self.FrameBackdrop:SetBackdropBorderColor(1, .1, .1)
	else
		self.FrameBackdrop:SetBackdropBorderColor(unpack(unitshadowcolor))
	end 
end

local PostUpdateHealth = function(self, event, unit, bar, min, max)  
    local cur, maxhp = min, max
    local missing = maxhp-cur
    
    local d = floor(cur/maxhp*100)
	self.Health.bg:SetVertexColor(0.08, 0.08, 0.08)
	if(UnitIsDead(unit)) then
		bar:SetValue(0)
		bar.value:SetText(tukuilocal.unitframes_ouf_deadheal)
	elseif(UnitIsGhost(unit)) then
		bar:SetValue(0)
		bar.value:SetText(tukuilocal.unitframes_ouf_ghostheal)
	elseif(not UnitIsConnected(unit)) then
		bar.value:SetText(tukuilocal.unitframes_disconnected)
	elseif unit == "player" then
		bar.value:SetText((cur).." |cffFFFF00".."|r")
	elseif unit == "target" then
		bar.value:SetText((cur).." |cffFFFFFF".."|r")
	else
		bar.value:Hide()
	end
	
	-- Coloring CastBar here
	if self.Castbar then
		if unit=="player" then
			self.Castbar:SetStatusBarColor(0, 1, 1, 0.8)
		else
			r, g, b = UnitSelectionColor(unit) -- Enemy or not ??
			self.Castbar:SetStatusBarColor(r, g, b)
		end
	end
	-- portrait bg coloring
	
		if not UnitIsPlayer(unit) then 
			r, g, b = UnitSelectionColor(unit)
			bar.value:SetTextColor(r, g, b)
			if unit == "target" or unit == "focus" then
				self.portraitWall:SetVertexColor(r, g, b)
			end
			if(self.Info) then
				self.Info:SetTextColor(r, g, b)
			end
			if(self.Power.value) then
				self.Power.value:SetTextColor(r, g, b)
			end
		else
			local _, englass = UnitClass(unit)
			r, g, b = unpack(cColor[englass])
			bar.value:SetTextColor(r, g, b)
			if unit == "target" or unit == "focus" then
				self.portraitWall:SetVertexColor(r, g, b)
			end
			if(self.Info) then
				self.Info:SetTextColor(r, g, b)
			end
			if(self.Power.value) then
				self.Power.value:SetTextColor(r, g, b)
			end
		end
end

local PostUpdatePower = function(self, event, unit, bar, min, max)
	self.Power.bg:SetVertexColor(0.08, 0.08, 0.08)
	if (self.unit ~= "player" and self.unit ~= "vehicle" and self.unit ~= "pet" and self.unit ~= "target" and not(self:GetName():match"oUF_Arena")) then return end

	if min == 0 then
		bar.value:SetText()
	elseif not UnitIsPlayer(unit) and not UnitPlayerControlled(unit) or not UnitIsConnected(unit) then
		bar.value:SetText()
	elseif UnitIsDead(unit) or UnitIsGhost(unit) then
		bar.value:SetText()
	elseif min == max and (pType == 2 or pType == 3 and pToken ~= "POWER_TYPE_PYRITE") then
		bar.value:SetText()
	else
		if min ~= max then
			if pType == 0 then
				if unit == "target" then
					if TukuiDB["unitframes"].showtotalhpmp == true then
						bar.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						bar.value:SetFormattedText("%d%% |cffD7BEA5-|r %s", floor(min / max * 100), ShortValue(max - (max - min)))
					end
				elseif unit == "player" and self:GetAttribute("normalUnit") == "pet" or unit == "pet" then
					if TukuiDB["unitframes"].showtotalhpmp == true then
						bar.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						bar.value:SetFormattedText("%d%%", floor(min / max * 100))
					end
				elseif (self:GetName():match"oUF_Arena") then
					bar.value:SetText(ShortValue(min))
					--bar.value:SetTextColor(1, 1, 1)
				else
					if TukuiDB["unitframes"].showtotalhpmp == true then
						bar.value:SetFormattedText("%s |cffD7BEA5|||r %s", ShortValue(max - (max - min)), ShortValue(max))
					else
						bar.value:SetFormattedText("%d%% |cffD7BEA5-|r %d", floor(min / max * 100), max - (max - min))
					end
				end
			else
				bar.value:SetText(max - (max - min))
			end
		else
			if unit == "pet" or unit == "target" or (unit and unit:find("arena%d")) then
				bar.value:SetText(ShortValue(min))
			elseif (self:GetName():match"oUF_Arena") then
				bar.value:SetText("|cffFFFFFF"..min.."|r")
			else
				bar.value:SetText(min)
			end
		end
	end
end

local delay = 0
local viperAspectName = GetSpellInfo(34074)
local UpdateManaLevel = function(self, elapsed)
	delay = delay + elapsed
	if self.parent.unit ~= "player" or delay < 0.2 or UnitIsDeadOrGhost("player") or UnitPowerType("player") ~= 0 then return end
	delay = 0

	local percMana = UnitMana("player") / UnitManaMax("player") * 100

	if AotV then
		local viper = UnitBuff("player", viperAspectName)
		if percMana >= TukuiDB["unitframes"].highThreshold and viper then
			self.ManaLevel:SetText("|cffaf5050"..tukuilocal.unitframes_ouf_gohawk.."|r")
			Flash(self, 0.3)
		elseif percMana <= TukuiDB["unitframes"].lowThreshold and not viper then
			self.ManaLevel:SetText("|cffaf5050"..tukuilocal.unitframes_ouf_goviper.."|r")
			Flash(self, 0.3)
		else
			self.ManaLevel:SetText()
			StopFlash(self)
		end
	else
		if percMana <= 20 then
			self.ManaLevel:SetText("|cffaf5050"..tukuilocal.unitframes_ouf_lowmana.."|r")
			Flash(self, 0.3)
		else
			self.ManaLevel:SetText()
			StopFlash(self)
		end
	end
end

local UpdateDruidMana = function(self)
	if self.unit ~= "player" then return end

	local num, str = UnitPowerType("player")
	if num ~= 0 then
		local min = UnitPower("player", 0)
		local max = UnitPowerMax("player", 0)

		local percMana = min / max * 100
		if percMana <= TukuiDB["unitframes"].lowThreshold then
			self.FlashInfo.ManaLevel:SetText("|cffaf5050"..tukuilocal.unitframes_ouf_lowmana.."|r")
			Flash(self.FlashInfo, 0.3)
		else
			self.FlashInfo.ManaLevel:SetText()
			StopFlash(self.FlashInfo)
		end

		if min ~= max then
			if self.Power.value:GetText() then
				self.DruidMana:SetPoint("LEFT", self.Power.value, "RIGHT", 1, 0)
				self.DruidMana:SetFormattedText("|cffD7BEA5-|r %d%%|r", floor(min / max * 100))
			else
				self.DruidMana:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 2, 2)
				self.DruidMana:SetFormattedText("%d%%", floor(min / max * 100))
			end
		else
			self.DruidMana:SetText()
		end

		self.DruidMana:SetAlpha(1)
	else
		self.DruidMana:SetAlpha(0)
	end
end

local UpdateCPoints = function(self, event, unit)
	if unit == PlayerFrame.unit and unit ~= self.CPoints.unit then
		self.CPoints.unit = unit
	end
end

local FormatCastbarTime = function(self, duration)
	if self.channeling then
		self.Time:SetFormattedText("%.1f ", duration)
	elseif self.casting then
		self.Time:SetFormattedText("%.1f ", self.max - duration)
	end
end

local UpdateReputationColor = function(self, event, unit, bar)
	local name, id = GetWatchedFactionInfo()
	bar:SetStatusBarColor(FACTION_BAR_COLORS[id].r, FACTION_BAR_COLORS[id].g, FACTION_BAR_COLORS[id].b, 0.6)
end

local FormatTime = function(s)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", ceil(s / hour))
	elseif s >= hour then
		return format("%dh", ceil(s / hour))
	elseif s >= minute then
		return format("%dm", ceil(s / minute))
	elseif s >= minute / 12 then
		return floor(s)
	end
	return format("%.1f", s)
end

local Createauratimer = function(self,elapsed)
	if self.timeLeft then
		self.elapsed = (self.elapsed or 0) + elapsed
		if self.elapsed >= 0.1 then
			if not self.first then
				self.timeLeft = self.timeLeft - self.elapsed
			else
				self.timeLeft = self.timeLeft - GetTime()
				self.first = false
			end
			if self.timeLeft > 0 then
				local time = FormatTime(self.timeLeft)
				self.remaining:SetText(time)
				self.remaining:SetTextColor(0.84, 0.75, 0.65)
			else
				self.remaining:Hide()
				self:SetScript("OnUpdate", nil)
			end
			self.elapsed = 0
		end
	end
end

local CancelAura = function(self, button)
	if button == "RightButton" and not self.debuff then
		CancelUnitBuff("player", self:GetID())
	end
end

local function createAura(self, button, icons)
	icons.showDebuffType = true

	button.remaining = SetFontString(button, TukuiDB["media"].pixelfont, 8, "OUTLINE")
	button.remaining:SetPoint("CENTER", 0.2, 1)
	
	button.cd.noOCC = true		 	-- hide OmniCC CDs
	button.cd.noCooldownCount = true	-- hide CDC CDs
	button.count:SetFont(TukuiDB["media"].pixelfont, 8, "OUTLINE")
	button.count:ClearAllPoints()
	button.count:SetPoint("BOTTOMRIGHT", 0, 2)
	button.icon:SetTexCoord(.1, .9, .1, .9)
	button.icon:SetPoint("TOPLEFT", button,1,-1)
	button.icon:SetPoint("BOTTOMRIGHT", button,-1,1)
	button.icon:SetDrawLayer("ARTWORK")
	button.overlay:SetTexture(nil)
		
	if TukuiDB["unitframes"].auraspiral == true then
		icons.disableCooldown = false
		button.cd:SetReverse()
		button.overlayFrame = CreateFrame("frame", nil, button, nil)
		button.cd:SetFrameLevel(button:GetFrameLevel() + 1)
		button.cd:ClearAllPoints()
		button.cd:SetPoint("TOPLEFT", button, "TOPLEFT")
		button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
		button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)
		   
		button.overlay:SetParent(button.overlayFrame)
		button.count:SetParent(button.overlayFrame)
		button.remaining:SetParent(button.overlayFrame)
	else
		icons.disableCooldown = true
	end
	
	if self.unit == "player" then
		button:SetScript("OnMouseUp", CancelAura)
	end
			
	button.glow = CreateFrame ("Frame",nil,button)
	button.glow:SetPoint("TOPLEFT",-3,3)
	button.glow:SetFrameLevel(0)
	button.glow:SetPoint("BOTTOMRIGHT",3,-3)
	button.glow:SetBackdrop ( {
		bgfile = blank,
	  edgeFile = glowTex, 
	  edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }
	})
	button.glow = TukuiDB:mkButton(button.glow)
	button.glow:SetBackdropBorderColor(unpack(unitshadowcolor))
	button.glow:SetBackdropColor(unpack(unitcolor))
end

local function updatedebuff(self, icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

	if(icon.debuff) then
		if(not UnitIsFriend("player", unit) and icon.owner ~= "player" and icon.owner ~= "vehicle") then
			icon:SetBackdropBorderColor(unpack(TukuiDB["media"].bordercolor))
			icon.icon:SetDesaturated(true)
		else
			icon.glow:SetBackdropBorderColor(icon.overlay:GetVertexColor())
			icon.glow:SetBackdropColor(icon.overlay:GetVertexColor())
			icon.glow.top:SetTexture(icon.overlay:GetVertexColor())
			icon.glow.bottom:SetTexture(icon.overlay:GetVertexColor())
			icon.glow.left:SetTexture(icon.overlay:GetVertexColor())
			icon.glow.right:SetTexture(icon.overlay:GetVertexColor())
			icon.icon:SetDesaturated(false)
		end
	end
	
	if(icon.debuff) then		
		if duration and duration > 0 then
			if TukuiDB["unitframes"].auratimer == true then
				icon.remaining:Show()
			else
				icon.remaining:Hide()
			end
		else
			icon.remaining:Hide()
		end
	else
		icon.remaining:Hide()
	end
 
	icon.duration = duration
	icon.timeLeft = expirationTime
	icon.first = true
	icon:SetScript("OnUpdate", Createauratimer)
end
 
local HidePortrait = function(self, unit)
	if self.unit == "target" then
		if not UnitExists(self.unit) or not UnitIsConnected(self.unit) or not UnitIsVisible(self.unit) then
			self.Portrait:SetAlpha(0)
		else
			self.Portrait:SetAlpha(1)
		end
	end
end

local function ShowThreat(self, event, unit)
	if (self.unit ~= unit) then 
		return 
	end
	local status = UnitThreatSituation(unit)
	if status and status > 1 then
		r, g, b = GetThreatStatusColor(status)
		if unit == "player" then
			Halp:Show()
			Halp.pulse:Play()
			self.Health.value:SetTextColor(r, g, b)
		end	
	else
		if unit == "player" then
			Halp:Hide()
			self.Health.value:SetTextColor(r, g, b)
		end	
	end
end

local PostUpdateCast = function (self, event, unit)
	if unit ~= "player" then
		if self.Castbar then
			if self.Castbar.interrupt then
				self.Castbar:SetStatusBarColor(1, 0.3, 0, 1)
			else
				self.Castbar:SetStatusBarColor(0.91, 0.05, 0.03, 1)
			end
		end
	end	
end

local SpellCastInterruptable = function(self, event, unit)
	if self.unit ~= unit then return end
	if unit ~= "player" then
		if self.Castbar then
			if event == 'UNIT_SPELLCAST_NOT_INTERRUPTABLE' then
				self.Castbar:SetStatusBarColor(1, 0, 1, 1)
			else
				self.Castbar:SetStatusBarColor(0.91, 0.05, 0.03, 1)
			end
		end
	end	
end

local function fixStatBar(bar)
	bar:GetStatusBarTexture():SetHorizTile(false)
end


------------------------------------------------------------------------
--	Layout Style
------------------------------------------------------------------------

local SetStyle = function(self, unit)
	self.menu = menu
	self.disallowVehicleSwap = true
	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)
	self:SetScale(1)
	self:RegisterForClicks"anyup"
	self:SetAttribute("*type2", "menu")
	self:SetFrameStrata("LOW") 
	---/styling framebackdrop
	self:SetBackdrop( {
		bgFile = blank,
		edgeFile = glowTex,
		edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }}) 
	self:SetBackdropBorderColor(unpack(unitshadowcolor))
	self:SetBackdropColor(0,0,0,1)

	---/making portrait
	self.Portrait = CreateFrame("PlayerModel", nil, self)
	self.Portrait:SetAlpha(1)
	if unit == "target" then
		self.Portrait:SetHeight(39)
		self.Portrait:SetWidth(58)
		self.Portrait:SetPoint("TOPLEFT",TukuiDB:Scale(4),TukuiDB:Scale(-6))
	elseif unit == "focus" then
		self.Portrait:SetHeight(23)
		self.Portrait:SetWidth(30)
		self.Portrait:SetPoint("TOPRIGHT",TukuiDB:Scale(-4),TukuiDB:Scale(-6))
	end
	self.Portrait:SetFrameLevel(4)
	self.Portrait.bg = CreateFrame("Frame",nil,self.Portrait)
	self.Portrait.bg:SetPoint("TOPLEFT", -2, 2)
	self.Portrait.bg:SetPoint("BOTTOMRIGHT", 1, 0)
	self.Portrait.bg = TukuiDB:mkButton(self.Portrait.bg,-1)
	self.Portrait.bg.bg:SetGradientAlpha("VERTICAL",.1,.1,.1,0,.1,.1,.1,.5)
	self.Portrait.bg:SetBackdrop( {
		edgeFile = glowTex,
		edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }})
	self.Portrait.bg:SetAlpha(1)
	self.Portrait.bg:SetFrameLevel(3)
	---/Portrait color class wallpaper/---
	self.portraitWall = self.Portrait.bg:CreateTexture(nil, "ARTWORK")
	self.portraitWall:SetTexture(iamwallpaper, true)
	self.portraitWall:SetAllPoints(self.Portrait.bg)

	---/making healthbar bg
	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetStatusBarTexture(normTex)
	if unit == "player" or unit == "pet" or unit == "targettarget" then
		self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", TukuiDB:Scale(5), TukuiDB:Scale(-5))
		self.Health:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", TukuiDB:Scale(-5), TukuiDB:Scale(18))
	elseif unit == "target" then 
		self.portraitWall:SetTexCoord(0,0.5,0,0.5)
		self.Health:SetPoint("TOPRIGHT", self, "TOPRIGHT", TukuiDB:Scale(-5), TukuiDB:Scale(-5))
		self.Health:SetPoint("BOTTOMLEFT", self.Portrait, "BOTTOMRIGHT", TukuiDB:Scale(3), TukuiDB:Scale(12))
	elseif (unit and unit:find("arena%d")) then
		self.Health:SetPoint("TOPLEFT", 4, -4)
		self.Health:SetPoint("BOTTOMRIGHT", -12, 4)
	elseif unit == "focus" then
		self.portraitWall:SetTexCoord(0,0.5,0,0.5)
		self.Health:SetPoint("TOPLEFT", self, "TOPLEFT", TukuiDB:Scale(5), TukuiDB:Scale(-5))
		self.Health:SetPoint("BOTTOMRIGHT", self.Portrait, "BOTTOMLEFT", TukuiDB:Scale(-2), TukuiDB:Scale(1))
	else
		self.Health:SetPoint("TOPLEFT", 4, -4)
		self.Health:SetPoint("BOTTOMRIGHT", -4, 8)
	end

	if TukuiDB["unitframes"].gridhealthvertical == true then
		self.Health:SetOrientation('VERTICAL')
	end
	self.Health:SetStatusBarColor(0.25,0.25,0.25)
	self.Health.bg = self.Health:CreateTexture(nil, 'BORDER')
	self.Health.bg:SetPoint("TOPLEFT", self.Health, "TOPLEFT")
	self.Health.bg:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT")
	self.Health.bg:SetTexture(TukuiDB["media"].barTex3)
	self.Health.bg.multiplier = 0.2
					
	-- healthbar functions
	self.Health.colorDisconnected = true
	self.Health.colorSmooth = true
	self.Health.Smooth = true
	-- healthbar text
	self.Health.value = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.value:SetShadowOffset(1, -1)
	self.Health.value:SetFont(font, 11, "OUTLINE")
		
	---/Powerbar/---
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetStatusBarTexture(normTex)
	if unit == "player" or unit == "pet" or unit == "targettarget" then
		self.Power:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT", TukuiDB:Scale(5),TukuiDB:Scale(5))
		self.Power:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT", TukuiDB:Scale(-5),TukuiDB:Scale(5))
		self.Power:SetHeight(TukuiDB:Scale(10))
	elseif unit == "target" then
		self.Power:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT", TukuiDB:Scale(65),TukuiDB:Scale(5))
		self.Power:SetPoint("BOTTOMRIGHT",self,"BOTTOMRIGHT", TukuiDB:Scale(-5),TukuiDB:Scale(5))
		self.Power:SetHeight(TukuiDB:Scale(10))
	elseif (unit and unit:find("arena%d")) then
		self.Power:SetPoint("BOTTOMLEFT",self.Health,"BOTTOMRIGHT", 0,TukuiDB:Scale(1))
		self.Power:SetPoint("TOPLEFT",self.Health,"TOPRIGHT", 0,TukuiDB:Scale(-1))
		self.Power:SetWidth(TukuiDB:Scale(8))
	elseif unit == "focus" then
		self.Power:SetPoint("BOTTOMLEFT",self,"BOTTOMLEFT", TukuiDB:Scale(5),TukuiDB:Scale(5))
		self.Power:SetPoint("TOPRIGHT",self.Health,"BOTTOMRIGHT", TukuiDB:Scale(-1),TukuiDB:Scale(-1))
	else
		self.Power:SetPoint("TOPRIGHT",self.Health,"BOTTOMRIGHT", 0,TukuiDB:Scale(-1))
		self.Power:SetPoint("TOPLEFT",self.Health,"BOTTOMLEFT", 0,TukuiDB:Scale(-1))
		self.Power:SetHeight(TukuiDB:Scale(4))
	end
	self.Power:SetFrameLevel(16)
	self.Power.bg = self.Power:CreateTexture(nil, 'BORDER')
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(TukuiDB["media"].barTex3)
	self.Power:SetStatusBarColor(0.15,0.15,0.15)	
	self.Power.bg:SetVertexColor(0.08, 0.08, 0.08)
	-- powerbar text
	self.Power.value = self.Power:CreateFontString(nil, "OVERLAY")
	self.Power.value:SetShadowOffset(1, -1)
	
	self.Power.value:SetFont(font, 11, "OUTLINE")
	-- powerbar functions
	
	self.Power.frequentUpdates = true
	self.Power.Smooth = true
	self.Power.colorSmooth = true
	self.Power.value = SetFontString(self.Power, font, (unit == "player" or unit == "target") and 12 or 12)
	------------------------------------------------------------------------
	--	Panels, text infos and Background!
	------------------------------------------------------------------------
	
	if unit == "player" then
		local Halp = CreateFrame("Frame", "Halp", UIParent)
		TukuiDB:CreatePanel(Halp, TukuiDB:Scale(80), TukuiDB:Scale(80), "BOTTOM", self, "TOPLEFT", TukuiDB:Scale(8), TukuiDB:Scale(8), 1)
		Halp:SetBackdrop{
			bgFile = TukuiDB["media"].alert, 
			tile = false}
		Halp:SetBackdropBorderColor(0,0,0,0)
		Halp:SetFrameStrata("HIGH")
		TukuiDB:SetPulse(Halp, 0, 1)
		Halp:Hide()
		Halp:SetScript("OnShow", function(self) if not Halp.pulse:IsPlaying() then Halp.pulse:Play() end end)

		self.panel = CreateFrame("Frame", nil, MainPanel)
		TukuiDB:CreatePanel(self.panel, 1, MainPanel:GetHeight(), "CENTER", MainPanel, "CENTER", 0, 0, 5)
		self.panel:SetPoint("TOPLEFT", MainPanel, "TOPLEFT", 0, 0)
		self.panel:SetPoint("BOTTOMRIGHT", MainPanel, "BOTTOMRIGHT", 0, 0)
		self.Health.value = SetFontString(self.Health, font3, 8, nil, 3)
		self.Health.value:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -2, 2)
		self.Power.value = SetFontString(self.Health, font3, 8)
		self.Power.value:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 2, 2)
--		self:Tag(self.Health, "[curhp][threatcolor]")
	elseif unit == "target" then
		self.panel = CreateFrame ("Frame",nil,self)
		TukuiDB:CreatePanel(self.panel, 100, 10, "CENTER", AlignThis, "CENTER", TukuiDB:Scale(8), 68, 5) 
		self.panel:SetFrameStrata("BACKGROUND")
		self.Health.value = SetFontString(self.Health, font3, 8)
		self.Health.value:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", 2, 2)
		self.Info = SetFontString(self.Health, font, 8, nil, 3)
		self.Info:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT", -2, 2)
		self:Tag(self.Info, "[NameLong] [DiffColor][level] [shortclassification]")
	elseif (unit and unit:find("arena%d")) then
		self.Health.value:Hide()
		self.Power.value:Hide()
		self.panel = CreateFrame ("Frame",nil,self)
		TukuiDB:CreatePanel(self.panel, 168, 10, "CENTER", self.Health, "TOP", 0, TukuiDB:Scale(2), 5) 
		self.Info = SetFontString(self.Health, font, 10)
		self.Info:SetPoint("RIGHT", self.panel, "RIGHT", 0, TukuiDB:Scale(2))
		self:Tag(self.Info, "[GetNameColor][NameShort]")
	elseif (unit and unit:find("boss%d")) then
		self.Health.value = SetFontString(self.Health, font, 10)
		self.Health.value:SetPoint("RIGHT", -6, 1)
		self.Info = SetFontString(self.Health, font, 10)
		self.Info:SetPoint("LEFT", 6, 1)
		self:Tag(self.Info, "[GetNameColor][NameLong]")
	elseif (self:GetParent():GetName():match"oUF_MainTank" or self:GetParent():GetName():match"oUF_MainAssist") then
		self.Info = SetFontString(self.Health, font, 10)
		self.Info:SetPoint("CENTER", 0, 1)
		self:Tag(self.Info, "[GetNameColor][NameTiny]")
	elseif unit == "focus" then
		self.panel = CreateFrame ("Frame",nil,self)
		TukuiDB:CreatePanel(self.panel, 160, 10, "BOTTOMLEFT", self.Health, "BOTTOMLEFT", 4, 4, 5) 
		self.Health.value = SetFontString(self.panel, font3, 9, "OUTLINE")
		self.Health.value:SetPoint("BOTTOMRIGHT", self.panel, 6, 4)
		self.Power.value:Hide()
		self.Info = SetFontString(self.Health, font, 10)
		self.Info:SetPoint("LEFT", self.panel)
		self:Tag(self.Info, "[GetNameColor][NameMedium]")
	elseif unit == "pet" then
		self.Health.value:Hide()
		self.Power.value:Hide()
		self.panel = CreateFrame ("Frame",nil,self)
		TukuiDB:CreatePanel(self.panel, 50, 12, "BOTTOM", self.Health, "BOTTOM", 0, 2, 5) 
		self.Info = SetFontString(self.Health, font, 10, nil, 2)
		self.Info:SetPoint("CENTER", self.panel)
		self:Tag(self.Info, "[GetNameColor][NameTiny]")
	else
		self.Health.value:Hide()
		self.Power.value:Hide()
		self.panel = CreateFrame ("Frame",nil,self)
		TukuiDB:CreatePanel(self.panel, 50, 12, "BOTTOM", self.Health, "BOTTOM", 0, 2, 5) 
		self.Info = SetFontString(self.Health, font, 10, nil, 2)
		self.Info:SetPoint("CENTER", self.panel)
		self:Tag(self.Info, "[NameTiny]")
	end

	
	if unit == "player" then	
		self.Combat = self.Health:CreateTexture(nil, "OVERLAY")
		self.Combat:SetHeight(19)
		self.Combat:SetWidth(19)
		self.Combat:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
		self.Combat:SetVertexColor(0.69, 0.31, 0.31)

		self.FlashInfo = CreateFrame("Frame", "FlashInfo", self)
		self.FlashInfo:SetScript("OnUpdate", UpdateManaLevel)
		self.FlashInfo.parent = self
		self.FlashInfo:SetToplevel(true)
		self.FlashInfo:SetAllPoints(self.panel)

		self.FlashInfo.ManaLevel = SetFontString(self.FlashInfo, font3, 34, "THICKOUTLINE")
		self.FlashInfo.ManaLevel:SetPoint("CENTER", UIParent, "CENTER", 0, -102)
				
		self.Status = SetFontString(self.panel, font, 12)
		self.Status:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT")
		self.Status:SetTextColor(0.69, 0.31, 0.31, 0)
		self:Tag(self.Status, "[pvp]")
	
		self:SetScript("OnEnter", function(self) self.FlashInfo.ManaLevel:Hide() self.Status:SetAlpha(1); UnitFrame_OnEnter(self) end)
		self:SetScript("OnLeave", function(self) self.FlashInfo.ManaLevel:Show() self.Status:SetAlpha(0); UnitFrame_OnLeave(self) end)

		------------------------------------------------------------------------
		--	Runes 
		------------------------------------------------------------------------	
	
		if class == "DEATHKNIGHT" and TukuiDB["unitframes"].runebar == true then
			self.Runes = CreateFrame("Frame", nil, self)
			self.Runes:SetPoint("BOTTOMLEFT",self,"TOPLEFT",TukuiDB:Scale(5),TukuiDB:Scale(-2))
			self.Runes:SetPoint("TOPRIGHT",self,"TOPRIGHT",TukuiDB:Scale(-5),TukuiDB:Scale(2))
			self.Runes:SetBackdrop(backdrop)
			self.Runes:SetBackdropColor(0, 0, 0)
			self.Runes.anchor = "TOPLEFT"
			self.Runes.growth = "RIGHT"
			self.Runes.height = TukuiDB:Scale(4)
			self.Runes.spacing = 2
			self.Runes.width = (152 / 6)

			for i = 1, 6 do
				self.Runes[i] = CreateFrame('StatusBar', nil, self.Runes)
				self.Runes[i]:SetStatusBarTexture(blank)
				self.Runes[i]:SetStatusBarColor(unpack(runeloadcolors[i]))
			end
			
			self.Runes.FrameBackdrop = CreateFrame("Frame", nil, self.Runes)
			self.Runes.FrameBackdrop:SetPoint("TOPLEFT", self.Runes, "TOPLEFT", -5, 3)
			self.Runes.FrameBackdrop:SetPoint("BOTTOMRIGHT", self.Runes, "BOTTOMRIGHT", 5, -3)
			self.Runes.FrameBackdrop:SetFrameStrata("BACKGROUND")
			self.Runes.FrameBackdrop:SetBackdrop {
				edgeFile = glowTex, edgeSize = 5,
				insets = {left = 3, right = 3, top = 3, bottom = 3}
			}
			self.Runes.FrameBackdrop:SetBackdropColor(0, 0, 0, 1)
			self.Runes.FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
		end

		------------------------------------------------------------------------
		--	Extra condition (druid mana in cat and bear form)
		------------------------------------------------------------------------

		if class == "DRUID" then
			CreateFrame("Frame"):SetScript("OnUpdate", function() UpdateDruidMana(self) end)
			self.DruidMana = SetFontString(self.Health, font, 12)
			self.DruidMana:SetTextColor(1, 0.49, 0.04)
		end
	end

	------------------------------------------------------------------------
	--	Experience / reputation
	------------------------------------------------------------------------	

	if unit == "player" then
			self.Experience = CreateFrame("StatusBar", self:GetName().."_Experience", self)
			self.Experience:SetStatusBarTexture(blank)
			self.Experience:SetStatusBarColor(0, 0.4, 1, 1)
			self.Experience:SetBackdrop( {
				bgFile = blank,
				edgeFile = glowTex,
				edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 }}) 
			self.Experience:SetBackdropColor(unpack(unitcolor))
			self.Experience:SetBackdropBorderColor(unpack(unitshadowcolor))
			self.Experience:SetPoint("TOPLEFT", self.Power, "TOPLEFT")
			self.Experience:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT")
			self.Experience:SetFrameStrata("HIGH")
			self.Experience:SetAlpha(0)
			
			self.Experience:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
			self.Experience:HookScript("OnLeave", function(self) self:SetAlpha(0) end)

			self.Experience.Tooltip = true
			
			if unit == "player" and UnitLevel("player") ~= MAX_PLAYER_LEVEL then			
				self.Experience.Rested = CreateFrame('StatusBar', nil, self)
				self.Experience.Rested:SetParent(self.Experience)
				self.Experience.Rested:SetAllPoints(self.Experience)
				self.Resting = self.Experience:CreateTexture(nil, "OVERLAY")
				self.Resting:SetHeight(18)
				self.Resting:SetWidth(18)
				self.Resting:SetPoint("BOTTOMLEFT", self, "TOPLEFT")
				self.Resting:SetTexture([=[Interface\CharacterFrame\UI-StateIcon]=])
				self.Resting:SetTexCoord(0, 0.5, 0, 0.5)
			end
	end

	if unit == "player" then
		if UnitLevel("player") == MAX_PLAYER_LEVEL then
			self.Reputation = CreateFrame("StatusBar", self:GetName().."_Reputation", self)
			self.Reputation:SetStatusBarTexture(blank)
			self.Reputation:SetBackdrop( {
				bgFile = blank,
				edgeFile = glowTex,
				edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 }})
			self.Reputation:SetBackdropColor(unpack(unitcolor))
			self.Reputation:SetBackdropBorderColor(unpack(unitshadowcolor))
			self.Reputation:SetPoint("TOPLEFT", self.Power, "TOPLEFT")
			self.Reputation:SetPoint("BOTTOMRIGHT", self.Power, "BOTTOMRIGHT")
			self.Reputation:SetFrameStrata("HIGH")
			self.Reputation:SetAlpha(0)

			fixStatBar(self.Reputation)
			self.Reputation:HookScript("OnEnter", function(self) self:SetAlpha(1) end)
			self.Reputation:HookScript("OnLeave", function(self) self:SetAlpha(0) end)

			self.Reputation.PostUpdate = UpdateReputationColor
			self.Reputation.Tooltip = true
		end
	end
	
	------------------------------------------------------------------------
	--   Totems
	------------------------------------------------------------------------   

    if class == "SHAMAN" and unit == "player" and TukuiDB["unitframes"].totembar == true then
        self.TotemBar = {}
		self.TotemBar.Destroy = true
            for i = 1, 4 do
                self.TotemBar[i] = CreateFrame("StatusBar", self:GetName().."_TotemBar"..i, self)
				if (i == 1) then
                   self.TotemBar[i]:SetPoint("BOTTOMLEFT", self, "TOPLEFT", TukuiDB:Scale(4), -1)
                else
                   self.TotemBar[i]:SetPoint("TOPLEFT", self.TotemBar[i-1], "TOPRIGHT", 1, 0)
                end
                self.TotemBar[i]:SetStatusBarTexture(blank)
                self.TotemBar[i]:SetHeight(TukuiDB:Scale(4))
                self.TotemBar[i]:SetWidth(TukuiDB:Scale(162) / 4)
                self.TotemBar[i]:SetBackdrop(backdrop)
                self.TotemBar[i]:SetBackdropColor(0, 0, 0)
                self.TotemBar[i]:SetMinMaxValues(0, 1)

                self.TotemBar[i].bg = self.TotemBar[i]:CreateTexture(nil, "BORDER")
                self.TotemBar[i].bg:SetAllPoints(self.TotemBar[i])
                self.TotemBar[i].bg:SetTexture(blank)
                self.TotemBar[i].bg.multiplier = 0.6
                				
				self.TotemBar[i].FrameBackdrop = CreateFrame("Frame", nil, self.TotemBar[i])
				self.TotemBar[i].FrameBackdrop:SetPoint("TOPLEFT", self.TotemBar[i], "TOPLEFT", -3, 3)
				self.TotemBar[i].FrameBackdrop:SetPoint("BOTTOMRIGHT", self.TotemBar[i], "BOTTOMRIGHT", 3, -3)
				self.TotemBar[i].FrameBackdrop:SetFrameStrata("BACKGROUND")
				self.TotemBar[i].FrameBackdrop:SetBackdrop {
					edgeFile = glowTex, edgeSize = 4,
					insets = {left = 3, right = 3, top = 3, bottom = 3}
				}
				self.TotemBar[i].FrameBackdrop:SetBackdropColor(0, 0, 0, 0)
				self.TotemBar[i].FrameBackdrop:SetBackdropBorderColor(0, 0, 0)
            end
    end

	------------------------------------------------------------------------
	--   Threat Bar (this idea is from Zakriel)
	------------------------------------------------------------------------
	
	if (TukuiDB["unitframes"].showthreat == true) then
	   if (unit == "player") then 
				self.ThreatBar = CreateFrame("StatusBar", self:GetName()..'_ThreatBar', self)
				self.ThreatBar:SetStatusBarTexture(TukuiDB["media"].blank)
				self.ThreatBar:SetBackdrop( {
					bgFile = blank,
					edgeFile = glowTex,
					edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 }}) 
				self.ThreatBar:SetBackdropColor(unpack(unitcolor))
				self.ThreatBar:SetBackdropBorderColor(unpack(unitshadowcolor))
				self.ThreatBar:SetWidth(TukuiDB:Scale(62))
				self.ThreatBar:SetHeight(TukuiDB:Scale(10))
				self.ThreatBar:SetPoint("CENTER", TarThreat)

				self.ThreatBar:SetFrameStrata("HIGH")
				fixStatBar(self.ThreatBar)
				
				self.ThreatBar.Text = SetFontString(self.ThreatBar, font, 10, "OUTLINE")
				self.ThreatBar.Text:SetPoint("TOPRIGHT", self.ThreatBar, "TOPLEFT", -4, 0)
				self.ThreatBar.Text:SetTextColor(0,0,0,0)
				self.ThreatBar.bg = CreateFrame ("Frame",nil,self.ThreatBar)
				self.ThreatBar.bg:SetAllPoints(self.ThreatBar)
				TukuiDB:mkButton(self.ThreatBar.bg,-1)
				
				self.ThreatBar.useRawThreat = false
	   end
	end
	------------------------------------------------------------------------
	--	Auras
	------------------------------------------------------------------------	
	
	if unit == "player" or unit == "focus" or unit == "target" or unit == "targettarget" or (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
		self.Debuffs = CreateFrame("Frame", nil, self)
		self.Debuffs:SetHeight(50)
		self.Debuffs:SetWidth(150)
		self.Debuffs.size = 23
		self.Debuffs.spacing = 2
		self.Debuffs.num = 6
		self.Debuffs.numDebuffs = 6

		self.Buffs = CreateFrame("Frame", nil, self)		
		self.Buffs:SetHeight(46)
		self.Buffs:SetWidth(168)
		self.Buffs.size = 18
		self.Buffs.spacing = 2
		self.Buffs.num = 0
		self.Buffs.numBuffs = 0
		
			if (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
				if (unit and unit:find("boss%d")) then
					self.Buffs:SetPoint("LEFT", self, "RIGHT", 34, 0)
					self.Buffs.size = 26
					self.Buffs.num = 4
					self.Buffs.numBuffs = 3
					self.Buffs.initialAnchor = "LEFT"
					self.Buffs["growth-x"] = "RIGHT"
				end
				self.Debuffs.num = 0
				self.Debuffs.size = 36
				self.Debuffs:SetPoint("LEFT", self.Buffs, "RIGHT", 4, -1)
				self.Debuffs.initialAnchor = "LEFT"
				self.Debuffs["growth-x"] = "RIGHT"
				self.Debuffs["growth-y"] = "DOWN"
				self.Debuffs:SetHeight(40)
				self.Debuffs:SetWidth(160)
				self.Debuffs.onlyShowPlayer = TukuiDB["unitframes"].playerdebuffsonly
			end	
						
			if unit == "focus" and TukuiDB["unitframes"].focusdebuffs == true then
				self.Debuffs:SetHeight(112)
				self.Debuffs:SetWidth(164)
				self.Debuffs.size = 26
				self.Debuffs.spacing = 2
				self.Debuffs.num = 40
				self.Debuffs.numDebuffs = 40
							
				self.Debuffs:SetPoint("TOPRIGHT", self, "TOPRIGHT", 2, 38)
				self.Debuffs.initialAnchor = "TOPRIGHT"
				self.Debuffs["growth-y"] = "UP"
				self.Debuffs["growth-x"] = "LEFT"
			end
			
			if unit == "player" and TukuiDB["unitframes"].playerauras == true then
				self.Debuffs:SetPoint("BOTTOMRIGHT", self, "TOPRIGHT", -4, 4)
				self.Debuffs.initialAnchor = "BOTTOMRIGHT"
				self.Debuffs["growth-y"] = "UP"
				self.Debuffs["growth-x"] = "LEFT"
				self.Debuffs.num = 6		
				self.Debuffs.numDebuffs = 6
			end
			
			if unit == "target" and TukuiDB["unitframes"].targetauras == true then
				self.Buffs:SetPoint("LEFT", self, "RIGHT", 2, 0)
				self.Buffs.initialAnchor = "TOPLEFT"
				self.Buffs["growth-y"] = "UP"
				self.Buffs["growth-x"] = "RIGHT"
				
				self.Debuffs:SetPoint("BOTTOMLEFT", self, "TOPLEFT", 64, 4)
				self.Debuffs.initialAnchor = "BOTTOMLEFT"
				self.Debuffs["growth-y"] = "UP"
				self.Debuffs["growth-x"] = "RIGHT"
				self.Debuffs.onlyShowPlayer = TukuiDB["unitframes"].playerdebuffsonly
				self.Debuffs.num = 6
				self.Debuffs.numDebuffs = 6
				self.CPoints = {}
				self.CPoints.unit = PlayerFrame.unit
				for i = 1, 5 do
					self.CPoints[i] = self.Health:CreateTexture(nil, "OVERLAY")
					self.CPoints[i]:SetHeight(35)
					self.CPoints[i]:SetWidth(35)
					self.CPoints[i]:SetTexture(bubbleTex)
					if i == 1 then
						self.CPoints[i]:SetPoint("CENTER", UIParent, "CENTER", 110, 20)
						self.CPoints[i]:SetVertexColor(0.69, 0.69, 0.69)
					else
						self.CPoints[i]:SetPoint("TOP", self.CPoints[i-1], "BOTTOM", 1)
					end
				end
				self.CPoints[2]:SetVertexColor(0.69, 0.69, 0.69)
				self.CPoints[3]:SetVertexColor(0.65, 0.63, 0.35)
				self.CPoints[4]:SetVertexColor(0.65, 0.63, 0.35)
				self.CPoints[5]:SetVertexColor(0.33, 0.59, 0.33)
				self:RegisterEvent("UNIT_COMBO_POINTS", UpdateCPoints)
			end
	end

	------------------------------------------------------------------------
	--	Castbar
	------------------------------------------------------------------------	

	if TukuiDB["unitframes"].unitcastbar == true then
		if unit == "player" then
			local cbwide = TukuiDB:Scale(260)
			local cbtall = TukuiDB:Scale(28)
			self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", UIParent)
			self.Castbar:SetStatusBarTexture(castb2)
			self.Castbar:SetHeight(cbtall * 2)
			self.Castbar:SetWidth(cbwide - TukuiDB:Scale(28))
			self.Castbar:SetPoint("CENTER", MainPanel, "CENTER", TukuiDB:Scale(14), 0)
			self.Castbar:SetFrameStrata("DIALOG")
			local cbfg = CreateFrame("Frame", nil, self.Castbar)
			TukuiDB:CreatePanel(cbfg, cbwide, (cbtall + 2), "CENTER", self.Castbar, "CENTER", TukuiDB:Scale(-14), 0, 1)
			cbfg:SetBackdropColor(0, 0, 0, 0)
			cbfg:SetBackdropBorderColor(0, 0, 0, 1)
			cbfg:SetFrameStrata("DIALOG")
			local cbbg = CreateFrame("Frame", nil, self.Castbar)
			TukuiDB:CreatePanel(cbbg, cbwide, (cbtall + 2), "CENTER", self.Castbar, "CENTER", TukuiDB:Scale(-14), 0, 2)
			cbbg:SetBackdropBorderColor(0, 0, 0, 0)
			cbbg:SetBackdropColor(0.1, 0.1, 0.3, 0.5)
			cbbg:SetFrameStrata("DIALOG")
			fixStatBar(self.Castbar)
			self.Castbar.Spark = self.Castbar:CreateTexture(nil, 'OVERLAY')
			self.Castbar.Spark:SetHeight(52)
			self.Castbar.Spark:SetWidth(25)
			self.Castbar.Spark:SetBlendMode('ADD')
		elseif unit == "target" then
			--PLAYER MAIN PANEL
			local tarbox = CreateFrame("Frame", "TargetCB", UIParent)
			TukuiDB:CreatePanel(tarbox, TukuiDB:Scale(250), TukuiDB:Scale(30), "BOTTOM",AlignThis,"TOP",0,TukuiDB:Scale(90),5)
			tarbox:SetFrameStrata("BACKGROUND")
			local tcbwide = (TukuiDB:Scale(260))
			local tcbtall = TukuiDB:Scale(28)
			self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			self.Castbar:SetStatusBarTexture(castb)
			self.Castbar:SetHeight(tcbtall * 2)
			self.Castbar:SetWidth(tcbwide - TukuiDB:Scale(28))
			self.Castbar:SetStatusBarColor(1, 0, 0, 0.9)
			self.Castbar:SetPoint("CENTER", TargetCB, "CENTER", TukuiDB:Scale(14), 0)
			self.Castbar:SetFrameStrata("DIALOG")
			
			local tcbfg = CreateFrame("Frame", nil, self.Castbar)
			TukuiDB:CreatePanel(tcbfg, tcbwide, (tcbtall + 2), "CENTER", self.Castbar, "CENTER", TukuiDB:Scale(-14), 0, 1)
			tcbfg:SetBackdropColor(0, 0, 0, 0)
			tcbfg:SetBackdropBorderColor(0, 0, 0, 1)
			tcbfg:SetFrameStrata("DIALOG")
			local tcbbg = CreateFrame("Frame", nil, self.Castbar)
			TukuiDB:CreatePanel(tcbbg, tcbwide, (tcbtall + 2), "CENTER", self.Castbar, "CENTER", TukuiDB:Scale(-14), 0, 2)
			tcbbg:SetBackdropColor(0.1, 0, 0, 0.3)
			tcbbg:SetBackdropBorderColor(0, 0, 0, 0)
			tcbbg:SetFrameStrata("DIALOG")
			fixStatBar(self.Castbar)
			self.Castbar.Spark = self.Castbar:CreateTexture(nil, 'OVERLAY')
			self.Castbar.Spark:SetHeight(52)
			self.Castbar.Spark:SetWidth(25)
			self.Castbar.Spark:SetBlendMode('ADD')
		elseif(unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
			self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			self.Castbar:SetStatusBarTexture(blank)
			self.Castbar:SetStatusBarColor(1, 0, 1, 1)
			self.Castbar:SetFrameLevel(6)
			self.Castbar:SetHeight(6)
			self.Castbar:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 0, -1)
			self.Castbar:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", 0, -1)
			fixStatBar(self.Castbar)
			self.Castbar.Spark = self.Castbar:CreateTexture(nil, 'OVERLAY')
			self.Castbar.Spark:SetHeight(35)
			self.Castbar.Spark:SetWidth(35)
			self.Castbar.Spark:SetBlendMode('ADD')
		else
			self.Castbar = CreateFrame("StatusBar", self:GetName().."_Castbar", self)
			self.Castbar:SetStatusBarTexture(blank)
			self.Castbar:SetStatusBarColor(1, 0, 1, 1)
			self.Castbar:SetFrameLevel(6)
			self.Castbar:SetHeight(6)
			self.Castbar:SetPoint("TOPLEFT", self, "BOTTOMLEFT", 0, -1)
			self.Castbar:SetPoint("TOPRIGHT", self, "BOTTOMRIGHT", 0, -1)
			fixStatBar(self.Castbar)
			self.Castbar.Spark = self.Castbar:CreateTexture(nil, 'OVERLAY')
			self.Castbar.Spark:SetHeight(35)
			self.Castbar.Spark:SetWidth(35)
			self.Castbar.Spark:SetBlendMode('ADD')
		end
		
		

		if unit == "player" or unit == "target" or (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
			if unit == "player" or unit == "target" then
				self.Castbar.Text = SetFontString(self.Castbar, font, 10)
				self.Castbar.Text:SetPoint("LEFT", self.Castbar, "LEFT", 4, 0)
				self.Castbar.Text:SetTextColor(1, 1, 1, 0.6)
			else
				self.Castbar.Time = SetFontString(self.Castbar, pixel, 8)
				self.Castbar.Time:SetPoint("RIGHT", -2, 0)
				self.Castbar.Time:SetTextColor(1, 1, 1, 0)
				self.Castbar.Time:SetJustifyH("RIGHT")
				self.Castbar.CustomTimeText = FormatCastbarTime

				self.Castbar.Text = SetFontString(self.Castbar, pixel, 8)
				self.Castbar.Text:SetPoint("RIGHT", self.Castbar, "LEFT", -4, 6)
				self.Castbar.Text:SetTextColor(1, 1, 1, 1)
			end
			
			if TukuiDB["unitframes"].cbicons == true then
				self.Castbar.Button = CreateFrame("Frame", nil, self.Castbar)
				self.Castbar.Button:SetHeight(TukuiDB:Scale(28))
				self.Castbar.Button:SetWidth(TukuiDB:Scale(28))
				TukuiDB:SetTemplate(self.Castbar.Button,4)
				self.Castbar.Button:SetFrameStrata("DIALOG")

				self.Castbar.timeButton = CreateFrame("Frame", nil, self.Castbar)
				self.Castbar.timeButton:SetHeight(TukuiDB:Scale(28))
				self.Castbar.timeButton:SetWidth(TukuiDB:Scale(28))
				TukuiDB:SetTemplate(self.Castbar.timeButton,4)
				self.Castbar.timeButton:SetFrameStrata("BACKGROUND")
				
				self.Castbar.Time = SetFontString(self.Castbar, font3, 9, "OUTLINE")
				self.Castbar.Time:SetPoint("CENTER", self.Castbar.timeButton, "CENTER")
				self.Castbar.Time:SetTextColor(1, 1, 1, 0.9)
				self.Castbar.CustomTimeText = FormatCastbarTime
				
				self.Castbar.Icon = self.Castbar.Button:CreateTexture(nil, "ARTWORK")
				self.Castbar.Icon:SetPoint("TOPLEFT", self.Castbar.Button, "TOPLEFT", 3, -4)
				self.Castbar.Icon:SetPoint("BOTTOMRIGHT", self.Castbar.Button, "BOTTOMRIGHT", -3, 4)
				self.Castbar.Icon:SetTexCoord(0.1, 0.9, 0.1, 0.9)
			
				if unit == "player" or unit == "target" then
					self.Castbar.Button:SetPoint("RIGHT", self.Castbar, "LEFT", 2, 0)
					self.Castbar.timeButton:SetPoint("RIGHT", MainPanel, "RIGHT")					
				end
			end
		end
		
		if unit == "player" and TukuiDB["unitframes"].cblatency == true then
			self.Castbar.SafeZone = self.Castbar:CreateTexture(nil, "ARTWORK")
			self.Castbar.SafeZone:SetTexture(normTex)
			self.Castbar.SafeZone:SetVertexColor(0.69, 0.31, 0.31, 0)
		end
		
		if unit == 'target' or unit == 'player' then
			self.PostCastStart = PostUpdateCast
			self.PostChannelStart = PostUpdateCast

			self:RegisterEvent('UNIT_SPELLCAST_INTERRUPTABLE', SpellCastInterruptable)
			self:RegisterEvent('UNIT_SPELLCAST_NOT_INTERRUPTABLE', SpellCastInterruptable)
		end
	end


    
	------------------------------------------------------------------------
	--	Raid or Party Leader
	------------------------------------------------------------------------

	if not unit or unit == "player" then
		self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
		self.Leader:SetHeight(14)
		self.Leader:SetWidth(14)
		self.Leader:SetPoint("TOPLEFT", 2, 8)
	end
		
	------------------------------------------------------------------------
	--      Master Looter
	------------------------------------------------------------------------

    if not unit or unit == "player" then
        self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
        self.MasterLooter:SetHeight(14)
        self.MasterLooter:SetWidth(14)
        local MLAnchorUpdate = function (self)
            if self.Leader:IsShown() then
                self.MasterLooter:SetPoint("TOPLEFT", 14, 8)
            else
                self.MasterLooter:SetPoint("TOPLEFT", 2, 8)
            end
        end
        self:RegisterEvent("PARTY_LEADER_CHANGED", MLAnchorUpdate)
        self:RegisterEvent("PARTY_MEMBERS_CHANGED", MLAnchorUpdate)
    end

	------------------------------------------------------------------------
	--      Combat Feedback Text
	------------------------------------------------------------------------
	
	if (unit == "player" or unit == "target") and (TukuiDB["unitframes"].combatfeedback == true) then
			self.CombatFeedbackText = SetFontString(self.Health, font, 14, "OUTLINE")
			self.CombatFeedbackText:SetPoint("CENTER", 0, 1)
			self.CombatFeedbackText.colors = {
				DAMAGE = {0.69, 0.31, 0.31},
				CRUSHING = {0.69, 0.31, 0.31},
				CRITICAL = {0.69, 0.31, 0.31},
				GLANCING = {0.69, 0.31, 0.31},
				STANDARD = {0.84, 0.75, 0.65},
				IMMUNE = {0.84, 0.75, 0.65},
				ABSORB = {0.84, 0.75, 0.65},
				BLOCK = {0.84, 0.75, 0.65},
				RESIST = {0.84, 0.75, 0.65},
				MISS = {0.84, 0.75, 0.65},
				HEAL = {0.33, 0.59, 0.33},
				CRITHEAL = {0.33, 0.59, 0.33},
				ENERGIZE = {0.31, 0.45, 0.63},
				CRITENERGIZE = {0.31, 0.45, 0.63},
			}
	end
	------------------------------------------------------------------------
	--	Arena Trinket
	------------------------------------------------------------------------

	if TukuiDB["arena"].unitframes == true then
		if not IsAddOnLoaded("Gladius") then
			if (unit and unit:find('arena%d') and (not unit:find("arena%dtarget"))) then
				self.Trinketbg = CreateFrame("Frame", nil, self)
				self.Trinketbg:SetHeight(32)
				self.Trinketbg:SetWidth(32)
				self.Trinketbg:SetPoint("LEFT", self, "RIGHT", 0, 0)				
				TukuiDB:SetTemplate(self.Trinketbg)
				self.Trinketbg:SetFrameLevel(0)
				
				self.Trinket = CreateFrame("Frame", nil, self.Trinketbg)
				self.Trinket:SetAllPoints(self.Trinketbg)
				self.Trinket:SetPoint("TOPLEFT", self.Trinketbg, TukuiDB:Scale(2), TukuiDB:Scale(-2))
				self.Trinket:SetPoint("BOTTOMRIGHT", self.Trinketbg, TukuiDB:Scale(-2), TukuiDB:Scale(2))
				self.Trinket:SetFrameLevel(1)
				self.Trinket.trinketUseAnnounce = true
			end
		end
	end
	
	------------------------------------------------------------------------
	--	Unitframes Width/Height
	------------------------------------------------------------------------

	--self:SetFrameLevel(0)
	if unit=="player" then
	        self:SetAttribute("initial-width", TukuiDB:Scale(170))
			self:SetAttribute("initial-height", TukuiDB:Scale(50))
	elseif unit == "target" then
	        self:SetAttribute("initial-width", TukuiDB:Scale(224))
			self:SetAttribute("initial-height", TukuiDB:Scale(50))
	elseif (unit and unit:find("arena%d")) or (unit and unit:find("boss%d")) then
			self:SetAttribute("initial-width", TukuiDB:Scale(110))
			self:SetAttribute("initial-height", TukuiDB:Scale(30))
	elseif(self:GetParent():GetName():match"oUF_MainTank" or self:GetParent():GetName():match"oUF_MainAssist") then
		if TukuiDB["unitframes"].t_mt_power == true then
			self.Power:SetHeight(2)
			self.Power.value:Hide()
			self.Health:SetHeight(17)
		else
			self.Power:Hide()
			self.Health:SetHeight(20)
		end		
		self:SetAttribute("initial-height", TukuiDB:Scale(50))
		self:SetAttribute("initial-width", TukuiDB:Scale(100))
	elseif unit == "pet" or unit == "targettarget" then
		self:SetAttribute("initial-width", TukuiDB:Scale(50))
		self:SetAttribute("initial-height", TukuiDB:Scale(50))
		self.Health:SetOrientation('VERTICAL')
	elseif unit == "focus"  then
		self:SetAttribute("initial-width", TukuiDB:Scale(134))
		self:SetAttribute("initial-height", TukuiDB:Scale(34))
		self.Power:Hide()
	else
		self:SetAttribute("initial-width", TukuiDB:Scale(100))
		self:SetAttribute("initial-height", TukuiDB:Scale(24))
	end
		
	------------------------------------------------------------------------
	--	RaidIcons
	------------------------------------------------------------------------

	self.RaidIcon = self.Health:CreateTexture(nil, "OVERLAY")
	self.RaidIcon:SetHeight(24)
	self.RaidIcon:SetWidth(24)
	self.RaidIcon:SetPoint("TOPLEFT")
	
	------------------------------------------------------------------------
	-- LFD Roles
	------------------------------------------------------------------------

    if not unit or unit == "player" then
        self.LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
        self.LFDRole:SetHeight(6)
        self.LFDRole:SetWidth(6)
        self.LFDRole:SetPoint("TOPRIGHT", -2, -2)
    end
	
	self.outsideRangeAlpha = 0.3
	self.inRangeAlpha = 1
	self.SpellRange = true

	if unit == "player" then
		self.BarFade = true
	else
		self.BarFade = false
	end
	
	self.PostUpdateHealth = PostUpdateHealth
	self.PostUpdatePower = PostUpdatePower
	self.PostCreateAuraIcon = createAura
	self.PostUpdateAuraIcon = updatedebuff
	
	if TukuiDB["unitframes"].playeraggro == true then
		self:RegisterEvent("PLAYER_TARGET_CHANGED", ShowThreat)
		self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", ShowThreat)
		self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", ShowThreat)
	end
	
	local petCheck = CreateFrame("Frame")
	local function handlePetBG()
		if not UnitIsVisible("pet") then
			PetActionBarBackground:Hide()
		end
	end

	petCheck:RegisterEvent('UNIT_COMBAT')
	petCheck:RegisterEvent('UNIT_HAPPINESS')
	petCheck:RegisterEvent('UNIT_TARGET')
	petCheck:RegisterEvent('UNIT_FOCUS')
	petCheck:RegisterEvent('UNIT_HEALTH')
	petCheck:RegisterEvent('UNIT_POWER')
	petCheck:RegisterEvent('UNIT_ENERGY')
	petCheck:RegisterEvent('UNIT_RAGE')
	petCheck:RegisterEvent('UNIT_MANA')
	petCheck:RegisterEvent('UNIT_PET')
	petCheck:RegisterEvent('UNIT_RUNIC_POWER')
	petCheck:RegisterEvent('PLAYER_TARGET_CHANGED')
	petCheck:RegisterEvent('PLAYER_REGEN_ENABLED')
	petCheck:RegisterEvent('PLAYER_REGEN_DISABLED')
	petCheck:RegisterEvent('PLAYER_ENTERING_WORLD')
	petCheck:SetScript("OnEvent",handlePetBG)	
	
	return self
end

-----------------------------------------------------------------------------------------------------------------------------
----- FRAME PLACEMENT  
-----------------------------------------------------------------------------------------------------------------------------

oUF:RegisterStyle("Tukz", SetStyle)
oUF:SetActiveStyle("Tukz")

oUF:Spawn("player", "oUF_Tukz_player"):SetPoint("BOTTOMRIGHT", AlignThis, "TOP", TukuiDB:Scale(-25), TukuiDB:Scale(4))
oUF:Spawn("pet", "oUF_Tukz_pet"):SetPoint("RIGHT", oUF_Tukz_player, "LEFT", TukuiDB:Scale(6), 0)
oUF:Spawn("target", "oUF_Tukz_target"):SetPoint("BOTTOMLEFT", AlignThis, "TOP", TukuiDB:Scale(-30), TukuiDB:Scale(4))
oUF:Spawn("targettarget", "oUF_Tukz_targettarget"):SetPoint("LEFT", oUF_Tukz_target, "RIGHT", TukuiDB:Scale(-5), 0)
oUF:Spawn("focus", "oUF_Tukz_focus"):SetPoint("BOTTOMLEFT", ActionBarBackground, "BOTTOMRIGHT", 0, TukuiDB:Scale(-2))


if TukuiDB["unitframes"].showfocustarget == true then oUF:Spawn("focustarget", "oUF_Tukz_focustarget"):SetPoint("BOTTOM", 0, 280) end

if TukuiDB["arena"].unitframes == true then
	if not IsAddOnLoaded("Gladius") then
		local arena = {}
		for i = 1, 5 do
			arena[i] = oUF:Spawn("arena"..i, "oUF_Arena"..i)
			if i == 1 then
				arena[i]:SetPoint("LEFT", UIParent, "LEFT", TukuiDB:Scale(250), TukuiDB:Scale(-90))
			else
				arena[i]:SetPoint("BOTTOM", arena[i-1], "TOP", 0, TukuiDB:Scale(8))
			end
		end
	end
end

local party = oUF:Spawn("header", "oUF_PartyHide")
party:SetAttribute("showParty", false)

if TukuiDB["unitframes"].t_mt == true then
	local tank = oUF:Spawn("header", "oUF_MainTank")
	tank:SetManyAttributes("showRaid", true, "groupFilter", "MAINTANK", "yOffset", 5, "point" , "BOTTOM")
	tank:SetPoint("BOTTOM", UIParent, "BOTTOM", 500, 560)
	tank:SetAttribute("template", "oUF_tukzMtt")
	tank:Show()

	local assist = oUF:Spawn("header", "oUF_MainAssist")
	assist:SetManyAttributes("showRaid", true, "groupFilter", "MAINASSIST", "yOffset", 5, "point", "BOTTOM")
	assist:SetPoint("TOP", tank, "BOTTOM", 0, -30)
	assist:SetAttribute("template", "oUF_tukzMtt")
	assist:Show()
end

for i = 1,MAX_BOSS_FRAMES do
   local t_boss = _G["Boss"..i.."TargetFrame"]
   t_boss:UnregisterAllEvents()
   t_boss.Show = dummy
   t_boss:Hide()
   _G["Boss"..i.."TargetFrame".."HealthBar"]:UnregisterAllEvents()
   _G["Boss"..i.."TargetFrame".."ManaBar"]:UnregisterAllEvents()
end

local boss = {}
for i = 1, MAX_BOSS_FRAMES do
   boss[i] = oUF:Spawn("boss"..i, "oUF_Boss"..i)
   if i == 1 then
      boss[i]:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -115, 360)
   else
      boss[i]:SetPoint('BOTTOM', boss[i-1], 'TOP', 0, 10)             
   end
end