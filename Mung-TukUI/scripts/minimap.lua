local cColor = TukuiDB["classy"]
local _, class = UnitClass("player")
local colorz = cColor[class]
--------------------------------------------------------------------
-- MINIMAP BORDER
--------------------------------------------------------------------

local p = CreateFrame("Frame", "MapBorder", Minimap)
TukuiDB:CreatePanel(p, 134, 132, "CENTER", Minimap, "CENTER", 0, 1)
p:SetBackdropBorderColor(colorz[1], colorz[2], colorz[3])
p:SetBackdropColor(colorz[1], colorz[2], colorz[3])
p.bg:SetGradientAlpha("VERTICAL",.1,.1,.1,0,.1,.1,.1,.5)
p:SetFrameStrata("BACKGROUND")
Minimap:ClearAllPoints()
Minimap:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", TukuiDB:Scale(-14), TukuiDB:Scale(-34))
Minimap:SetSize(TukuiDB:Scale(124), TukuiDB:Scale(124))
Minimap:SetFrameLevel(10)

--------------------------------------------------------------------
-- MINIMAP ROUND TO SQUARE AND MINIMAP SETTING
--------------------------------------------------------------------


-- Hide Border
MinimapBorder:Hide()
MinimapBorderTop:Hide()

-- Hide Zoom Buttons
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()

-- Hide Voice Chat Frame
MiniMapVoiceChatFrame:Hide()

-- Hide Game Time
GameTimeFrame:Hide()

-- Hide Zone Frame
MinimapZoneTextButton:Hide()

-- Hide Tracking Button
MiniMapTracking:Hide()

-- Hide Mail Button
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, TukuiDB:Scale(3), TukuiDB:Scale(4))
MiniMapMailBorder:Hide()
MiniMapMailIcon:SetTexture("Interface\\AddOns\\Tukui\\media\\mail")

-- Move battleground icon
MiniMapBattlefieldFrame:ClearAllPoints()
MiniMapBattlefieldFrame:SetPoint("BOTTOMRIGHT", Minimap, TukuiDB:Scale(3), 0)

-- Hide world map button
MiniMapWorldMapButton:Hide()

-- shitty 3.3 flag to move
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 0, 0)

function UpdateLFG()
	MiniMapLFGFrame:ClearAllPoints()
	MiniMapLFGFrame:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", TukuiDB:Scale(2), TukuiDB:Scale(1))
end
hooksecurefunc("MiniMapLFG_UpdateIsShown", UpdateLFG)

-- Enable mouse scrolling
Minimap:EnableMouseWheel(true)
Minimap:SetScript("OnMouseWheel", function(self, d)
	if d > 0 then
		_G.MinimapZoomIn:Click()
	elseif d < 0 then
		_G.MinimapZoomOut:Click()
	end
end)

--POPUP FUNCTIONS
StaticPopupDialogs["ENABLE_SKADA"] = {
	text = tukuilocal.popup_skadaload,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() EnableAddOn("Skada") EnableAddOn("SkadaAbsorbs") EnableAddOn("SkadaCC") EnableAddOn("SkadaDamageTaken") EnableAddOn("SkadaDamage") EnableAddOn("SkadaDeaths")
		EnableAddOn("SkadaDebuffs") EnableAddOn("SkadaDispels") EnableAddOn("SkadaEnemies") EnableAddOn("SkadaFailbot") EnableAddOn("SkadaHealing") EnableAddOn("SkadaPower") 
			EnableAddOn("SkadaThreat") ReloadUI() end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs["ENABLE_ATLAS"] = {
	text = tukuilocal.popup_atlasload,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() EnableAddOn("AtlasLoot") end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}

StaticPopupDialogs["ENABLE_QBAR"] = {
	text = tukuilocal.popup_qbarload,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = function() EnableAddOn("QBar") end,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1,
}
----------------------------------------------------------------------------------------
-- Right click menu
----------------------------------------------------------------------------------------
local menuFrame = CreateFrame("Frame", "MinimapRightClickMenu", UIParent, "UIDropDownMenuTemplate")
local menuList = {
    {text = CHARACTER_BUTTON,
    func = function() ToggleCharacter("PaperDollFrame") end},
    {text = SPELLBOOK_ABILITIES_BUTTON,
    func = function() ToggleSpellBook("spell") end},
    {text = TALENTS_BUTTON,
    func = function() ToggleTalentFrame() end},
    {text = ACHIEVEMENT_BUTTON,
    func = function() ToggleAchievementFrame() end},
    {text = QUESTLOG_BUTTON,
    func = function() ToggleFrame(QuestLogFrame) end},
    {text = SOCIAL_BUTTON,
    func = function() ToggleFriendsFrame(1) end},
    {text = PLAYER_V_PLAYER,
    func = function() ToggleFrame(PVPParentFrame) end},
    {text = LFG_TITLE,
    func = function() ToggleFrame(LFDParentFrame) end},
    {text = L_LFRAID,
    func = function() ToggleFrame(LFRParentFrame) end},
    {text = HELP_BUTTON,
    func = function() ToggleHelpFrame() end},
    {text = L_CALENDAR,
    func = function()
    if(not CalendarFrame) then LoadAddOn("Blizzard_Calendar") end
        Calendar_Toggle()
    end},
	{text = ""},
	{text = "AtlasLoot",
    func = function() 
	if(not AtlasLootDefaultFrame) then LoadAddOn("AtlasLoot") end
	if AtlasLootDefaultFrame:IsShown() then AtlasLootDefaultFrame:Hide() else AtlasLootDefaultFrame:Show() end
	end},
	{text = "Skada",
    func = function() 
	if(not SkadaBarWindowSkada) then StaticPopup_Show("ENABLE_SKADA") end
	if SkadaBarWindowSkada:IsShown() then SkadaBarWindowSkada:Hide() else SkadaBarWindowSkada:Show() end
	end},
	{text = "QBar",
    func = function() 
	if(not QBar) then StaticPopup_Show("ENABLE_QBAR") end
	if QBar:IsShown() then QBar:Hide() else QBar:Show() end
	end},
}

Minimap:SetScript("OnMouseUp", function(self, btn)
	if btn == "MiddleButton" then
		ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self)
	elseif btn == "RightButton" then
		EasyMenu(menuList, menuFrame, "cursor", 0, 0, "MENU", 2)
	else
		Minimap_OnClick(self)
	end
end)


-- Set Square Map Mask
Minimap:SetMaskTexture('Interface\\ChatFrame\\ChatFrameBackground')
