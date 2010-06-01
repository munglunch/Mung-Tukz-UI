-- these 4 local var value are taken from buttonstyler.lua
local buttonsize = TukuiDB:Scale(30)
local buttonspacing = TukuiDB:Scale(2)
local petbuttonsize = TukuiDB:Scale(30)
local petbuttonspacing = TukuiDB:Scale(2)
local sbuttonsize = TukuiDB:Scale(28)
local sbuttonspacing = TukuiDB:Scale(1)
local cColor = TukuiDB["classy"]
local _, class = UnitClass("player")
local colorz = cColor[class]

-- TOP AND BOTTOM BORDERS
local function create_worldframe_background()
	local t = WorldFrame:CreateTexture(nil, "BACKGROUND")
	t:SetTexture(0, 0, 0, 1)
	t:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -2, 2)
	t:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", 2, -2)
	WorldFrame.bg = t
end

local topbar = CreateFrame("Frame", "TopBorder", UIParent)
TukuiDB:CreatePanel(topbar, 1, 1, "TOP", UIParent, "TOP", 0, 0)
topbar:ClearAllPoints()
topbar:SetPoint("TOPLEFT", UIParent, "TOPLEFT", TukuiDB:Scale(-10), TukuiDB:Scale(10))
topbar:SetPoint("BOTTOMRIGHT", UIParent, "TOPRIGHT", TukuiDB:Scale(10), TukuiDB:Scale(-20))
topbar:SetFrameStrata("BACKGROUND")

local bottombar = CreateFrame("Frame", "BottomBorder", UIParent)
TukuiDB:CreatePanel(bottombar, 1, 1, "BOTTOM", UIParent, "BOTTOM", 0, 0)
bottombar:ClearAllPoints()
bottombar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", TukuiDB:Scale(-10), TukuiDB:Scale(-10))
bottombar:SetPoint("TOPRIGHT", UIParent, "BOTTOMRIGHT", TukuiDB:Scale(10), TukuiDB:Scale(20)) 
bottombar:SetFrameStrata("BACKGROUND")

-- ACTIONBAR BOTTOM PANEL
local barbg = CreateFrame("Frame", "ActionBarBackground", UIParent)
TukuiDB:CreatePanel(barbg, ((buttonsize * 12) + (buttonspacing * 13)), (buttonsize + (buttonspacing * 2)), "BOTTOM", UIParent, "BOTTOM", 0, TukuiDB:Scale(4), 5)
if TukuiDB["actionbar"].bottomrows == 2 then
	barbg:ClearAllPoints()
	barbg:SetPoint("BOTTOM", UIParent, "BOTTOM",0,TukuiDB:Scale(40))
else
	barbg:ClearAllPoints()
	barbg:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB:Scale(4))
end

-- ACTIONBAR TOP PANEL
local barbg2 = CreateFrame("Frame", "ActionBarBackground2", UIParent)
TukuiDB:CreatePanel(barbg2, ((buttonsize * 20) + (buttonspacing * 21)), (buttonsize + (buttonspacing * 2)), "BOTTOM", UIParent, "BOTTOM", 0, TukuiDB:Scale(4), 5)
if not TukuiDB["actionbar"].bottomrows == 2 then
	barbg2:SetAlpha(0)
end

--ALIGNMENT FRAME
local alignpan = CreateFrame("Frame", "AlignThis", UIParent)
local alignwidth = ActionBarBackground:GetWidth()
local alignheight = (WorldFrame:GetHeight() * 0.10)
TukuiDB:CreatePanel(alignpan, alignwidth, 1, "BOTTOM", ActionBarBackground, "TOP", TukuiDB:Scale(2), alignheight,5)

--PLAYER MAIN PANEL
local bottombox = CreateFrame("Frame", "MainPanel", UIParent)
TukuiDB:CreatePanel(bottombox, TukuiDB:Scale(250), TukuiDB:Scale(30), "BOTTOM",ActionBarBackground,"TOP",0,TukuiDB:Scale(6),5)
bottombox:SetFrameStrata("BACKGROUND")

-- INFO LEFT (FOR STATS)
local ileft = CreateFrame("Frame", "InfoLeft", UIParent)
TukuiDB:CreatePanel(ileft, (TukuiDB:Scale(TukuiDB["panels"].tinfowidth + 1)), TukuiDB:Scale(24), "BOTTOMLEFT", BottomBorder, "TOPLEFT", TukuiDB:Scale(14), TukuiDB:Scale(-15), 5)

-- INFO RIGHT (FOR STATS)
local iright = CreateFrame("Frame", "InfoRight", UIParent)
TukuiDB:CreatePanel(iright, (TukuiDB:Scale(TukuiDB["panels"].tinfowidth + 1)), TukuiDB:Scale(24), "BOTTOMRIGHT", BottomBorder, "TOPRIGHT", TukuiDB:Scale(-14), TukuiDB:Scale(-15), 5)

-- CHAT EDIT BG
local cebox = CreateFrame("Frame", "ChatEdit", UIParent)
TukuiDB:CreatePanel(cebox, (TukuiDB:Scale(TukuiDB["panels"].tinfowidth + 1)), TukuiDB:Scale(28), "CENTER", InfoLeft, "CENTER", 0, 0, 5)
cebox:SetFrameStrata("BACKGROUND")

-- CHAT EDIT BOX
local edit = CreateFrame("Frame", "ChatFrameEditBoxBackground", ChatFrameEditBox)
TukuiDB:CreatePanel(edit, 1, 1, "LEFT", "ChatFrameEditBox", "LEFT", 0, 0, 1)
edit:ClearAllPoints()
edit:SetAllPoints(ChatFrameEditBox)
edit:SetFrameStrata("HIGH")
edit:SetFrameLevel(2)
local function colorize(r,g,b)
	edit:SetBackdropBorderColor(r, g, b)
	edit:SetBackdropColor(r * 0.2, g * 0.2, b * 0.2)
end

hooksecurefunc("ChatEdit_UpdateHeader", function()
local type = DEFAULT_CHAT_FRAME.editBox:GetAttribute("chatType")
	if ( type == "CHANNEL" ) then
	local id = GetChannelName(DEFAULT_CHAT_FRAME.editBox:GetAttribute("channelTarget"))
		if id == 0 then
			colorize(0.6,0.6,0.6)
		else
			colorize(ChatTypeInfo[type..id].r,ChatTypeInfo[type..id].g,ChatTypeInfo[type..id].b)
		end
	else
		colorize(ChatTypeInfo[type].r,ChatTypeInfo[type].g,ChatTypeInfo[type].b)
	end
end)

--TIME
local minimaphead = CreateFrame("Frame", "MinimapHead", Minimap)
TukuiDB:CreatePanel(minimaphead, ((Minimap:GetWidth()) / 2), TukuiDB:Scale(22), "BOTTOMLEFT", Minimap, "BOTTOMLEFT", 0, -2,5)
minimaphead:SetFrameStrata("MEDIUM")

--ZONE TEXT
local minimapzone = CreateFrame("Frame", "MinimapZone", UIParent)
TukuiDB:CreatePanel(minimapzone, TukuiDB:Scale(20), TukuiDB:Scale(22), "TOPRIGHT", TopBorder, "BOTTOMRIGHT", TukuiDB:Scale(-14), TukuiDB:Scale(16),5)
minimapzone:SetFrameLevel(6)

--//BUTTONS BUTTONS//-----------------------------------------------------------
--TAB-BUTTON PANEL LEFT
local tabz = CreateFrame("Frame", "TabPanel", UIParent)
TukuiDB:CreatePanel(tabz, (TukuiDB:Scale(TukuiDB["panels"].tinfowidth + 1)), TukuiDB:Scale(28), "BOTTOM", InfoLeft, "BOTTOM", 0,0)
tabz:SetFrameStrata("LOW")

--MENU-BUTTON PANEL RIGHT
local mbpan = CreateFrame("Frame", "MBPanel", UIParent)
TukuiDB:CreatePanel(mbpan, (TukuiDB:Scale(TukuiDB["panels"].tinfowidth + 1)), TukuiDB:Scale(28), "BOTTOM", InfoRight, "BOTTOM", 0,0)
mbpan:SetFrameStrata("LOW")

--TAB OPTION 1
local opt1 = CreateFrame("Frame", "OPanel1", UIParent)
TukuiDB:CreatePanel(opt1, TukuiDB:Scale(72), TukuiDB:Scale(20), "LEFT", TabPanel, "LEFT", 5, 0) 


--TAB OPTION 2
local opt2 = CreateFrame("Frame", "OPanel2", UIParent)
TukuiDB:CreatePanel(opt2, TukuiDB:Scale(72), TukuiDB:Scale(20), "LEFT", OPanel1, "RIGHT", 1, 0) 


--TAB OPTION 3
local opt3 = CreateFrame("Frame", "OPanel3", UIParent)
TukuiDB:CreatePanel(opt3, TukuiDB:Scale(72), TukuiDB:Scale(20), "LEFT", OPanel2, "RIGHT", 1, 0) 


--TAB OPTION 4
local opt4 = CreateFrame("Frame", "OPanel4", UIParent)
TukuiDB:CreatePanel(opt4, TukuiDB:Scale(72), TukuiDB:Scale(20), "LEFT", OPanel3, "RIGHT", 1, 0) 


--TAB OPTION 5
local opt5 = CreateFrame("Frame", "OPanel5", UIParent)
TukuiDB:CreatePanel(opt5, TukuiDB:Scale(72), TukuiDB:Scale(20), "LEFT", MBPanel, "LEFT", 5, 0) 


--TAB OPTION 6
local opt6 = CreateFrame("Frame", "OPanel6", UIParent)
TukuiDB:CreatePanel(opt6, TukuiDB:Scale(72), TukuiDB:Scale(20), "LEFT", OPanel5, "RIGHT", 1, 0) 


--TAB OPTION 7
local opt7 = CreateFrame("Frame", "OPanel7", UIParent)
TukuiDB:CreatePanel(opt7, TukuiDB:Scale(72), TukuiDB:Scale(20), "LEFT", OPanel6, "RIGHT", 1, 0) 


--TAB OPTION 8
local opt8 = CreateFrame("Frame", "OPanel8", UIParent)
TukuiDB:CreatePanel(opt8, TukuiDB:Scale(72), TukuiDB:Scale(20), "LEFT", OPanel7, "RIGHT", 1, 0)

--ABRIGHT BAR BACKGROUND
if TukuiDB["actionbar"].rightbars >= 1 then
	local barbgr = CreateFrame("Frame", "ActionBarBackgroundRight", UIParent)
	TukuiDB:CreatePanel(barbgr, (buttonsize + (buttonspacing * 3)), ((buttonsize * 12) + (buttonspacing * 9)), "RIGHT", UIParent, "RIGHT", TukuiDB:Scale(-4),TukuiDB:Scale(-2),5)
	barbgr:SetFrameStrata("BACKGROUND")
end
--ABLEFT BAR BACKGROUND
if TukuiDB["actionbar"].rightbars == 2 then
	local barbgl = CreateFrame("Frame", "ActionBarBackgroundLeft", UIParent)
	TukuiDB:CreatePanel(barbgl, (buttonsize + (buttonspacing * 3)), ((buttonsize * 12) + (buttonspacing * 9)), "RIGHT", ActionBarBackgroundRight, "LEFT", TukuiDB:Scale(4),0,5)
	barbgl:SetFrameStrata("BACKGROUND")
end
--PetActionBar---
local petpanel = CreateFrame("Frame", "PetActionBarBackground", PetActionBarFrame)
TukuiDB:CreatePanel(petpanel, (petbuttonsize + (petbuttonspacing * 3)), ((petbuttonsize * 10) + (petbuttonspacing * 7)), "RIGHT", ActionBarBackgroundRight, "LEFT", TukuiDB:Scale(4),0,5)
if TukuiDB["actionbar"].rightbars == 2 then
	petpanel:ClearAllPoints()
	petpanel:SetPoint("RIGHT", ActionBarBackgroundLeft, "LEFT", TukuiDB:Scale(4),0)
else
	petpanel:ClearAllPoints()
	petpanel:SetPoint("RIGHT", ActionBarBackgroundRight, "LEFT", TukuiDB:Scale(4),0)
end
--THREATBAR BG-----
local tarth = CreateFrame ("Frame","TarThreat",UIParent)
TukuiDB:CreatePanel(tarth, TukuiDB:Scale(64), TukuiDB:Scale(14), "BOTTOM", AlignThis, "TOP", TukuiDB:Scale(4), TukuiDB:Scale(52),5)
tarth:SetFrameStrata("BACKGROUND")

--FPS/MEM FRAME
local mempanel = CreateFrame("Frame", "MemPanel", UIParent)
TukuiDB:CreatePanel(mempanel, TukuiDB:Scale(210), TukuiDB:Scale(22), "TOPLEFT", TopBorder, "BOTTOMLEFT", TukuiDB:Scale(18), TukuiDB:Scale(18),5)
mempanel:SetFrameLevel(6)


--BG FRAME
local bgzone = CreateFrame("Frame", "BGZone", UIParent)
TukuiDB:CreatePanel(bgzone, TukuiDB:Scale(330), TukuiDB:Scale(10), "TOPLEFT", TopBorder, "BOTTOMLEFT", TukuiDB:Scale(18), TukuiDB:Scale(18),5)
bgzone:SetFrameLevel(6)

--BATTLEGROUND STATS FRAME
if TukuiDB["datatext"].battleground == true then
	local bgframe = CreateFrame("Frame", "BattleGroundPanel", UIParent)
	TukuiDB:CreatePanel(bgframe, 1, 1, "CENTER", BGZone, "CENTER", 0, 0, 5)
	bgframe:SetAllPoints(BGZone)
	bgframe:SetFrameStrata("MEDIUM")
	bgframe:EnableMouse(true)
	local function OnEvent(self, event)
		if event == "PLAYER_ENTERING_WORLD" then
			inInstance, instanceType = IsInInstance()
			if inInstance and (instanceType == "pvp") then
				bgframe:Show()
				MemPanel:Hide()
			else
				bgframe:Hide()
				MemPanel:Show()
			end
		end
	end
	bgframe:SetScript("OnEnter", function(self)
	local numScores = GetNumBattlefieldScores()
		for i=1, numScores do
			name, killingBlows, honorKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone  = GetBattlefieldScore(i);
			if ( name ) then
				if ( name == UnitName("player") ) then
					GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, TukuiDB:Scale(4));
					GameTooltip:ClearLines()
					GameTooltip:AddLine(tukuilocal.datatext_ttstatsfor.."[|cffCC0033"..name.."|r]")
					GameTooltip:AddLine' '
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttkillingblows, killingBlows,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthonorkills, honorKills,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttdeaths, deaths,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthonorgain, honorGained,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_ttdmgdone, damageDone,1,1,1)
					GameTooltip:AddDoubleLine(tukuilocal.datatext_tthealdone, healingDone,1,1,1)                  
					GameTooltip:Show()
				end
			end
		end
	end) 
	bgframe:SetScript("OnLeave", function(self) GameTooltip:Hide() end)
	bgframe:RegisterEvent("PLAYER_ENTERING_WORLD")
	bgframe:SetScript("OnEvent", OnEvent)
end

local a = CreateFrame("Frame",nil,UIParent)  
a:RegisterEvent("PLAYER_LOGIN")

a:SetScript("OnEvent", function(self,event,unit)
  --calls
  create_worldframe_background()
end)