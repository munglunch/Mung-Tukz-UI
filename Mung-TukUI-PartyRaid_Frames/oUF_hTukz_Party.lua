if not TukuiDB["unitframes"].enable == true then return end

local fontlol = TukuiDB["media"].pixelfont
local font = TukuiDB["media"].uffont
local font2 = TukuiDB["media"].superfont
local unitcolor = {.13,.13,.13} -- The UF main color {red, green, blue, alhpa} 0<= Value <=1
local unitshadowcolor = {0,0,0,.5} -- Shadow color here

local playerClass = select(2, UnitClass("player"))
local normTex = TukuiDB["media"].normTex
local barTex3 = TukuiDB["media"].barTex3
local blank = TukuiDB["media"].blank
local glowTex = TukuiDB["media"].glowTex
local bubbleTex = TukuiDB["media"].bubbleTex
local castb = TukuiDB["media"].castb
local iamwallpaper = TukuiDB["media"].unitwall
local i2amwallpaper = TukuiDB["media"].deadwall
local cColor = TukuiDB["classy"]
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

oUF.colors.tapped = {0.55, 0.57, 0.61}
oUF.colors.disconnected = {0.84, 0.75, 0.65}

oUF.colors.smooth = {0.69, 0.31, 0.31, 0.65, 0.63, 0.35, 0.15, 0.15, 0.15}

--------------------------------------------------------------------------
-- local horror
--------------------------------------------------------------------------

local select = select
local UnitClass = UnitClass
local UnitIsDead = UnitIsDead
local UnitIsPVP = UnitIsPVP
local UnitIsGhost = UnitIsGhost
local UnitIsPlayer = UnitIsPlayer
local UnitReaction = UnitReaction
local UnitIsConnected = UnitIsConnected
local UnitCreatureType = UnitCreatureType
local UnitClassification = UnitClassification
local UnitReactionColor = UnitReactionColor
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local numberize_raid = function(v)
	if v <= 999 then return v end
	if v >= 1000000 then
		local value = string.format("%.1fm", v/1000000)
		return value
	elseif v >= 1000 then
		local value = string.format("%.1fk", v/1000)
		return value
	end
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

local updateHealth = function(self, event, unit, bar, min, max)  
    local cur, maxhp = min, max
    local missing = maxhp-cur
    self.Health.bg:SetVertexColor(0.08, 0.08, 0.08)
    local d = floor(cur/maxhp*100)
	if(UnitIsDead(unit)) then
		bar:SetValue(0)
		bar.value:SetText(tukuilocal.unitframes_ouf_deadheal)
	elseif(UnitIsGhost(unit)) then
		bar:SetValue(0)
		bar.value:SetText(tukuilocal.unitframes_ouf_ghostheal)
	elseif(not UnitIsConnected(unit)) then
		bar.value:SetText(tukuilocal.unitframes_disconnected)
	elseif(self:GetParent():GetName():match"oUF_Group") then
		if(d < 100) then
			bar.value:SetText("|cffFFFFFF".."-"..numberize_raid(missing))
		else
			bar.value:SetText(" ")
		end
    end
end

local PostUpPower = function(self, event, unit, bar, min, max)
	if(self.unit ~= unit) then return end

	local pType, pToken = UnitPowerType(unit)
	local color = colors.power[pToken]
	if(self.Name) then
		local _, englass = UnitClass(unit)
		r, g, b = unpack(cColor[englass])
		self.Name:SetTextColor(r, g, b)
	end
	if color then
		self.Power:SetBackdropColor(color[1], color[2], color[3], 1)
	end
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

local SetFont = function(parent, fontName, fontHeight, fontStyle)
	local fs = parent:CreateFontString(nil, "OVERLAY")
	fs:SetFont(fontName, fontHeight, fontStyle)
	fs:SetJustifyH("LEFT")
	fs:SetShadowColor(0, 0, 0)
	fs:SetShadowOffset(1.25, -1.25)
	return fs
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

local function auraIcon(self, button, icons)
	icons.showDebuffType = true

	button.remaining = SetFont(button, fontlol, 8, "OUTLINE")
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
		button.cd:SetPoint("TOPLEFT", button, "TOPLEFT", TukuiDB:Scale(2), TukuiDB:Scale(-2))
		button.cd:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", TukuiDB:Scale(-2), TukuiDB:Scale(2))
		button.overlayFrame:SetFrameLevel(button.cd:GetFrameLevel() + 1)
		   
		button.overlay:SetParent(button.overlayFrame)
		button.count:SetParent(button.overlayFrame)
		button.remaining:SetParent(button.overlayFrame)
	else
		icons.disableCooldown = true
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
	button.glow = TukuiDB:mkButton (button.glow)
end

local function updatedebuff(self, icons, unit, icon, index, offset, filter, isDebuff, duration, timeLeft)
	local _, _, _, _, dtype, duration, expirationTime, unitCaster, _ = UnitAura(unit, index, icon.filter)

	if(icon.debuff) then
		local color = DebuffTypeColor[dtype] or DebuffTypeColor.none
		icon.glow:SetBackdropBorderColor(icon.overlay:GetVertexColor())
		icon.glow:SetBackdropColor(icon.overlay:GetVertexColor())
		icon.glow.top:SetTexture(icon.overlay:GetVertexColor())
		icon.glow.bottom:SetTexture(icon.overlay:GetVertexColor())
		icon.glow.left:SetTexture(icon.overlay:GetVertexColor())
		icon.glow.right:SetTexture(icon.overlay:GetVertexColor())
		icon.icon:SetDesaturated(false)
	end
	if duration and duration > 0 then
		if TukuiDB["unitframes"].auratimer == true then
			icon.remaining:Show()
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

local function UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then
		return
	end
	local threat = UnitThreatSituation(self.unit)
	if not(unit and unit:find('partypet%d')) and not(unit and unit:find('party%dtarget')) then
		if (threat == 3) then
			self.Name:SetTextColor(1,0.1,0.1)
		else
			self.Name:SetTextColor(1,1,1)
		end 
	end
end

local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/TukuiDB["general"].uiscale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end

function TukuiDB:Scale(x) return scale(x) end
TukuiDB.mult = mult

local function menu(self)
	if(self.unit:match('party')) then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor')
	end
end

local function CreateStyle(self, unit)
	
	if not(unit and unit:find('partypet%d')) and not(unit and unit:find('party%dtarget')) then

		self.Debuffs = CreateFrame('Frame', nil, self)
		self.Debuffs:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', TukuiDB:Scale(2), 0)
		self.Debuffs:SetHeight(21)
		self.Debuffs:SetWidth(150)
		self.Debuffs.size = 18
		self.Debuffs.spacing = 5
		self.Debuffs.initialAnchor = 'BOTTOMLEFT'
		self.Debuffs.showDebuffType = true
		self.Debuffs.num = 0
		self.Debuffs.numBuffs = 0
		self.Debuffs.numDebuffs = 0
		self.Debuffs["growth-x"] = "RIGHT"
		
		self.menu = menu
		self.colors = colors
		self:RegisterForClicks('AnyUp')
		self:SetScript('OnEnter', UnitFrame_OnEnter)
		self:SetScript('OnLeave', UnitFrame_OnLeave)

		self:SetAttribute('*type2', 'menu')
	end
	if not(unit and unit:find('partypet%d')) and not(unit and unit:find('party%dtarget')) then
		self:SetAttribute('initial-height', TukuiDB:Scale(30))
		self:SetAttribute('initial-width', 160)
	else
		self:SetAttribute('initial-height', TukuiDB:Scale(30))
		self:SetAttribute('initial-width', 30)
	end
	self:SetFrameStrata("LOW") 
	---/styling framebackdrop
	self:SetBackdrop( {
		bgFile = blank,
		edgeFile = glowTex,
		edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }}) 
	self:SetBackdropBorderColor(unpack(TukuiDB["media"].unitshadowcolor))
	self:SetBackdropColor(0,0,0,1)
	
	---/making portrait

	self.Health = CreateFrame('StatusBar', nil, self)
	if not(unit and unit:find('partypet%d')) and not(unit and unit:find('party%dtarget')) then
		self.Health:SetPoint("TOPLEFT", 18, -5)
		self.Health:SetPoint("BOTTOMRIGHT", -5, 5)
		self.Health:SetStatusBarTexture(normTex)
	else
		self.Health:SetPoint("TOPLEFT", 5, -5)
		self.Health:SetPoint("BOTTOMRIGHT", -5, 5)
		self.Health:SetStatusBarTexture(normTex)
		self.Health:SetOrientation("VERTICAL")
	end
	self.Health.bg = self.Health:CreateTexture(nil, 'BORDER')
	self.Health.bg:SetPoint("TOPLEFT", self.Health, "TOPLEFT")
	self.Health.bg:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT")
	self.Health.bg:SetTexture(barTex3)
	self.Health.bg.multiplier = 0.2
	
	-- healthbar functions
	self.Health.colorDisconnected = true
	self.Health.colorSmooth = true
	self.Health.Smooth = true
	if (unit and unit:find('party%dtarget')) then
		self.Health.colorReaction = true
	end
	-- healthbar text

	self.Health.value = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.value:SetPoint("RIGHT", self.Health, -3, 1)
	self.Health.value:SetFont(fontlol, 6, "THINOUTLINE")
	self.Health.value:SetTextColor(1,1,1,0)
	self.Health.value:SetShadowOffset(1, -1)

	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetStatusBarTexture(normTex)

	self.Power:SetPoint("BOTTOMRIGHT",self.Health,"BOTTOMLEFT", -2, 0)
	self.Power:SetPoint("TOPRIGHT",self.Health,"TOPLEFT", -2, 0)
	self.Power:SetWidth(TukuiDB:Scale(12))
	self.Power:SetFrameLevel(6)
	self.Power.colorDisconnected = true
	self.Power.frequentUpdates = true
	self.Power.Smooth = true
	self.Power.colorClass = true
	
	if not(unit and unit:find('partypet%d')) and not(unit and unit:find('party%dtarget')) then
		self.Power:SetOrientation("VERTICAL")
	else
		self.Power:Hide()
	end

	self.panel = CreateFrame ("Frame",nil,self)
	TukuiDB:CreatePanel(self.panel, 80, 10, "BOTTOMLEFT", self, "TOPLEFT", 0, TukuiDB:Scale(-2), 1) 
	self.panel:SetBackdropColor(0,0,0,0)
	self.panel:SetBackdropBorderColor(0,0,0,0)
	if not(unit and unit:find('partypet%d')) and not(unit and unit:find('party%dtarget')) then
		self.Name = self.Health:CreateFontString(nil, "OVERLAY")
		self.Name:SetPoint("BOTTOMLEFT", self.Health, "BOTTOMLEFT", TukuiDB:Scale(4), TukuiDB:Scale(4))
		self.Name:SetFont(font, 10)
		self.Name:SetShadowOffset(1, -1)
		self:Tag(self.Name, "[NameMedium]")
	end
	
    self.Leader = self.Health:CreateTexture(nil, "OVERLAY")
    self.Leader:SetHeight(TukuiDB:Scale(18*TukuiDB.raidscale))
    self.Leader:SetWidth(TukuiDB:Scale(18*TukuiDB.raidscale))
    self.Leader:SetPoint("TOPLEFT",self.Health,0,10)

    self.LFDRole = self.Health:CreateTexture(nil, "OVERLAY")
    self.LFDRole:SetHeight(TukuiDB:Scale(6*TukuiDB.raidscale))
    self.LFDRole:SetWidth(TukuiDB:Scale(6*TukuiDB.raidscale))
	self.LFDRole:SetPoint("TOPRIGHT", TukuiDB:Scale(-2), TukuiDB:Scale(-2))

    self.MasterLooter = self.Health:CreateTexture(nil, "OVERLAY")
    self.MasterLooter:SetHeight(TukuiDB:Scale(18*TukuiDB.raidscale))
    self.MasterLooter:SetWidth(TukuiDB:Scale(18*TukuiDB.raidscale))
    local MLAnchorUpdate = function (self)
        if self.Leader:IsShown() then
            self.MasterLooter:SetPoint("BOTTOMLEFT",self.Health,0,-8)
        else
            self.MasterLooter:SetPoint("TOPLEFT",self.Health,0,8)
        end
    end
    self:RegisterEvent("PARTY_LEADER_CHANGED", MLAnchorUpdate)
    self:RegisterEvent("PARTY_MEMBERS_CHANGED", MLAnchorUpdate)
	
	if TukuiDB["unitframes"].aggro == true then
      table.insert(self.__elements, UpdateThreat)
      self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
      self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
      self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
    end

	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true

	self.ReadyCheck = self.Power:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetHeight(TukuiDB:Scale(12*TukuiDB.raidscale))
	self.ReadyCheck:SetWidth(TukuiDB:Scale(12*TukuiDB.raidscale))
	self.ReadyCheck:SetPoint('CENTER') 
	
	self.outsideRangeAlpha = TukuiDB["unitframes"].raidalphaoor
	self.inRangeAlpha = 1.0
	if TukuiDB["unitframes"].showrange == true and not(unit and unit:find('party%dtarget')) then
		self.Range = true
	end

	if TukuiDB["unitframes"].showsmooth == true then
		self.Health.Smooth = true
	end
	
    self.PostCreateAuraIcon = auraIcon
	self.PostUpdateHealth = updateHealth
	self.PostUpdateAuraIcon = updatedebuff
	self.PostUpdatePower = PostUpPower
end

oUF:RegisterStyle('hParty', CreateStyle)
oUF:SetActiveStyle('hParty')

local party = oUF:Spawn("header", "oUF_Group")
party:SetPoint("LEFT", UIParent, "LEFT", TukuiDB:Scale(100), TukuiDB:Scale(-50))
party:SetAttribute("showParty", true)
party:SetAttribute("showPlayer", TukuiDB["unitframes"].showplayerinparty)
party:SetManyAttributes('yOffset', 0, "point", "BOTTOM")

local pets = {} 
pets[1] = oUF:Spawn('partypet1', 'oUF_PartyPet1') 
pets[1]:SetPoint('BOTTOMLEFT', party, 'BOTTOMRIGHT', 2, 30) 
for i =2, 5 do 
	if i==5 then
		pets[i] = oUF:Spawn('partypet'..i, 'oUF_PartyPet'..i) 
		pets[i]:SetPoint('BOTTOMLEFT', party, 'BOTTOMRIGHT', 2, 0)
	else
		pets[i] = oUF:Spawn('partypet'..i, 'oUF_PartyPet'..i) 
		pets[i]:SetPoint('BOTTOM', pets[i-1], 'TOP', 0, 0)
	end
end

local partytarget = {}
partytarget[1] = oUF:Spawn('party1target', 'oUF_Party1Target') 
partytarget[1]:SetPoint('BOTTOMLEFT', party, 'BOTTOMRIGHT', 34, 30) 
for i =2, 5 do 
	if i==5 then
		partytarget[i] = oUF:Spawn('party'..i..'target', 'oUF_Party'..i..'Target') 
		partytarget[i]:SetPoint('BOTTOMLEFT', party, 'BOTTOMRIGHT', 34, 0)
	else
		partytarget[i] = oUF:Spawn('party'..i..'target', 'oUF_Party'..i..'Target') 
		partytarget[i]:SetPoint('BOTTOM', partytarget[i-1], 'TOP', 0, 0)
	end
end


local partyToggle = CreateFrame("Frame")
partyToggle:RegisterEvent("PLAYER_LOGIN")
partyToggle:RegisterEvent("RAID_ROSTER_UPDATE")
partyToggle:RegisterEvent("PARTY_LEADER_CHANGED")
partyToggle:RegisterEvent("PARTY_MEMBERS_CHANGED")
partyToggle:SetScript("OnEvent", function(self)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		local numraid = GetNumRaidMembers()
		if numraid > 0 and (numraid > 5 or numraid ~= GetNumPartyMembers() + 1) then
			party:Hide()
			for i,v in ipairs(pets) do v:Disable() end
			for i,v in ipairs(partytarget) do v:Disable() end
		else
			party:Show()
			for i,v in ipairs(pets) do v:Enable() end
			for i,v in ipairs(partytarget) do v:Enable() end
		end
	end
end)
