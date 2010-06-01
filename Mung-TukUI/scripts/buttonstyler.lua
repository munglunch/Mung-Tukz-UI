if not TukuiDB["actionbar"].enable == true 
	or (IsAddOnLoaded("Dominos") 
	or IsAddOnLoaded("Bartender4") 
	or IsAddOnLoaded("Macaroon") 
	or IsAddOnLoaded("XBar")) then 
		return 
end

local _G = _G
local media = TukuiDB["media"]
local securehandler = CreateFrame("Frame", nil, nil, "SecureHandlerBaseTemplate")
local autoMult = (TukuiDB:Scale(1) * 1.3)

local function style(self)
	local name = self:GetName()
	local action = self.action
	local Button = self
	local Icon = _G[name.."Icon"]
	local Count = _G[name.."Count"]
	local Flash	 = _G[name.."Flash"]	
	local HotKey = _G[name.."HotKey"]
	local Border  = _G[name.."Border"]
	local Btname = _G[name.."Name"]
	local normal  = _G[name.."NormalTexture"]

	Flash:SetTexture(media.buttonFlash)
	Button:SetPushedTexture(media.buttonhover)
	Button:SetNormalTexture("")

	Count:ClearAllPoints()
	Count:SetPoint("BOTTOMRIGHT", 0, TukuiDB:Scale(2))
	Count:SetFont(TukuiDB["media"].pixelfont, 10, "OUTLINE")
	
	HotKey:ClearAllPoints()
	HotKey:SetPoint("TOPRIGHT", 0, TukuiDB:Scale(-2))
	HotKey:SetFont(TukuiDB["media"].uffont, 10, "OUTLINE")
	if not TukuiDB["actionbar"].hotkey == true then
		HotKey:SetText("")
		HotKey:Hide()
		HotKey.Show = function() end
	end
	Btname:SetText("")
	Btname:Hide()
	Btname.Show = function() end
	Border:Hide()
	
	if not _G[name.."Panel"] then
		Button:SetWidth(TukuiDB:Scale(30))
		Button:SetHeight(TukuiDB:Scale(30))
		local panel = CreateFrame("Frame", name.."Panel", Button)
		TukuiDB:CreatePanel(panel, TukuiDB:Scale(30), TukuiDB:Scale(30), "CENTER", Button, "CENTER", 0, 0)
		panel:ClearAllPoints()
		panel:SetPoint("TOPLEFT", Button, "TOPLEFT", TukuiDB:Scale(-2), TukuiDB:Scale(2))
		panel:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT",TukuiDB:Scale(2), TukuiDB:Scale(-3))
		panel:SetFrameStrata("LOW")
		Icon:SetTexCoord(0.1,0.9,0.1,0.9)
		Icon:SetPoint("TOPLEFT", panel, "TOPLEFT",TukuiDB:Scale(5), TukuiDB:Scale(-5))
		Icon:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT",TukuiDB:Scale(-5), TukuiDB:Scale(5))
		panel.glow = CreateFrame("Frame",nil,panel)
		TukuiDB:Nglow(panel.glow)
	end
	normal:ClearAllPoints()
	normal:SetPoint("TOPLEFT", Button, "TOPLEFT")
	normal:SetPoint("BOTTOMRIGHT", Button, "BOTTOMRIGHT")
end

local function stylesmallbutton(normal, button, icon, name, pet)
	local Flash	 = _G[name.."Flash"]
	button:SetPushedTexture(media.buttonhover)
	button:SetNormalTexture("")
	Flash:SetTexture(media.buttonFlash)
	
	if not _G[name.."Panel"] then
		button:SetWidth(TukuiDB:Scale(30))
		button:SetHeight(TukuiDB:Scale(30))
		
		local panel = CreateFrame("Frame", name.."Panel", button)
		TukuiDB:CreatePanel(panel, TukuiDB:Scale(30), TukuiDB:Scale(30), "CENTER", button, "CENTER", 0, 0)
		panel:SetPoint("TOPLEFT", button, "TOPLEFT", TukuiDB:Scale(-2), TukuiDB:Scale(2))
		panel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT",TukuiDB:Scale(2), TukuiDB:Scale(-3))
		panel:SetFrameStrata("MEDIUM")
		icon:SetTexCoord(0.1,0.9,0.1,0.9)
		icon:ClearAllPoints()
		if pet then
			local autocast = _G[name.."AutoCastable"]
			autocast:SetWidth(TukuiDB:Scale(1))
			autocast:SetHeight(TukuiDB:Scale(1))
			autocast:ClearAllPoints()
			autocast:SetPoint("CENTER", button, 0, 0)
			icon:SetPoint("TOPLEFT", panel, "TOPLEFT",TukuiDB:Scale(5), TukuiDB:Scale(-5))
			icon:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT",TukuiDB:Scale(-5), TukuiDB:Scale(5))
		else
			icon:SetPoint("TOPLEFT", panel, "TOPLEFT",TukuiDB:Scale(5), TukuiDB:Scale(-5))
			icon:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT",TukuiDB:Scale(-5), TukuiDB:Scale(5))
		end
		panel.glow = CreateFrame ("Frame",nil,panel)
		TukuiDB:Nglow(panel.glow)
	end
	normal:ClearAllPoints()
	normal:SetPoint("TOPLEFT", button, "TOPLEFT")
	normal:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
end

local function styleSS(normal, button, icon, name)
	local Flash	 = _G[name.."Flash"]
	button:SetPushedTexture(media.buttonhover)
	button:SetNormalTexture("")
	Flash:SetTexture("")
	
	if not _G[name.."Panel"] then
		button:SetWidth(TukuiDB:Scale(25))
		button:SetHeight(TukuiDB:Scale(25))
		
		local panel = CreateFrame("Frame", name.."Panel", button)
		TukuiDB:CreatePanel(panel, TukuiDB:Scale(25), TukuiDB:Scale(25), "CENTER", button, "CENTER", 0, 0)
		panel:SetPoint("TOPLEFT", button, "TOPLEFT", TukuiDB:Scale(-2), TukuiDB:Scale(2))
		panel:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT",TukuiDB:Scale(2), TukuiDB:Scale(-3))
		panel:SetFrameStrata("MEDIUM")
		icon:SetTexCoord(0.1,0.9,0.1,0.9)
		icon:ClearAllPoints()
		icon:SetPoint("TOPLEFT", panel, TukuiDB:Scale(3), TukuiDB:Scale(-3))
		icon:SetPoint("BOTTOMRIGHT", panel, TukuiDB:Scale(-3), TukuiDB:Scale(3))
		panel.glow = CreateFrame ("Frame",nil,panel)
		TukuiDB:Nglow(panel.glow)
	end

	normal:ClearAllPoints()
	normal:SetPoint("TOPLEFT", button, "TOPLEFT")
	normal:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT")
end

local function styleshift()
	for i=1, NUM_SHAPESHIFT_SLOTS do
		local name = "ShapeshiftButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture"]
		stylesmallbutton(normal, button, icon, name)
	end
end

local function stylepet()
	for i=1, NUM_PET_ACTION_SLOTS do
		local name = "PetActionButton"..i
		local button  = _G[name]
		local icon  = _G[name.."Icon"]
		local normal  = _G[name.."NormalTexture2"]
		stylesmallbutton(normal, button, icon, name, true)
	end
end

local function usable(self)
	local name = self:GetName()
	local action = self.action
	local icon = _G[name.."Icon"]
	
	local normal  = _G[name.."NormalTexture"]
	normal:SetAlpha(1)
	
	if IsEquippedAction(action) then
		normal:SetVertexColor(.6, 1, .6)
    elseif IsCurrentAction(action) then
		normal:SetVertexColor(1, 1, 1)
	else
		normal:SetVertexColor(unpack(media.bordercolor))
    end
	
	local isusable, mana = IsUsableAction(action)
	if ActionHasRange(action) and IsActionInRange(action) == 0 then
		icon:SetVertexColor(0.8, 0.1, 0.1)
		return
	elseif mana then
		icon:SetVertexColor(.1, .3, 1)
		return
	elseif isusable then
		icon:SetVertexColor(1, 1, 1)
		return
	else
		icon:SetVertexColor(.4, .4, .4)
		return
	end
end

local function onupdate(self, elapsed)
	local t = self.rangetimer
	if not t then
		self.rangetimer = 0
		return
	end
	t = t + elapsed
	if t < .2 then
		self.rangetimer = t
		return
	else
		self.rangetimer = 0
		if not ActionHasRange(self.action) then return end
		usable(self)
	end
end

hooksecurefunc("ActionButton_OnUpdate", onupdate)
hooksecurefunc("ActionButton_Update", style)
hooksecurefunc("ActionButton_UpdateUsable", usable)
hooksecurefunc("PetActionBar_Update", stylepet)
hooksecurefunc("ShapeshiftBar_OnLoad", styleshift)
hooksecurefunc("ShapeshiftBar_Update", styleshift)
hooksecurefunc("ShapeshiftBar_UpdateState", styleshift)
