if not TukuiDB["unitframes"].enable == true then return end

local fontlol = TukuiDB["media"].pixelfont
local normTex = TukuiDB["media"].normTex
local normTex2 = TukuiDB["media"].normTex2
local glowTex = TukuiDB["media"].glowTex
local blank = TukuiDB["media"].blank
local cColor = TukuiDB["classy"]
local _, class = UnitClass("player")
local colorz = cColor[class]
local unitcolor = TukuiDB["media"].unitcolor
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
	["DEATHKNIGHT"] = { 216/255,  30/255,  60/255 },
	["DRUID"]       = { 255/255, 105/255,  10/255 },
	["HUNTER"]      = {  50/255, 205/255,  50/255 },
	["MAGE"]        = {   0/255, 191/255, 255/255 },
	["PALADIN"]     = { 245/255,  40/255, 146/255 },
	["PRIEST"]      = { 248/255, 248/255, 255/255 },
	["ROGUE"]       = { 255/255, 243/255,  22/255 },
	["SHAMAN"]      = {  21/255,  21/255, 255/255 },
	["WARLOCK"]     = { 138/255,  43/255, 226/255 },
	["WARRIOR"]     = { 139/255,  69/255,  19/255 },
}

oUF.colors.tapped = {0.55, 0.57, 0.61}
oUF.colors.disconnected = {0.1, 0.1, 0.1}

oUF.colors.smooth = {0.89, 0.11, 0.11, 0.65, 0.83, 0.25, 0.25, 0.25, 0.25}

-- ------------------------------------------------------------------------
-- local and aurawatch mwahaha
-- ------------------------------------------------------------------------
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

local function auraIcon(self, icon)
	TukuiDB:SetTemplate(icon)
	icon.icon:SetPoint("TOPLEFT", TukuiDB:Scale(2), TukuiDB:Scale(-2))
	icon.icon:SetPoint("BOTTOMRIGHT", TukuiDB:Scale(-2), TukuiDB:Scale(2))
	icon.icon:SetTexCoord(.08, .92, .08, .92)
	icon.icon:SetDrawLayer("ARTWORK")
	icon.overlay:SetTexture()
end


local function createAuraWatch(self,unit)
	local auras = CreateFrame("Frame", nil, self)
    auras:SetAllPoints(self.Health)
	
	local debuffs = TukuiDB.spellids

    auras.presentAlpha = 0.5
    auras.missingAlpha = 0
    auras.icons = {}
	
	auras.PostCreateIcon = auraIcon
	if TukuiDB["unitframes"].auratimer ~= true then
		auras.hideCooldown = true
	end
    
    for i, sid in pairs(debuffs) do
		local icon = CreateFrame("Frame", nil, auras)	  
		icon.spellID = sid
			if i > 16 then
				icon.anyUnit = true
				icon:SetWidth(TukuiDB:Scale(22*TukuiDB["unitframes"].gridscale))
				icon:SetHeight(TukuiDB:Scale(22*TukuiDB["unitframes"].gridscale))
				icon:SetPoint("CENTER",0,0)	  
			else
				icon:SetWidth(TukuiDB:Scale(6*TukuiDB["unitframes"].gridscale))
				icon:SetHeight(TukuiDB:Scale(6*TukuiDB["unitframes"].gridscale))
				local tex = icon:CreateTexture(nil, "OVERLAY")
				tex:SetWidth(6*TukuiDB["unitframes"].gridscale)
				tex:SetHeight(6*TukuiDB["unitframes"].gridscale)
				tex:SetPoint("CENTER")
				tex:SetTexture([=[Interface\AddOns\Tukui\media\blank]=])
				if class == "DRUID" then
					if i==1 then
						icon:SetPoint("TOPRIGHT")
						tex:SetVertexColor(200/255,100/255,200/255)
					elseif i==2 then
						icon:SetPoint("BOTTOMLEFT")
						tex:SetVertexColor(50/255,200/255,50/255)
					elseif i==3 then          
						icon:SetPoint("TOPLEFT")
						tex:SetVertexColor(100/255,200/255,50/255)
					local count = icon:CreateFontString(nil, "OVERLAY")
						count:SetFont(fontlol, 8, "THINOUTLINE")
						count:SetPoint("CENTER")
						icon.count = count
					elseif i==4 then
						icon:SetPoint("BOTTOMRIGHT")
						tex:SetVertexColor(200/255,100/255,0/255)
				end
				elseif class == "PRIEST" then
					if i==5 then
						icon.anyUnit = true
						icon:SetPoint("TOPRIGHT")
						tex:SetVertexColor(1, 0, 0, 0.5)
					elseif i==6 then
						icon:SetPoint("BOTTOMRIGHT")
						tex:SetVertexColor(0.2, 0.7, 0.2, 0.5)
					local count = icon:CreateFontString(nil, "OVERLAY")
						count:SetFont(fontlol, 8, "THINOUTLINE")
						count:SetPoint("CENTER")
						icon.count = count
					elseif i == 7 then
						icon:SetPoint("BOTTOMLEFT")
						tex:SetVertexColor(0.4, 0.7, 0.2, 0.5)
					elseif i == 8 then
						icon.anyUnit = true
						icon:SetPoint("TOPLEFT")
						tex:SetVertexColor(213/255,220/255,22/255)          
					end
				elseif class == "SHAMAN" then
				if i==9 then
						icon:SetPoint("TOPRIGHT")
						tex:SetVertexColor(0.7, 0.3, 0.7, 0.5)
					elseif i==10 then
						icon:SetPoint("BOTTOMLEFT")
						tex:SetVertexColor(0.2, 0.7, 0.2, 0.5)
					elseif i==11 then          
						icon:SetPoint("TOPLEFT")
						tex:SetVertexColor(0.4, 0.7, 0.2, 0.5)
					elseif i==12 then
						icon:SetPoint("BOTTOMRIGHT")
						tex:SetVertexColor(0.7, 0.4, 0, 0.5)
				end
				elseif class == "PALADIN" then
					if i==13 then
						icon:SetPoint("TOPRIGHT")
						tex:SetVertexColor(0.7, 0.3, 0.7, 0.5)
					elseif i==14 then          
						icon:SetPoint("TOPLEFT")
						tex:SetVertexColor(0.4, 0.7, 0.2, 0.5)
					end
				end
				if i==15 then
					icon:SetPoint("RIGHT", -3, 0)
					tex:SetVertexColor(0, 1, 0, 0.5)
				elseif i==16 then
					icon:SetPoint("LEFT", 3, 0)
					tex:SetVertexColor(1, 0, 0, 0.5)
				end
			end
			auras.icons[sid] = icon
	end
	self.AuraWatch = auras
end

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

local function UpdateThreat(self, event, unit)
	if (self.unit ~= unit) then
		return
	end
	local threat = UnitThreatSituation(self.unit)
	if (threat == 3) then
		self.np:SetBackdropBorderColor(1,0.1,0.1,1)
	else
		self.np:SetBackdropBorderColor(unpack(TukuiDB["media"].altbordercolor))
	end  
end

local updateHealth = function(self, event, unit, bar, min, max)  
    local cur, maxhp = min, max
    local missing = maxhp-cur
    
    local d = floor(cur/maxhp*100)
	self.Health.bg:SetVertexColor(0.05,0.05,0.05)
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

local function menu(self)
	if(self.unit:match('party')) then
		ToggleDropDownMenu(1, nil, _G['PartyMemberFrame'..self.id..'DropDown'], 'cursor')
	end
end

local function CreateStyle(self, unit)
		
	self.menu = menu
	self.colors = colors
	self:RegisterForClicks('AnyUp')
	self:SetScript('OnEnter', UnitFrame_OnEnter)
	self:SetScript('OnLeave', UnitFrame_OnLeave)
	
	self:SetAttribute('*type2', 'menu')
	self:SetAttribute('initial-height', TukuiDB:Scale(30))
	self:SetAttribute('initial-width', TukuiDB:Scale(40))

	self:SetBackdrop( {
		bgFile = blank,
		edgeFile = glowTex,
		edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 }}) 
	self:SetBackdropBorderColor(unpack(TukuiDB["media"].unitshadowcolor))
	self:SetBackdropColor(0,0,0,1)

	self.Health = CreateFrame('StatusBar', nil, self)
	self.Health:SetPoint("TOPLEFT", 3, -3)
	self.Health:SetPoint("BOTTOMRIGHT", -3, 3)
	self.Health:SetOrientation('VERTICAL')
	self.Health:SetStatusBarTexture(normTex)
	 
	self.Health.bg = self.Health:CreateTexture(nil, 'BORDER')
	self.Health.bg:SetPoint("TOPLEFT", self.Health, "TOPLEFT")
	self.Health.bg:SetPoint("BOTTOMRIGHT", self.Health, "BOTTOMRIGHT")
	self.Health.bg:SetTexture(TukuiDB["media"].barTex3)
	self.Health.colorClass = true
	self.Health.colorDisconnected = true
	self.Health.colorSmooth = true
	self.Health.Smooth = true
		
	self.Health.value = self.Health:CreateFontString(nil, "OVERLAY")
	self.Health.value:SetPoint("CENTER", self.Health, 0, 1)
	self.Health.value:SetFont(fontlol, 6, "THINOUTLINE")
	self.Health.value:SetTextColor(1,1,1,0)
	self.Health.value:SetShadowOffset(1, -1)
	
	self.Power = CreateFrame("StatusBar", nil, self)
	self.Power:SetHeight(3*TukuiDB["unitframes"].gridscale*TukuiDB.raidscale)
	self.Power:SetPoint("TOPLEFT", self.Health, "BOTTOMLEFT", 1, -TukuiDB.mult)
	self.Power:SetPoint("TOPRIGHT", self.Health, "BOTTOMRIGHT", -1, -TukuiDB.mult)
	self.Power:SetStatusBarTexture(blank)

	self.Power.bg = self.Power:CreateTexture(nil, "BORDER")
	self.Power.bg:SetAllPoints(self.Power)
	self.Power.bg:SetTexture(blank)
	self.Power.bg:SetAlpha(1)
	
	self.Power:Hide()
	

	self.np = CreateFrame("Frame", nameplate, self)
    self.np:SetFrameLevel(0)
    self.np:SetFrameStrata("background")
    self.np:SetHeight(10)
    self.np:SetWidth(50)
    self.np:SetPoint("CENTER", 0,0)

				
	self.Name = self.Health:CreateFontString(nil, "OVERLAY")
    self.Name:SetPoint("CENTER", self.np, "CENTER", 0, TukuiDB.mult)
	self.Name:SetFont(TukuiDB["media"].pixelfont, 8, "OUTLINE")
	self.Name:SetShadowColor(0, 0, 0)
	self.Name:SetShadowOffset(-1.2, -1.2)
	self:Tag(self.Name, "[GetNameColor][NameTiny]")
	
    if TukuiDB["unitframes"].aggro == true then
		table.insert(self.__elements, UpdateThreat)
		self:RegisterEvent('PLAYER_TARGET_CHANGED', UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_LIST_UPDATE', UpdateThreat)
		self:RegisterEvent('UNIT_THREAT_SITUATION_UPDATE', UpdateThreat)
    else
        self.np:SetBackdropBorderColor(unpack(TukuiDB["media"].bordercolor))
    end

	if TukuiDB["unitframes"].showsymbols == true then
		self.RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
		self.RaidIcon:SetHeight(TukuiDB:Scale(18*TukuiDB["unitframes"].gridscale*TukuiDB.raidscale))
		self.RaidIcon:SetWidth(TukuiDB:Scale(18*TukuiDB["unitframes"].gridscale*TukuiDB.raidscale))
		self.RaidIcon:SetPoint('CENTER', self, 'TOP')
		self.RaidIcon:SetTexture('Interface\\TargetingFrame\\UI-RaidTargetingIcons')	
	end
	
	self.ReadyCheck = self.Power:CreateTexture(nil, "OVERLAY")
	self.ReadyCheck:SetHeight(TukuiDB:Scale(12*TukuiDB["unitframes"].gridscale*TukuiDB.raidscale))
	self.ReadyCheck:SetWidth(TukuiDB:Scale(12*TukuiDB["unitframes"].gridscale*TukuiDB.raidscale))
	self.ReadyCheck:SetPoint('CENTER') 
	
	self.DebuffHighlightAlpha = 1
	self.DebuffHighlightBackdrop = true
	self.DebuffHighlightFilter = true
	
	self.outsideRangeAlpha = TukuiDB["unitframes"].raidalphaoor
	self.inRangeAlpha = 1.0
	self.Range = true
	
	self.PostUpdateHealth = updateHealth
	
	if not unit and TukuiDB["unitframes"].raidunitdebuffwatch == true then
		createAuraWatch(self,unit)
    end

end

oUF:RegisterStyle('hRaid40', CreateStyle)
oUF:SetActiveStyle('hRaid40')

local raid = {}
for i = 1, 8 do
	local raidgroup = oUF:Spawn('header', 'oUF_Group'..i)
	raidgroup:SetManyAttributes('groupFilter', tostring(i), 'showRaid', true, 'xOffset', 4, "point", "LEFT")
	raidgroup:SetFrameStrata('BACKGROUND')	
	table.insert(raid, raidgroup)
	if(i == 1) then
		raidgroup:SetPoint("BOTTOMLEFT", TabPanel, "TOPLEFT",  TukuiDB:Scale(4), TukuiDB:Scale(200))
	else
		raidgroup:SetPoint('BOTTOMLEFT', raid[i-1], 'TOPLEFT', 0, TukuiDB:Scale(4))
	end
	local raidToggle = CreateFrame("Frame")
	raidToggle:RegisterEvent("PLAYER_LOGIN")
	raidToggle:RegisterEvent("RAID_ROSTER_UPDATE")
	raidToggle:RegisterEvent("PARTY_LEADER_CHANGED")
	raidToggle:RegisterEvent("PARTY_MEMBERS_CHANGED")
	raidToggle:SetScript("OnEvent", function(self)
	if InCombatLockdown() then
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		self:UnregisterEvent("PLAYER_REGEN_ENABLED")
		local numraid = GetNumRaidMembers()
		if numraid < 6 then
			raidgroup:Hide()
		else
			raidgroup:Show()
		end
	end
	end)
end