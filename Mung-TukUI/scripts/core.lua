
local index = GetCurrentResolution();
local resolution = select(index, GetScreenResolutions());
local tukuiversion = GetAddOnMetadata("Tukui", "Version")
local unitcolor = TukuiDB["media"].unitcolor
local unitshadowcolor = TukuiDB["media"].unitshadowcolor
local normTex = TukuiDB["media"].blank
local glowTex = TukuiDB["media"].glowTex
local cColor = TukuiDB["classy"]
local _, class = UnitClass("player")
local colorz = cColor[class]

function GetTukuiVersion()
	-- the tukui high reso whitelist
	if not (resolution == "1680x945"
		or resolution == "2560x1440" 
		or resolution == "1680x1050" 
		or resolution == "1920x1080" 
		or resolution == "1920x1200" 
		or resolution == "1600x900" 
		or resolution == "2048x1152" 
		or resolution == "1776x1000" 
		or resolution == "2560x1600" 
		or resolution == "1600x1200") then
			if TukuiDB["general"].overridelowtohigh == true then
				TukuiDB["general"].autoscale = true
				TukuiDB.lowversion = true
			else
				TukuiDB.lowversion = true
			end			
	end

	if TukuiDB["general"].autoscale == true then
		-- i'm putting a autoscale feature mainly for an easy auto install process
		-- we all know that it's not very effective to play via 1024x768 on an 0.64 uiscale :P
		-- with this feature on, it should auto choose a very good value for your current reso!
		TukuiDB["general"].uiscale = 768/string.match(({GetScreenResolutions()})[GetCurrentResolution()], "%d+x(%d+)")
	end

	if TukuiDB.lowversion then
		TukuiDB.raidscale = 0.8
	else
		TukuiDB.raidscale = 1
	end
end
GetTukuiVersion()

local mult = 768/string.match(GetCVar("gxResolution"), "%d+x(%d+)")/TukuiDB["general"].uiscale
local function scale(x)
    return mult*math.floor(x/mult+.5)
end

function TukuiDB:Scale(x) return scale(x) end
TukuiDB.mult = mult

--//FRAMEBUILDERS//--
function TukuiDB:mkButton(myframe,offset,color)
	local color = color or {0,0,0}
	local offset = offset or 3
	myframe.bg = myframe:CreateTexture(nil,"BORDER")
	myframe.bg:SetPoint("TOPLEFT",offset+1,offset*(-1)-1)
	myframe.bg:SetPoint("BOTTOMRIGHT",offset*(-1)-1,offset+1)
	myframe.bg:SetTexture(0,0,0,1)
	myframe.bg:SetGradientAlpha("VERTICAL",1,1,1,0.8,1,1,1,0.3)
	myframe.left = myframe:CreateTexture(nil,"OVERLAY")
	myframe.left:SetTexture(unpack(color))
	myframe.left:SetPoint("TOPLEFT",offset,offset*(-1))
	myframe.left:SetPoint("BOTTOMLEFT",offset,offset)
	myframe.left:SetWidth(2)
	myframe.right = myframe:CreateTexture(nil,"OVERLAY")
	myframe.right:SetTexture(unpack(color))
	myframe.right:SetPoint("TOPRIGHT",offset*(-1),offset*(-1))
	myframe.right:SetPoint("BOTTOMRIGHT",offset*(-1),offset)
	myframe.right:SetWidth(2)
	myframe.bottom = myframe:CreateTexture(nil,"OVERLAY")
	myframe.bottom:SetTexture(unpack(color))
	myframe.bottom:SetPoint("BOTTOMLEFT",offset,offset)
	myframe.bottom:SetPoint("BOTTOMRIGHT",offset*(-1),offset)
	myframe.bottom:SetHeight(2)
	myframe.top = myframe:CreateTexture(nil,"OVERLAY")
	myframe.top:SetTexture(unpack(color))
	myframe.top:SetPoint("TOPLEFT",offset,offset*(-1))
	myframe.top:SetPoint("TOPRIGHT",offset*(-1),offset)
	myframe.top:SetHeight(2)
	return myframe
end
function TukuiDB:mkButtonFlip(myframe,offset,color)
	local color = color or {0,0,0}
	local offset = offset or 3
	myframe.bg = myframe:CreateTexture(nil,"BORDER")
	myframe.bg:SetPoint("TOPLEFT",offset+1,offset*(-1)-1)
	myframe.bg:SetPoint("BOTTOMRIGHT",offset*(-1)-1,offset+1)
	myframe.bg:SetTexture(0,0,0,1)
	myframe.bg:SetGradientAlpha("VERTICAL",1,1,1,0.3,1,1,1,0.8)
	myframe.left = myframe:CreateTexture(nil,"OVERLAY")
	myframe.left:SetTexture(unpack(color))
	myframe.left:SetPoint("TOPLEFT",offset,offset*(-1))
	myframe.left:SetPoint("BOTTOMLEFT",offset,offset)
	myframe.left:SetWidth(2)
	myframe.right = myframe:CreateTexture(nil,"OVERLAY")
	myframe.right:SetTexture(unpack(color))
	myframe.right:SetPoint("TOPRIGHT",offset*(-1),offset*(-1))
	myframe.right:SetPoint("BOTTOMRIGHT",offset*(-1),offset)
	myframe.right:SetWidth(2)
	myframe.bottom = myframe:CreateTexture(nil,"OVERLAY")
	myframe.bottom:SetTexture(unpack(color))
	myframe.bottom:SetPoint("BOTTOMLEFT",offset,offset)
	myframe.bottom:SetPoint("BOTTOMRIGHT",offset*(-1),offset)
	myframe.bottom:SetHeight(2)
	myframe.top = myframe:CreateTexture(nil,"OVERLAY")
	myframe.top:SetTexture(unpack(color))
	myframe.top:SetPoint("TOPLEFT",offset,offset*(-1))
	myframe.top:SetPoint("TOPRIGHT",offset*(-1),offset)
	myframe.top:SetHeight(2)
	return myframe
end
function TukuiDB:mkHoriz(myframe,offset,color,dir)
	local color = color or {0,0,0}
	local offset = offset or 3
	myframe.bg = myframe:CreateTexture(nil,"BORDER")
	myframe.bg:SetPoint("TOPLEFT",offset+1,offset*(-1)-1)
	myframe.bg:SetPoint("BOTTOMRIGHT",offset*(-1)-1,offset+1)
	myframe.bg:SetTexture(0,0,0,1)
	if dir == nil then
		myframe.bg:SetGradientAlpha("HORIZONTAL",1,1,1,0.5,1,1,1,0.1)
	else
		myframe.bg:SetGradientAlpha("HORIZONTAL",1,1,1,0.1,1,1,1,0.5)
	end
	myframe.left = myframe:CreateTexture(nil,"OVERLAY")
	myframe.left:SetTexture(unpack(color))
	myframe.left:SetPoint("TOPLEFT",offset,offset*(-1))
	myframe.left:SetPoint("BOTTOMLEFT",offset,offset)
	myframe.left:SetWidth(2)
	myframe.right = myframe:CreateTexture(nil,"OVERLAY")
	myframe.right:SetTexture(unpack(color))
	myframe.right:SetPoint("TOPRIGHT",offset*(-1),offset*(-1))
	myframe.right:SetPoint("BOTTOMRIGHT",offset*(-1),offset)
	myframe.right:SetWidth(2)
	myframe.bottom = myframe:CreateTexture(nil,"OVERLAY")
	myframe.bottom:SetTexture(unpack(color))
	myframe.bottom:SetPoint("BOTTOMLEFT",offset,offset)
	myframe.bottom:SetPoint("BOTTOMRIGHT",offset*(-1),offset)
	myframe.bottom:SetHeight(2)
	myframe.top = myframe:CreateTexture(nil,"OVERLAY")
	myframe.top:SetTexture(unpack(color))
	myframe.top:SetPoint("TOPLEFT",offset,offset*(-1))
	myframe.top:SetPoint("TOPRIGHT",offset*(-1),offset)
	myframe.top:SetHeight(2)
	return myframe
end
function TukuiDB:mkGlass(myframe,hgt)
	local color = {0,0,0,0}
	local offset = 1
	local hite = hgt
	myframe.bg = myframe:CreateTexture(nil,"BORDER")
	myframe.bg:SetPoint("TOPLEFT",offset+1,offset*(-1)-1)
	myframe.bg:SetPoint("BOTTOMRIGHT",offset*(-1)-1,offset+1)
	myframe.bg:SetTexture(0,0,0,0)
	myframe.left = myframe:CreateTexture(nil,"OVERLAY")
	myframe.left:SetTexture(unpack(color))
	myframe.left:SetPoint("TOPLEFT",offset,offset*(-1))
	myframe.left:SetPoint("BOTTOMLEFT",offset,offset)
	myframe.left:SetWidth(2)
	myframe.right = myframe:CreateTexture(nil,"OVERLAY")
	myframe.right:SetTexture(unpack(color))
	myframe.right:SetPoint("TOPRIGHT",offset*(-1),offset*(-1))
	myframe.right:SetPoint("BOTTOMRIGHT",offset*(-1),offset)
	myframe.right:SetWidth(2)
	myframe.bottom = myframe:CreateTexture(nil,"OVERLAY")
	myframe.bottom:SetTexture(unpack(color))
	myframe.bottom:SetPoint("BOTTOMLEFT",offset,offset)
	myframe.bottom:SetPoint("BOTTOMRIGHT",offset*(-1),offset)
	myframe.bottom:SetHeight(2)
	myframe.top = myframe:CreateTexture(nil,"OVERLAY")
	myframe.top:SetTexture(unpack(color))
	myframe.top:SetPoint("TOPLEFT",offset,offset*(-1))
	myframe.top:SetPoint("TOPRIGHT",offset*(-1),offset)
	myframe.top:SetHeight(2)
	myframe.b = myframe:CreateTexture(nil,"OVERLAY")
	myframe.b:SetPoint("BOTTOMLEFT")
	myframe.b:SetPoint("BOTTOMRIGHT")
	myframe.b:SetHeight(hite + 3)
	myframe.b:SetTexture(0,0,0,1)
	myframe.b:SetGradientAlpha("VERTICAL",1,1,1,1,0,0,0,0)
	myframe.t = myframe:CreateTexture(nil,"OVERLAY")
	myframe.t:SetPoint("TOPLEFT")
	myframe.t:SetPoint("TOPRIGHT")
	myframe.t:SetHeight(hite - 3)
	myframe.t:SetTexture(0,0,0,1)
	myframe.t:SetGradientAlpha("VERTICAL",1,1,1,0,0,0,0,1)
	return myframe
end
function TukuiDB:CreatePanel(f, w, h, a1, p, a2, x, y, B)
	sh = scale(h)
	sw = scale(w)
	f:SetFrameLevel(1)
	f:SetHeight(sh)
	f:SetWidth(sw)
	f:SetFrameStrata("BACKGROUND")
	f:SetPoint(a1, p, a2, x, y)

	if B == nil then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }})
		f:SetBackdropBorderColor(unpack(unitshadowcolor))
		f:SetBackdropColor(unpack(unitcolor))
		TukuiDB:mkButton(f)
	elseif B == 1 then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }})
		f:SetBackdropBorderColor(unpack(unitshadowcolor))
		f:SetBackdropColor(unpack(unitcolor))
	elseif B == 2 then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }})
		f:SetBackdropBorderColor(unpack(unitshadowcolor))
		f:SetBackdropColor(unpack(unitcolor))
		TukuiDB:mkHoriz(f)
	elseif B == 3 then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }})
		f:SetBackdropBorderColor(unpack(unitshadowcolor))
		f:SetBackdropColor(unpack(unitcolor))
		TukuiDB:mkButtonFlip(f)
	elseif B == 4 then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 1, insets = { left = 1, right = 1, top = 1, bottom = 1 }}) 
		f:SetBackdropBorderColor(unpack(unitshadowcolor))
		f:SetBackdropColor(unpack(unitcolor))
		local h2 = (h / 2)
		TukuiDB:mkGlass(f,h2)
	end	
end

function TukuiDB:Pglow(pg, big)
	pg:SetPoint("TOPLEFT", TukuiDB:Scale(4), TukuiDB:Scale(-4))
	pg:SetPoint("BOTTOMRIGHT", TukuiDB:Scale(-4), TukuiDB:Scale(4))
	pg:SetBackdrop ( {
			bgfile = normTex,
		  edgeFile = glowTex, 
		  edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }
		})
	pg:SetBackdropBorderColor(colorz[1], colorz[2], colorz[3], 0.6)
	pg:SetBackdropColor(colorz[1], colorz[2], colorz[3], 0.9)
	pg:SetFrameLevel(0)
	if big == nil then
		TukuiDB:mkButton(pg)
	else
		TukuiDB:mkHoriz(pg)
	end
end

function TukuiDB:Nglow(ng, big)
	ng:ClearAllPoints()
	ng:SetPoint("TOPLEFT", TukuiDB:Scale(4), TukuiDB:Scale(-4))
	ng:SetPoint("BOTTOMRIGHT", TukuiDB:Scale(-4), TukuiDB:Scale(4))
	ng:SetBackdrop ( {
			bgfile = normTex,
		  edgeFile = glowTex, 
		  edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }
		})
	ng:SetBackdropBorderColor(0,0,0,0.6)
	ng:SetBackdropColor(unpack(unitcolor))
	ng:SetFrameLevel(0)
	if big == nil then
		TukuiDB:mkButton(ng)
	else
		TukuiDB:mkHoriz(ng)
	end
end

function TukuiDB:SetTemplate(f, glass)
	if glass == nil then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }}) 
		f:SetBackdropBorderColor(unpack(unitshadowcolor))
		f:SetBackdropColor(unpack(unitcolor))
		TukuiDB:mkButton(f)
	elseif glass == 1 then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }}) 
		f:SetBackdropBorderColor(0.2,0.2,0.2,0.5)
		f:SetBackdropColor(0.05,0.05,0.05,0.5)
		TukuiDB:mkHoriz(f)
	elseif glass == 2 then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 4, insets = { left = 3, right = 3, top = 3, bottom = 3 }}) 
		f:SetBackdropBorderColor(unpack(unitshadowcolor))
		f:SetBackdropColor(0.05,0.05,0.05,0.9)
	elseif glass == 3 then
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 }}) 
		f:SetBackdropBorderColor(0,0,0,0.5)
		f:SetBackdropColor(0,0,0,0.5)
	else
		f:SetBackdrop( {
			bgFile = normTex,
			edgeFile = glowTex,
			edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0 }}) 
		f:SetBackdropBorderColor(0,0,0,0)
		f:SetBackdropColor(0,0,0,0)
		--TukuiDB:mkButton(f)
	end
end

-----------///Pulsing Animation//------------------------
function TukuiDB:SetPulse(f, l, s, d1, d2)   ----(frame, loopingstate, scale)--------
	f.fade = f:CreateAnimationGroup()
	f.fadeAlpha = f.fade:CreateAnimation()
	f.fadeAlpha.parent = f
	f.fadeAlpha:SetScript("OnPlay", function(f)
	f.startAlpha = f.parent:GetAlpha()
	if f.startAlpha ~= 1 then
		f.endAlpha = 1
	else
		f.endAlpha = 0.1
	end
	end)
	f.fadeAlpha:SetScript("OnUpdate", function(f)		
		local new = f.startAlpha + ((f.endAlpha - f.startAlpha) * f:GetProgress())
		f.parent:SetAlpha(new)
	end)

	local pulseScale = s
	local d1 = d1 or 0.2
	local d2 = d2 or 0.6
	f.pulse = f:CreateAnimationGroup()
	if l == 1 then
		f.pulse:SetLooping("BOUNCE")
	end
	f.pulse[1] = f.pulse:CreateAnimation()
	f.pulse[1]:SetDuration(d1)
	f.pulse[1]:SetEndDelay(0.1)
	f.pulse[1]:SetOrder(1)
	f.pulse[1]:SetScript("OnUpdate", function(self)
		local p = self:GetRegionParent()
		p:SetFrameLevel(128)
		self:GetRegionParent():SetScale(1 + (pulseScale * self:GetProgress()))
		if not f.fade:IsPlaying() and l ~= 0 then
			f.fadeAlpha:SetDuration(d1)
			f.fade:Play()
		end
	end)

	f.pulse[2] = f.pulse:CreateAnimation()
	f.pulse[2]:SetDuration(d2)
	f.pulse[2]:SetOrder(2)
	f.pulse[2]:SetScript("OnUpdate", function(self)
		local p = self:GetRegionParent()
		p:SetFrameLevel(128)
		p:SetScale(1 + (pulseScale * (1 - self:GetProgress())))
		if not f.fade:IsPlaying() and l ~= 0 then
			f.fadeAlpha:SetDuration(d2)
			f.fade:Play()
		end
	end)

	f.pulse:SetScript("OnPlay", function()
		f.FrameLevel = f.FrameLevel or f:GetFrameLevel()
		f:SetFrameLevel(128)
	end)
	f.pulse:SetScript("OnStop", function()
		f:SetScale(1)
		if l ~= 0 then
			f.fade:Stop()
		end
		f:SetAlpha(1)
		if f.FrameLevel then
			f:SetFrameLevel(f.FrameLevel)
			f.FrameLevel = nil
		end
	end)
	f.pulse:SetScript("OnFinished", f.pulse:GetScript("OnStop"))
end

-------------------------------------------------
-------------------------------------------------

local function install()			
	SetCVar("buffDurations", 1)
	SetCVar("lootUnderMouse", 1)
	SetCVar("autoSelfCast", 1)
	SetCVar("secureAbilityToggle", 1)
	SetCVar("showItemLevel", 1)
	SetCVar("equipmentManager", 1)
	SetCVar("mapQuestDifficulty", 1)
	SetCVar("previewTalents", 1)
	SetCVar("scriptErrors", 0)
	SetCVar("nameplateShowFriends", 0)
	SetCVar("nameplateShowEnemies", 1)
	SetCVar("ShowClassColorInNameplate", 1)
	SetCVar("screenshotQuality", 10)
	SetCVar("cameraDistanceMax", 50)
	SetCVar("cameraDistanceMaxFactor", 3.4)
	SetCVar("chatLocked", 0)
	SetCVar("showClock", 0)
			
	-- Var ok, now setting chat frames.					
	FCF_ResetChatWindows()
	FCF_DockFrame(ChatFrame2)
	FCF_OpenNewWindow("Spam")
	FCF_OpenNewWindow("Whispers")

	FCF_OpenNewWindow("Loot")
	FCF_UnDockFrame(ChatFrame5)
	FCF_SetLocked(ChatFrame5, 0);
	ChatFrame5:Show();
	
	FCF_OpenNewWindow("Alert")
	FCF_UnDockFrame(ChatFrame6)
	FCF_SetLocked(ChatFrame6, 0);
	ChatFrame6:Show();
	
	ChatFrame_RemoveAllMessageGroups(ChatFrame1)
	ChatFrame_RemoveChannel(ChatFrame1, "Trade")
	ChatFrame_RemoveChannel(ChatFrame1, "General")
	ChatFrame_RemoveChannel(ChatFrame1, "LookingForGroup")
	ChatFrame_AddMessageGroup(ChatFrame1, "SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_OFFICER")
	ChatFrame_AddMessageGroup(ChatFrame1, "GUILD_ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_SAY")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_YELL")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_EMOTE")
	ChatFrame_AddMessageGroup(ChatFrame1, "MONSTER_BOSS_WHISPER")
	ChatFrame_AddMessageGroup(ChatFrame1, "ERRORS")
	ChatFrame_AddMessageGroup(ChatFrame1, "AFK")
	ChatFrame_AddMessageGroup(ChatFrame1, "DND")
	ChatFrame_AddMessageGroup(ChatFrame1, "IGNORED")
	ChatFrame_AddMessageGroup(ChatFrame1, "ACHIEVEMENT")
	ChatFrame_AddMessageGroup(ChatFrame1, "SYSTEM")	
			
	-- Setup the spam chat frame
	ChatFrame_RemoveAllMessageGroups(ChatFrame3)
	ChatFrame_AddChannel(ChatFrame3, "Trade")
	ChatFrame_AddChannel(ChatFrame3, "General")
	ChatFrame_AddChannel(ChatFrame3, "LookingForGroup")
	
	-- Setup the whisper chat frame
	ChatFrame_RemoveAllMessageGroups(ChatFrame4)
	ChatFrame_AddMessageGroup(ChatFrame4, "WHISPER")
	
	-- Setup the right chat
	ChatFrame_RemoveAllMessageGroups(ChatFrame5);
	ChatFrame_AddMessageGroup(ChatFrame5, "COMBAT_XP_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame5, "COMBAT_HONOR_GAIN")
	ChatFrame_AddMessageGroup(ChatFrame5, "COMBAT_FACTION_CHANGE")
	ChatFrame_AddMessageGroup(ChatFrame5, "LOOT")
	ChatFrame_AddMessageGroup(ChatFrame5, "MONEY")

	ChatFrame_RemoveAllMessageGroups(ChatFrame6);
	ChatFrame_AddMessageGroup(ChatFrame6, "BATTLEGROUND")
	ChatFrame_AddMessageGroup(ChatFrame6, "BATTLEGROUND_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame6, "BG_HORDE")
	ChatFrame_AddMessageGroup(ChatFrame6, "BG_ALLIANCE")
	ChatFrame_AddMessageGroup(ChatFrame6, "BG_NEUTRAL")
	ChatFrame_AddMessageGroup(ChatFrame6, "PARTY")
	ChatFrame_AddMessageGroup(ChatFrame6, "PARTY_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame6, "RAID")
	ChatFrame_AddMessageGroup(ChatFrame6, "RAID_LEADER")
	ChatFrame_AddMessageGroup(ChatFrame6, "RAID_WARNING")
	
	-- enable classcolor automatically on login and on each character without doing /configure each time.
	ToggleChatColorNamesByClassGroup(true, "SAY")
	ToggleChatColorNamesByClassGroup(true, "EMOTE")
	ToggleChatColorNamesByClassGroup(true, "YELL")
	ToggleChatColorNamesByClassGroup(true, "GUILD")
	ToggleChatColorNamesByClassGroup(true, "GUILD_OFFICER")
	ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
	ToggleChatColorNamesByClassGroup(true, "WHISPER")
	ToggleChatColorNamesByClassGroup(true, "PARTY")
	ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID")
	ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
	ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
	ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
	ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
		
		if not (IsAddOnLoaded("Tukui_Heal_Layout")) then
			EnableAddOn("Tukui_Heal_Layout") 
			DisableAddOn("Tukui_Dps_Layout")
		end
	
	t10installed = true
			
	ReloadUI()
end

local function DisableTukui()
		DisableAddOn("Tukui"); 
		ReloadUI()
end

------------------------------------------------------------------------
--	Popups
------------------------------------------------------------------------

StaticPopupDialogs["DISABLE_UI"] = {
	text = tukuilocal.popup_disableui,
	button1 = ACCEPT,
	button2 = CANCEL,
	OnAccept = DisableTukui,
	timeout = 0,
	whileDead = 1,
	hideOnEscape = 1
}

StaticPopupDialogs["INSTALL_UI"] = {
	text = tukuilocal.popup_install,
    button1 = "OK",
    OnAccept = install,
    timeout = 0,
    whileDead = 1,
}

StaticPopupDialogs["DISABLE_RAID"] = {
	text = tukuilocal.popup_2raidactive,
	button1 = "ENABLE RAID FRAMES",
	OnAccept = function() EnableAddOn("Tukui_Heal_Layout") DisableAddOn("Tukui_Dps_Layout") ReloadUI() end,
	timeout = 0,
	whileDead = 1,
}

------------------------------------------------------------------------
--	On login function, look for some infos!
------------------------------------------------------------------------

local TukuiOnLogon = CreateFrame("Frame")
TukuiOnLogon:RegisterEvent("PLAYER_ENTERING_WORLD")
TukuiOnLogon:SetScript("OnEvent", function()
        TukuiOnLogon:UnregisterEvent("PLAYER_ENTERING_WORLD")
        TukuiOnLogon:SetScript("OnEvent", nil)
		
		--need a.b. to always be enabled
		if TukuiDB["actionbar"].enable == true then
			SetActionBarToggles( 1, 1, 1, 1, 1)
		end
	
		if resolution == "800x600"
			or resolution == "1024x768"
			or resolution == "720x576"
			or resolution == "1024x600" -- eeepc reso
			or resolution == "1152x864" then
				SetCVar("useUiScale", 0)
				StaticPopup_Show("DISABLE_UI")
		else
			SetCVar("useUiScale", 1)
			if TukuiDB["general"].multisampleprotect == true then
				SetMultisampleFormat(1)
			end
			SetCVar("uiScale", TukuiDB["general"].uiscale)
			if not (t10installed) then
				-- ugly shit
				SetCVar("alwaysShowActionBars", 0)
				StaticPopup_Show("INSTALL_UI")
			end
		end
		
		if not (IsAddOnLoaded("Tukui_Heal_Layout")) then
			StaticPopup_Show("DISABLE_RAID")
		end
		
		SetCVar("showArenaEnemyFrames", 0)
		
		print(tukuilocal.core_welcome1..tukuiversion)
		print(tukuilocal.core_welcome2)
end)

------------------------------------------------------------------------
--	UI HELP
------------------------------------------------------------------------

-- Print Help Messages
local function UIHelp()
	print(" ")
	print("No one can help you...")
	print("...but since you asked.")
	print("type /wf to move quest watch")
	print("type /mss to move your shapeshift bar")
	print("type /uf to move unitframes")
	print("type /gm to open help tickets")
	print("type /rd to quickly disband a group")
	print(" ")
end

SLASH_UIHELP1 = "/UIHelp"
SlashCmdList["UIHELP"] = UIHelp

------------------------------------------------------------------------
-- move some frames
------------------------------------------------------------------------
if TukuiDB["watchframe"].movable == true then
	local wf = WatchFrame
	local wfmove = false 

	wf:SetMovable(true)
	wf:SetClampedToScreen(false) 
	wf:ClearAllPoints()
	wf:SetPoint("TOPRIGHT", Minimap, "BOTTOMRIGHT", TukuiDB:Scale(17), TukuiDB:Scale(-80))
	wf:SetWidth(TukuiDB:Scale(250))
	wf:SetHeight(TukuiDB:Scale(600))
	wf:SetUserPlaced(true)
	wf.SetPoint = function() end
	wf.ClearAllPoints = function() end

	local function WATCHFRAMELOCK()
		if wfmove == false then
			wfmove = true
			print(tukuilocal.core_wf_unlock)
			wf:EnableMouse(true);
			wf:RegisterForDrag("LeftButton"); 
			wf:SetScript("OnDragStart", wf.StartMoving); 
			wf:SetScript("OnDragStop", wf.StopMovingOrSizing);
		elseif wfmove == true then
			wf:EnableMouse(false);
			wfmove = false
			print(tukuilocal.core_wf_lock)
		end
	end

	SLASH_WATCHFRAMELOCK1 = "/wf"
	SlashCmdList["WATCHFRAMELOCK"] = WATCHFRAMELOCK
end

hooksecurefunc(DurabilityFrame,"SetPoint",function(self,_,parent) -- durability frame
    if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
        DurabilityFrame:ClearAllPoints();
		if TukuiDB["actionbar"].bottomrows == true then
			DurabilityFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB:Scale(228));		
		else
			DurabilityFrame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB:Scale(200));
		end
    end
end);

hooksecurefunc(VehicleSeatIndicator,"SetPoint",function(_,_,parent) -- vehicle seat indicator
    if (parent == "MinimapCluster") or (parent == _G["MinimapCluster"]) then
		VehicleSeatIndicator:ClearAllPoints();
		VehicleSeatIndicator:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 150, TukuiDB:Scale(-20));
    end
end)

local function captureupdate()
	for i = 1, NUM_EXTENDED_UI_FRAMES do
		local cb = _G["WorldStateCaptureBar"..i]
		if cb and cb:IsShown() then
			cb:ClearAllPoints()
			cb:SetPoint("TOP", TopBorder, "BOTTOM", 0, TukuiDB:Scale(15))
			cb:SetScale(1.2)
		end
	end
end
hooksecurefunc("WorldStateAlwaysUpFrame_Update", captureupdate)

------------------------------------------------------------------------
--	GM ticket fix
------------------------------------------------------------------------

TicketStatusFrame:ClearAllPoints()
TicketStatusFrame:SetPoint("TOPLEFT", 0, 0)

------------------------------------------------------------------------
--	achievement micro fix
------------------------------------------------------------------------

AchievementMicroButton_Update = function() end

------------------------------------------------------------------------
--	commands we need
------------------------------------------------------------------------

SLASH_GM1 = "/gm"
SlashCmdList["GM"] = GM
SlashCmdList.DISABLE_ADDON = function(s) DisableAddOn(s) ReloadUI() end
SLASH_DISABLE_ADDON1 = "/disable"
SlashCmdList.ENABLE_ADDON = function(s) EnableAddOn(s) LoadAddOn(s) ReloadUI() end
SLASH_ENABLE_ADDON1 = "/enable"
SLASH_CONFIGURE1 = "/resetui"
SlashCmdList.CONFIGURE = function() StaticPopup_Show("INSTALL_UI") end

local function HEAL()
--	DisableAddOn("Tukui_Dps_Layout"); 
	EnableAddOn("Tukui_Heal_Layout"); 
	ReloadUI();
end

SLASH_HEAL1 = "/heal"
SlashCmdList["HEAL"] = HEAL

local function DPS()
	EnableAddOn("Tukui_Heal_Layout");
--	EnableAddOn("Tukui_Dps_Layout");
	ReloadUI();
end

SLASH_DPS1 = "/dps"
SlashCmdList["DPS"] = DPS

------------------------------------------------------------------------
--	Raid or party disband command : Idea,Credit,Code -> Shestak, MonoLiT
------------------------------------------------------------------------

SlashCmdList["GROUPDISBAND"] = function()
		local pName = UnitName("player")
		SendChatMessage("Disbanding group.", "RAID" or "PARTY")
		if UnitInRaid("player") then
			for i = 1, GetNumRaidMembers() do
				local name, _, _, _, _, _, _, online = GetRaidRosterInfo(i)
				if online and name ~= pName then
					UninviteUnit(name)
				end
			end
		else
			for i = MAX_PARTY_MEMBERS, 1, -1 do
				if GetPartyMember(i) then
					UninviteUnit(UnitName("party"..i))
				end
			end
		end
		LeaveParty()
end
SLASH_GROUPDISBAND1 = '/rd'

----------------------------------------------------------------------------------------
-- Class color guild and bg list
----------------------------------------------------------------------------------------

local GUILD_INDEX_MAX = 12
local SMOOTH = {
	1, 0, 0,
	1, 1, 0,
	0, 1, 0,
}
local myName = UnitName"player"

local BC = {}
for k, v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
	BC[v] = k
end
for k, v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
	BC[v] = k
end

local RAID_CLASS_COLORS = CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS

local function Hex(r, g, b)
	if(type(r) == "table") then
		if(r.r) then r, g, b = r.r, r.g, r.b else r, g, b = unpack(r) end
	end
	
	if(not r or not g or not b) then
		r, g, b = 1, 1, 1
	end
	
	return format("|cff%02x%02x%02x", r*255, g*255, b*255)
end

-- http://www.wowwiki.com/ColorGradient
local function ColorGradient(perc, ...)
	if perc >= 1 then
		local r, g, b = select(select("#", ...) - 2, ...)
		return r, g, b
	elseif perc <= 0 then
		local r, g, b = ...
		return r, g, b
	end
	
	local num = select("#", ...) / 3

	local segment, relperc = math.modf(perc*(num-1))
	local r1, g1, b1, r2, g2, b2 = select((segment*3)+1, ...)

	return r1 + (r2-r1)*relperc, g1 + (g2-g1)*relperc, b1 + (b2-b1)*relperc
end

--GuildControlGetNumRanks()
--GuildControlGetRankName(index)
local guildRankColor = setmetatable({}, {
	__index = function(t, i)
		if i then
			t[i] = {ColorGradient(i/GUILD_INDEX_MAX, unpack(SMOOTH))}
		end
		return i and t[i] or {1,1,1}
	end
})

local diffColor = setmetatable({}, {
	__index = function(t,i)
		local c = i and GetQuestDifficultyColor(i)
		if not c then return "|cffffffff" end
		t[i] = Hex(c)
		return t[i]
	end
})

local classColorHex = setmetatable({}, {
	__index = function(t,i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if not c then return "|cffffffff" end
		t[i] = Hex(c)
		return t[i]
	end
})

local classColors = setmetatable({}, {
	__index = function(t,i)
		local c = i and RAID_CLASS_COLORS[BC[i] or i]
		if not c then return {1,1,1} end
		t[i] = {c.r, c.g, c.b}
		return t[i]
	end
})

if CUSTOM_CLASS_COLORS then
	local function callBack()
		wipe(classColorHex)
		wipe(classColors)
	end
	CUSTOM_CLASS_COLORS:RegisterCallback(callBack)
end


--FRIENDS_LEVEL_TEMPLATE = "Level %d %s" -- For "name location" in friends list
local FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%%d", "%%s")
FRIENDS_LEVEL_TEMPLATE = FRIENDS_LEVEL_TEMPLATE:gsub("%$d", "%$s") -- "%2$s %1$d-?? ??????"
hooksecurefunc("FriendsList_Update", function()
	local friendOffset = FauxScrollFrame_GetOffset(FriendsFrameFriendsScrollFrame)
	local friendIndex
	local playerArea = GetRealZoneText()
	
	for i=1, FRIENDS_TO_DISPLAY, 1 do
		friendIndex = friendOffset + i
		local name, level, class, area, connected, status, note, RAF = GetFriendInfo(friendIndex)
		local nameText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextName")
		local LocationText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextLocation")
		local infoText = getglobal("FriendsFrameFriendButton"..i.."ButtonTextInfo")
		if not name then return end
		if connected then
			nameText:SetVertexColor(unpack(classColors[class]))
			if area == playerArea then
				area = format("|cff00ff00%s|r", area)
				LocationText:SetFormattedText(FRIENDS_LIST_TEMPLATE, area, status)
			end
			level = diffColor[level] .. level .. "|r"
			--class = classColorHex[class] .. class
			infoText:SetFormattedText(FRIENDS_LEVEL_TEMPLATE, level, class)
		else
			return
		end
	end
end)


hooksecurefunc("GuildStatus_Update", function()
	local playerArea = GetRealZoneText()
	
	if ( FriendsFrame.playerStatusFrame ) then
		local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
		local guildIndex
		
		for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
			guildIndex = guildOffset + i
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(guildIndex)
			if not name then return end
			if online then
				local nameText = getglobal("GuildFrameButton"..i.."Name")
				local zoneText = getglobal("GuildFrameButton"..i.."Zone")
				local levelText = getglobal("GuildFrameButton"..i.."Level")
				local classText = getglobal("GuildFrameButton"..i.."Class")
				
				nameText:SetVertexColor(unpack(classColors[class]))
				if playerArea == zone then
					zoneText:SetFormattedText("|cff00ff00%s|r", zone)
				end
				levelText:SetText(diffColor[level] .. level)
			end
		end
	else
		local guildOffset = FauxScrollFrame_GetOffset(GuildListScrollFrame)
		local guildIndex
		
		for i=1, GUILDMEMBERS_TO_DISPLAY, 1 do
			guildIndex = guildOffset + i
			local name, rank, rankIndex, level, class, zone, note, officernote, online, status, classFileName = GetGuildRosterInfo(guildIndex)
			if not name then return end
			if online then
				local nameText = getglobal("GuildFrameGuildStatusButton"..i.."Name")
				nameText:SetVertexColor(unpack(classColors[class]))
				
				local rankText = getglobal("GuildFrameGuildStatusButton"..i.."Rank")
				rankText:SetVertexColor(unpack(guildRankColor[rankIndex]))
			end
		end
	end
end)


hooksecurefunc("WhoList_Update", function()
	local whoIndex
	local whoOffset = FauxScrollFrame_GetOffset(WhoListScrollFrame)
	
	local playerZone = GetRealZoneText()
	local playerGuild = GetGuildInfo"player"
	local playerRace = UnitRace"player"
	
	for i=1, WHOS_TO_DISPLAY, 1 do
		whoIndex = whoOffset + i
		local nameText = getglobal("WhoFrameButton"..i.."Name")
		local levelText = getglobal("WhoFrameButton"..i.."Level")
		local classText = getglobal("WhoFrameButton"..i.."Class")
		local variableText = getglobal("WhoFrameButton"..i.."Variable")
		
		local name, guild, level, race, class, zone, classFileName = GetWhoInfo(whoIndex)
		if not name then return end
		if zone == playerZone then
			zone = "|cff00ff00" .. zone
		end
		if guild == playerGuild then
			guild = "|cff00ff00" .. guild
		end
		if race == playerRace then
			race = "|cff00ff00" .. race
		end
		local columnTable = { zone, guild, race }
		
		nameText:SetVertexColor(unpack(classColors[class]))
		levelText:SetText(diffColor[level] .. level)
		variableText:SetText(columnTable[UIDropDownMenu_GetSelectedID(WhoFrameDropDown)])
	end
end)


hooksecurefunc("LFRBrowseFrameListButton_SetData", function(button, index)
	local name, level, areaName, className, comment, partyMembers, status, class, encountersTotal, encountersComplete, isLeader, isTank, isHealer, isDamage = SearchLFGGetResults(index)
	
	local c = class and classColors[class]
	if c then
		button.name:SetTextColor(unpack(c))
		button.class:SetTextColor(unpack(c))
	end
	if level then
		button.level:SetText(diffColor[level] .. level)
	end
end)


hooksecurefunc("WorldStateScoreFrame_Update", function()
	local inArena = IsActiveBattlefieldArena()
	for i = 1, MAX_WORLDSTATE_SCORE_BUTTONS do
		local index = FauxScrollFrame_GetOffset(WorldStateScoreScrollFrame) + i
		local name, killingBlows, honorableKills, deaths, honorGained, faction, rank, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(index)
		-- faction: Battlegrounds: Horde = 0, Alliance = 1 / Arenas: Green Team = 0, Yellow Team = 1
		if name then
			local n, r = strsplit("-", name, 2)
			n = classColorHex[classToken] .. n .. "|r"
			if n == myName then
				n = "> " .. n .. " <"
			end
			
			if r then
				local color
				if inArena then
					if faction == 1 then
						color = "|cffffd100"
					else
						color = "|cff19ff19"
					end
				else
					if faction == 1 then
						color = "|cff00adf0"
					else
						color = "|cffff1919"
					end
				end
				r = color .. r .. "|r"
				n = n .. "|cffffffff-|r" .. r
			end
			
			local buttonNameText = getglobal("WorldStateScoreButton" .. i .. "NameText")
			buttonNameText:SetText(n)
		end
	end
end)

----------------------------------------------------------------------------------------
-- Quest level(yQuestLevel by yleaf)
----------------------------------------------------------------------------------------

local function update()
	local buttons = QuestLogScrollFrame.buttons
	local numButtons = #buttons
	local scrollOffset = HybridScrollFrame_GetOffset(QuestLogScrollFrame)
	local numEntries, numQuests = GetNumQuestLogEntries()
	
	for i = 1, numButtons do
		local questIndex = i + scrollOffset
		local questLogTitle = buttons[i]
		if questIndex <= numEntries then
			local title, level, questTag, suggestedGroup, isHeader, isCollapsed, isComplete, isDaily = GetQuestLogTitle(questIndex)
			if not isHeader then
				questLogTitle:SetText("[" .. level .. "] " .. title)
				QuestLogTitleButton_Resize(questLogTitle)
			end
		end
	end
end

hooksecurefunc("QuestLog_Update", update)
QuestLogScrollFrameScrollBar:HookScript("OnValueChanged", update)

----------------------------------------------------------------------------------------
-- fix the fucking combatlog after a crash (a wow 2.4 and 3.3.2 bug)
----------------------------------------------------------------------------------------

local function CLFIX()
	CombatLogClearEntries()
end

SLASH_CLFIX1 = "/clfix"
SlashCmdList["CLFIX"] = CLFIX

----------------------------------------------------------------------------------------
-- Script to fix wintergrasp mount, /cast [flyable] Flying Mount Name; Ground Mount Name
-- is not working when wintergrasp is in progress, it return nothing. :(
-- Also can exit vehicule if you are on a friend mechano, mammooth, etc
-- example of use : /mounter Amani War Bear, Relentless Gladiator's Frost Wyrm
----------------------------------------------------------------------------------------

local WINTERGRASP
WINTERGRASP = tukuilocal.mount_wintergrasp

local inFlyableWintergrasp = function()
	return GetZoneText() == WINTERGRASP and not GetWintergraspWaitTime()
end

local creatureCache, creatureId, creatureName
local mountCreatureName = function(name)
	local companionCount = GetNumCompanions("MOUNT")
	
	if not creatureCache or companionCount ~= #creatureCache then
		creatureCache = {}

		for i = 1, companionCount do
			creatureId, creatureName = GetCompanionInfo("MOUNT", i)
			creatureCache[creatureName] = i
		end
	end
	
	local creatureId = creatureCache[name]
	
	if creatureId then
		CallCompanion("MOUNT", creatureId)
		return true
	end
end

local argumentsPattern = "([^,]+),%s*(.+)"

SlashCmdList['MOUNTER'] = function(text, editBox)
	if CanExitVehicle() then
		VehicleExit()
	elseif not IsMounted() and not InCombatLockdown() then
		local groundMount, flyingMount = string.match(text, argumentsPattern)
		
		if not groundMount then
			groundMount = #text > 0 and text or nil
		end
		
		if groundMount then
			local mount = (flyingMount and IsFlyableArea() and not inFlyableWintergrasp()) and flyingMount or groundMount
			local success = mountCreatureName(mount)
			
			if not success then
				print("No such mount: " .. mount)
			end
		else
			print("Usage: /mounter <Ground mount>[, <Flying mount>]")
		end
	else
		Dismount()
	end
end

SLASH_MOUNTER1 = "/mounter"

------------------------------------------------------------------------
--	ReloadUI command
------------------------------------------------------------------------

SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

------------------------------------------------------------------------
--	What is this frame ?
------------------------------------------------------------------------
local function FRAME()
	ChatFrame1:AddMessage(GetMouseFocus():GetName()) 
end

SLASH_FRAME1 = "/frame"
SlashCmdList["FRAME"] = FRAME



------------------------------------------------------------------------
-- Auto accept invite
------------------------------------------------------------------------

if TukuiDB["invite"].autoaccept == true then
	local tAutoAcceptInvite = CreateFrame("Frame")
	local OnEvent = function(self, event, ...) self[event](self, event, ...) end
	tAutoAcceptInvite:SetScript("OnEvent", OnEvent)

	local function PARTY_MEMBERS_CHANGED()
		StaticPopup_Hide("PARTY_INVITE")
		tAutoAcceptInvite:UnregisterEvent("PARTY_MEMBERS_CHANGED")
	end

	local InGroup = false
	local function PARTY_INVITE_REQUEST()
		local leader = arg1
		InGroup = false
		
		-- Update Guild and Freindlist
		if GetNumFriends() > 0 then ShowFriends() end
		if IsInGuild() then GuildRoster() end
		
		for friendIndex = 1, GetNumFriends() do
			local friendName = GetFriendInfo(friendIndex)
			if friendName == leader then
				AcceptGroup()
				tAutoAcceptInvite:RegisterEvent("PARTY_MEMBERS_CHANGED")
				tAutoAcceptInvite["PARTY_MEMBERS_CHANGED"] = PARTY_MEMBERS_CHANGED
				InGroup = true
				break
			end
		end
		
		if not InGroup then
			for guildIndex = 1, GetNumGuildMembers(true) do
				local guildMemberName = GetGuildRosterInfo(guildIndex)
				if guildMemberName == leader then
					AcceptGroup()
					tAutoAcceptInvite:RegisterEvent("PARTY_MEMBERS_CHANGED")
					tAutoAcceptInvite["PARTY_MEMBERS_CHANGED"] = PARTY_MEMBERS_CHANGED
					InGroup = true
					break
				end
			end
		end
		
		if not InGroup then
			SendWho(leader)
		end
	end

	tAutoAcceptInvite:RegisterEvent("PARTY_INVITE_REQUEST")
	tAutoAcceptInvite["PARTY_INVITE_REQUEST"] = PARTY_INVITE_REQUEST
end

------------------------------------------------------------------------
-- Auto invite by whisper (enabling by slash command by foof)
------------------------------------------------------------------------

local ainvenabled = false
local ainvkeyword = "invite"

local autoinvite = CreateFrame("frame")
autoinvite:RegisterEvent("CHAT_MSG_WHISPER")
autoinvite:SetScript("OnEvent", function(self,event,arg1,arg2)
	if ((not UnitExists("party1") or IsPartyLeader("player")) and arg1:lower():match(ainvkeyword)) and ainvenabled == true then
		InviteUnit(arg2)
	end
end)

function SlashCmdList.AUTOINVITE(msg, editbox)
	if (msg == 'off') then
		ainvenabled = false
		print(tukuilocal.core_autoinv_disable)
	elseif (msg == '') then
		ainvenabled = true
		print(tukuilocal.core_autoinv_enable)
		ainvkeyword = "invite"
	else
		ainvenabled = true
		print(tukuilocal.core_autoinv_enable_c .. msg)
		ainvkeyword = msg
	end
end
SLASH_AUTOINVITE1 = '/ainv'

------------------------------------------------------------------------
-- prevent action bar users config errors
------------------------------------------------------------------------

if TukuiDB["actionbar"].bottomrows == 0 or TukuiDB["actionbar"].bottomrows > 2 then
	TukuiDB["actionbar"].bottomrows = 1
end

if TukuiDB["actionbar"].rightbars > 2 then
	TukuiDB["actionbar"].rightbars = 2
end

if not TukuiDB.lowversion and TukuiDB["actionbar"].bottomrows == 2 and TukuiDB["actionbar"].rightbars > 1 then
	TukuiDB["actionbar"].rightbars = 1
end

------------------------------------------------------------------------
-- enable lua error
------------------------------------------------------------------------

function SlashCmdList.LUAERROR(msg, editbox)
	if (msg == 'on') then
		SetCVar("scriptErrors", 1)
		-- because sometime we need to /rl to show error.
		ReloadUI()
	elseif (msg == 'off') then
		SetCVar("scriptErrors", 0)
	else
		print("/luaerror on - /luaerror off")
	end
end
SLASH_LUAERROR1 = '/luaerror'

--------------------------------------------------------------------------
-- vehicule on mouseover because this shit take too much space on screen
--------------------------------------------------------------------------

-- note : there is probably a better way to do this but at least it work
-- this is the only way i found to know how many button we have on VehiculeSeatIndicator :(

local function vehmousebutton(alpha)
	local numSeat

	if VehicleSeatIndicatorButton1 then
		numSeat = 1
	elseif VehicleSeatIndicatorButton2 then
		numSeat = 2
	elseif VehicleSeatIndicatorButton3 then
		numseat = 3
	elseif VehicleSeatIndicatorButton4 then
		numSeat = 4
	elseif VehicleSeatIndicatorButton5 then
		numSeat = 5
	elseif VehicleSeatIndicatorButton6 then
		numSeat = 6
	end

	for i=1, numSeat do
	local pb = _G["VehicleSeatIndicatorButton"..i]
		pb:SetAlpha(alpha)
	end
end

local function vehmouse()
	if VehicleSeatIndicator:IsShown() then
		VehicleSeatIndicator:SetAlpha(0)
		VehicleSeatIndicator:EnableMouse(true)
		VehicleSeatIndicator:HookScript("OnEnter", function() VehicleSeatIndicator:SetAlpha(1) vehmousebutton(1) end)
		VehicleSeatIndicator:HookScript("OnLeave", function() VehicleSeatIndicator:SetAlpha(0) vehmousebutton(0) end)

		local numSeat

		if VehicleSeatIndicatorButton1 then
			numSeat = 1
		elseif VehicleSeatIndicatorButton2 then
			numSeat = 2
		elseif VehicleSeatIndicatorButton3 then
			numseat = 3
		elseif VehicleSeatIndicatorButton4 then
			numSeat = 4
		elseif VehicleSeatIndicatorButton5 then
			numSeat = 5
		elseif VehicleSeatIndicatorButton6 then
			numSeat = 6
		end

		for i=1, numSeat do
			local pb = _G["VehicleSeatIndicatorButton"..i]
			pb:SetAlpha(0)
			pb:HookScript("OnEnter", function(self) VehicleSeatIndicator:SetAlpha(1) vehmousebutton(1) end)
			pb:HookScript("OnLeave", function(self) VehicleSeatIndicator:SetAlpha(0) vehmousebutton(0) end)
		end
	end
end
hooksecurefunc("VehicleSeatIndicator_Update", vehmouse)

--------------------------------------------------------------------------
-- modify the frame strata because of buffs
--------------------------------------------------------------------------
WorldStateAlwaysUpFrame:ClearAllPoints()
WorldStateAlwaysUpFrame:SetPoint("TOP", UIParent, "TOP", 0, -30)
WorldStateAlwaysUpFrame:SetFrameStrata("BACKGROUND")
WorldStateAlwaysUpFrame:SetFrameLevel(0)
