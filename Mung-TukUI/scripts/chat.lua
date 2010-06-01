if TukuiDB["chat"].enable ~= true then return end

local AddOn = CreateFrame("Frame")
local OnEvent = function(self, event, ...) self[event](self, event, ...) end
AddOn:SetScript("OnEvent", OnEvent)

local _G = _G
local replace = string.gsub
local find = string.find
local cColor = TukuiDB["classy"]
local _, class = UnitClass("player")
local colorz = cColor[class]
local replaceschan = {
	['Гильдия'] = '[Г]',
	['Группа'] = '[Гр]',
	['Рейд'] = '[Р]',
	['Лидер рейда'] = '[ЛР]',
	['Объявление рейду'] = '[ОР]',
	['Офицер'] = '[О]',
	['Поле боя'] = '[ПБ]',
	['Лидер поля боя'] = '[ЛПБ]', 
	['Guilde'] = '[G]',
	['Groupe'] = '[GR]',
	['Chef de raid'] = '[RL]',
	['Avertissement Raid'] = '[AR]',
	['Officier'] = '[O]',
	['Champs de bataille'] = '[CB]',
	['Chef de bataille'] = '[CDB]',
	['Guild'] = '[G]',
	['Party'] = '[P]',
	['Party Leader'] = '[PL]',
	['Dungeon Guide'] = '[DG]',
	['Raid'] = '[R]',
	['Raid Leader'] = '[RL]',
	['Raid Warning'] = '[RW]',
	['Officer'] = '[O]',
	['Battleground'] = '[B]',
	['Battleground Leader'] = '[BL]',
	['Gilde'] = '[G]',
	['Gruppe'] = '[Grp]',
	['Gruppenanführer'] = '[GrpL]',
	['Dungeonführer'] = '[DF]',
	['Schlachtzug'] = '[R]',
	['Schlachtzugsleiter'] = '[RL]',
	['Schlachtzugswarnung'] = '[RW]',
	['Offizier'] = '[O]',
	['Schlachtfeld'] = '[BG]',
	['Schlachtfeldleiter'] = '[BGL]',
	['Hermandad'] = '[H]',
	['Grupo'] = '[G]',
	['Líder del grupo'] = '[LG]',
	['Guía de mazmorra'] = '[GM]',
	['Banda'] = '[B]',
	['Líder de banda'] = '[LB]',
	['Aviso de banda'] = '[AB]',
	['Oficial'] = '[O]',
	['CampoDeBatalla'] = '[CB]',
	['Líder de batalla'] = '[LdB]',
	['(%d+)%. .-'] = '[%1]',
}

-- editbox background
local x=({ChatFrameEditBox:GetRegions()})
x[6]:SetAlpha(0)
x[7]:SetAlpha(0)
x[8]:SetAlpha(0)

--ChicChai Local Shizz
local maxHeight = 100				-- How high the chat frames are when maximized
local animTime = 0.3				-- How lang the animation takes (in seconds)
local minimizeTime = 5				-- Minimize after X seconds
local minimizedLines = 2			-- Number of chat messages to show in minimized state

local MaximizeOnEnter = true		-- Maximize when entering chat frame, minimize when leaving
local WaitAfterEnter = 0			-- Wait X seconds after entering before maximizing
local WaitAfterLeave = 0			-- Wait X seconds after leaving before minimizing

local LockInCombat = false			-- Do not maximize in combat

local MaximizeCombatLog = true		-- When the combat log is selected, it will be maximized

FCF_ValidateChatFramePosition = function() end	-- You can move chat frames completely to the bottom

-- Modify this to maximize only on special channels
-- comment/remove it to react on all channels

local ChatFrameConfig = {	-- Events which maximize the chat for the different windows
	["ChatFrame1"] = {
		"CHAT_MSG_GUILD",
		"CHAT_MSG_SYSTEM",
	},
	["ChatFrame3"] = {
		"CHAT_MSG_CHANNEL_JOIN",
		"CHAT_MSG_CHANNEL_LEAVE",		
	},
	["ChatFrame4"] = {
		"CHAT_MSG_WHISPER",
		"CHAT_MSG_WHISPER_INFORM",		
	},
	["ChatFrame5"] = {
	},
	["ChatFrame6"] = {
		"CHAT_MSG_BG_SYSTEM_ALLIANCE",
		"CHAT_MSG_BG_SYSTEM_HORDE",
		"CHAT_MSG_BG_SYSTEM_NEUTRAL",
		"CHAT_MSG_BATTLEGROUND",
		"CHAT_MSG_BATTLEGROUND_LEADER",
		"CHAT_MSG_PARTY",
		"CHAT_MSG_PARTY_LEADER",
		"CHAT_MSG_RAID",
		"CHAT_MSG_RAID_LEADER",
		"CHAT_MSG_SYSTEM"
	},
}
-- Configuration End

local select = select
local UP, DOWN = 1, -1

-- Player entering the world
local function PLAYER_ENTERING_WORLD()
	local TimeNotAtBottom = { }
	
	ChatFrameMenuButton:Hide()
	ChatFrameMenuButton:SetScript("OnShow", function(self) self:Hide() end)
	
	for i = 1, NUM_CHAT_WINDOWS do
		-- Hide chat buttons
		_G["ChatFrame"..i.."UpButton"]:Hide()
		_G["ChatFrame"..i.."DownButton"]:Hide()
		_G["ChatFrame"..i.."BottomButton"]:Hide()
		_G["ChatFrame"..i.."UpButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."DownButton"]:SetScript("OnShow", function(self) self:Hide() end)
		_G["ChatFrame"..i.."BottomButton"]:SetScript("OnShow", function(self) self:Hide() end)
		
		-- Hide chat textures backdrop

		for j = 1, #CHAT_FRAME_TEXTURES do
			_G["ChatFrame"..i..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
		end

		-- Stop the chat frame from fading out
		_G["ChatFrame"..i]:SetFading(false)

		-- Change the chat frame font
		if i == 6 then
			_G["ChatFrame"..i]:SetFont(TukuiDB["chat"].font, TukuiDB["chat"].fontsize2)
		else
			_G["ChatFrame"..i]:SetFont(TukuiDB["chat"].font, TukuiDB["chat"].fontsize)
		end
		
		-- Allow for scrolling through the chat
		-- Also force chat to the bottom after 30 seconds
		TimeNotAtBottom[i] = 0
		_G["ChatFrame"..i]:SetScript("OnMouseWheel", function(self, ...)
			if arg1 > 0 then
				self:ScrollUp()
				TimeNotAtBottom[i] = 0
				self:SetScript("OnUpdate", function(self, t)
					if TimeNotAtBottom[i] < 30 then
						TimeNotAtBottom[i] = TimeNotAtBottom[i] + t
					else
						self:ScrollToBottom()
						self:SetScript("OnUpdate", nil)
					end
				end)
			elseif arg1 < 0 then
				if IsShiftKeyDown() then
					self:ScrollToBottom()
					self:SetScript("OnUpdate", nil)
				else
					self:ScrollDown()
					if self:AtBottom() then
						self:SetScript("OnUpdate", nil)
					else
						TimeNotAtBottom[i] = 0
					end
				end
			end
		end)
		_G["ChatFrame"..i]:EnableMouseWheel(true)
		_G["ChatFrame"..i]:SetFrameStrata("LOW")
		_G["ChatFrame"..i]:SetUserPlaced(true)
			
	end
	
	-- Remember last channel
	ChatTypeInfo.WHISPER.sticky = 1
	ChatTypeInfo.OFFICER.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	ChatTypeInfo.CHANNEL.sticky = 1
	
	-- Texture and align the chat edit box
	local left, mid, right = select(6, ChatFrameEditBox:GetRegions())
	left:Hide(); mid:Hide(); right:Hide()
	ChatFrameEditBox:ClearAllPoints();

	ChatFrameEditBox:SetPoint("TOPLEFT", ChatEdit, TukuiDB:Scale(2), TukuiDB:Scale(-2))
	ChatFrameEditBox:SetPoint("BOTTOMRIGHT", ChatEdit, TukuiDB:Scale(-2), TukuiDB:Scale(2))	

	-- Disable alt key usage
	ChatFrameEditBox:SetAltArrowKeyMode(false)
	
	 -- Align the text to the right on cf6
	ChatFrame6:SetJustifyH("RIGHT")
	
	-- Position the chatframe 5
	ChatFrame5:ClearAllPoints()
	ChatFrame5:SetPoint("BOTTOMLEFT", TabPanel, "TOPLEFT", TukuiDB:Scale(8), TukuiDB:Scale(10))
	ChatFrame5:SetWidth(TukuiDB:Scale(TukuiDB["panels"].tinfowidth - 14))
	ChatFrame5:SetHeight(TukuiDB:Scale(75))
	
	-- Position the general chat frame
	ChatFrame1:ClearAllPoints()
	ChatFrame1:SetPoint("BOTTOMLEFT", ChatFrame5, "TOPLEFT", 0, TukuiDB:Scale(10))
	ChatFrame1:SetWidth(TukuiDB:Scale(TukuiDB["panels"].tinfowidth - 14))
	ChatFrame1:SetHeight(TukuiDB:Scale(100))
		
	-- Position the chatframe 6
	ChatFrame6:ClearAllPoints()
	ChatFrame6:SetPoint("BOTTOMLEFT", MBPanel, "TOPLEFT", TukuiDB:Scale(8), TukuiDB:Scale(10))
	ChatFrame6:SetWidth(TukuiDB:Scale(TukuiDB["panels"].tinfowidth - 14))
	ChatFrame6:SetHeight(TukuiDB:Scale(100))
end

AddOn:RegisterEvent("PLAYER_ENTERING_WORLD")
AddOn["PLAYER_ENTERING_WORLD"] = PLAYER_ENTERING_WORLD

-- Get colors for player classes
local function ClassColors(class)
	if not class then return end
	class = (replace(class, " ", "")):upper()
	local c = RAID_CLASS_COLORS[class]
	if c then
		return string.format("%02x%02x%02x", c.r*255, c.g*255, c.b*255)
	end
end

-- For Player Logins
function CHAT_MSG_SYSTEM(...)
	local login = select(3, find(arg1, "^|Hplayer:(.+)|h%[(.+)%]|h has come online."))
	local classColor = "999999"
	local foundColor = true
			
	if login then
		local found = false
		if GetNumFriends() > 0 then ShowFriends() end
		
		for friendIndex = 1, GetNumFriends() do
			local friendName, _, class = GetFriendInfo(friendIndex)
			if friendName == login then
				classColor = ClassColors(class)
				found = true
				break
			end
		end
		
		if not found then
			if IsInGuild() then GuildRoster() end
			for guildIndex = 1, GetNumGuildMembers(true) do
				local guildMemberName, _, _, _, _, _, _, _, _, _, class = GetGuildRosterInfo(guildIndex)
				if guildMemberName == login then
					classColor = ClassColors(class)
					break
				end
			end
		end
		
	end
	
	if login then
		-- Hook the message function
		local AddMessageOriginal = ChatFrame1.AddMessage
		local function AddMessageHook(frame, text, ...)
			text = replace(text, "^|Hplayer:(.+)|h%[(.+)%]|h", "|Hplayer:%1|h|cff"..classColor.."%2|r|h")
			ChatFrame1.AddMessage = AddMessageOriginal
			return AddMessageOriginal(frame, text, ...)
		end
		ChatFrame1.AddMessage = AddMessageHook
	end
end
AddOn:RegisterEvent("CHAT_MSG_SYSTEM")
AddOn["CHAT_MSG_SYSTEM"] = CHAT_MSG_SYSTEM

-- Hook into the AddMessage function
local AddMessageOriginal = ChatFrame1.AddMessage
local function AddMessageHook(frame, text, ...)
	-- chan text smaller or hidden
	for k,v in pairs(replaceschan) do
		text = text:gsub('|h%['..k..'%]|h', '|h'..v..'|h')
	end
	text = replace(text, "has come online.", "is now |cff298F00online|r !")
	text = replace(text, "|Hplayer:(.+)|h%[(.+)%]|h has earned", "|Hplayer:%1|h%2|h has earned")
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h whispers:", "From [|Hplayer:%1:%2|h%3|h]:")
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h says:", "[|Hplayer:%1:%2|h%3|h]:")	
	text = replace(text, "|Hplayer:(.+):(.+)|h%[(.+)%]|h yells:", "[|Hplayer:%1:%2|h%3|h]:")	
	return AddMessageOriginal(frame, text, ...)
end
ChatFrame1.AddMessage = AddMessageHook

local AddMessageOriginal3 = ChatFrame3.AddMessage
local function AddMessageHook3(frame, text, ...)
        -- chan text smaller or hidden
        text = text:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h')

        return AddMessageOriginal3(frame, text, ...)
end
ChatFrame3.AddMessage = AddMessageHook3

local AddMessageOriginal4 = ChatFrame4.AddMessage
local function AddMessageHook4(frame, text, ...)
        -- chan text smaller or hidden
        text = text:gsub('|h%[(%d+)%. .-%]|h', '|h[%1]|h')

        return AddMessageOriginal4(frame, text, ...)
end
ChatFrame4.AddMessage = AddMessageHook4

ChatFrameEditBox:HookScript("OnTextChanged", function(self)
   local text = self:GetText()
   if text:len() < 5 then
      if text:sub(1, 4) == "/tt " then
         local unitname, realm
         unitname, realm = UnitName("target")
         if unitname then unitname = gsub(unitname, " ", "") end
         if unitname and not UnitIsSameServer("player", "target") then
            unitname = unitname .. "-" .. gsub(realm, " ", "")
         end
         ChatFrame_SendTell((unitname or tukuilocal.chat_invalidtarget), ChatFrame1)
      end
   end
end)

local function AddTime(frame, msg, ...)
	if msg and msg ~= '' then
		msg = format("[%02d:%02d] %s", date('%H'), date('%M'), msg)
	end
	
	frame:tChat_Original_AddMessage(msg, ...)
end

if TukuiDB["chat"].chattime == true then
	for i = 1, 7 do
		local frame = _G['ChatFrame'..i]
		frame.tChat_Original_AddMessage = frame.AddMessage
		frame.AddMessage = AddTime
	end
end

-----------------------------------------------------------------------------
-- copy url
-----------------------------------------------------------------------------

local color = "BD0101"
local pattern = "[wWhH][wWtT][wWtT][\46pP]%S+[^%p%s]"

function string.color(text, color)
	return "|cff"..color..text.."|r"
end

function string.link(text, type, value, color)
	return "|H"..type..":"..tostring(value).."|h"..tostring(text):color(color or "ffffff").."|h"
end

StaticPopupDialogs["LINKME"] = {
	text = "URL COPY",
	button2 = CANCEL,
	hasEditBox = true,
    hasWideEditBox = true,
	timeout = 0,
	exclusive = 1,
	hideOnEscape = 1,
	EditBoxOnEscapePressed = function(self) self:GetParent():Hide() end,
	whileDead = 1,
	maxLetters = 255,
}

local function f(url)
	return string.link("["..url.."]", "url", url, color)
end

local function hook(self, text, ...)
	self:f(text:gsub(pattern, f), ...)
end

for i = 1, NUM_CHAT_WINDOWS do
	if ( i ~= 2 ) then
		local frame = _G["ChatFrame"..i]
		frame.f = frame.AddMessage
		frame.AddMessage = hook
	end
end

local f = ChatFrame_OnHyperlinkShow
function ChatFrame_OnHyperlinkShow(self, link, text, button)
	local type, value = link:match("(%a+):(.+)")
	if ( type == "url" ) then
		local dialog = StaticPopup_Show("LINKME")
		local editbox = _G[dialog:GetName().."WideEditBox"]  
		editbox:SetText(value)
		editbox:SetFocus()
		editbox:HighlightText()
		local button = _G[dialog:GetName().."Button2"]
            
		button:ClearAllPoints()
           
		button:SetPoint("CENTER", editbox, "CENTER", 0, TukuiDB:Scale(-30))
	else
		f(self, link, text, button)
	end
end

------------------------------------------------------------------------
--	No more click on item chat link
------------------------------------------------------------------------

local orig1, orig2 = {}, {}
local GameTooltip = GameTooltip

local linktypes = {item = true, enchant = true, spell = true, quest = true, unit = true, talent = true, achievement = true, glyph = true}


local function OnHyperlinkEnter(frame, link, ...)
	local linktype = link:match("^([^:]+)")
	if linktype and linktypes[linktype] then
		GameTooltip:SetOwner(frame, "ANCHOR_TOPLEFT")
		GameTooltip:SetHyperlink(link)
		GameTooltip:Show()
	end

	if orig1[frame] then return orig1[frame](frame, link, ...) end
end

local function OnHyperlinkLeave(frame, ...)
	GameTooltip:Hide()
	if orig2[frame] then return orig2[frame](frame, ...) end
end


local _G = getfenv(0)
for i=1, NUM_CHAT_WINDOWS do
	local frame = _G["ChatFrame"..i]
	orig1[frame] = frame:GetScript("OnHyperlinkEnter")
	frame:SetScript("OnHyperlinkEnter", OnHyperlinkEnter)

	orig2[frame] = frame:GetScript("OnHyperlinkLeave")
	frame:SetScript("OnHyperlinkLeave", OnHyperlinkLeave)
end

-----------------------------------------------------------------------------
-- Copy Chat (credit: shestak for this version)
-----------------------------------------------------------------------------

local lines = {}
local frame = nil
local editBox = nil
local isf = nil

local function CreatCopyFrame()
	frame = CreateFrame("Frame", "CopyFrame", UIParent)
	frame:SetBackdrop({
			bgFile = TukuiDB["media"].blank, 
			edgeFile = TukuiDB["media"].blank, 
			tile = 0, tileSize = 0, edgeSize = TukuiDB.mult, 
			insets = { left = -TukuiDB.mult, right = -TukuiDB.mult, top = -TukuiDB.mult, bottom = -TukuiDB.mult }
	})
	frame:SetBackdropColor(unpack(TukuiDB["media"].backdropcolor))
	frame:SetBackdropBorderColor(unpack(TukuiDB["media"].bordercolor))
	if TukuiDB.lowversion == true then
		frame:SetWidth(TukuiDB:Scale(410))
	else
		frame:SetWidth(TukuiDB:Scale(710))
	end
	frame:SetHeight(TukuiDB:Scale(200))
	frame:SetScale(1)
	frame:SetPoint("BOTTOM", UIParent, "BOTTOM", 0, TukuiDB:Scale(10))
	frame:Hide()
	frame:SetFrameStrata("DIALOG")

	local scrollArea = CreateFrame("ScrollFrame", "CopyScroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", TukuiDB:Scale(8), TukuiDB:Scale(-30))
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", TukuiDB:Scale(-30), TukuiDB:Scale(8))

	editBox = CreateFrame("EditBox", "CopyBox", frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontNormal)
	if TukuiDB.lowversion == true then
		editBox:SetWidth(TukuiDB:Scale(410))
	else
		editBox:SetWidth(TukuiDB:Scale(710))
	end
	editBox:SetHeight(TukuiDB:Scale(200))
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)

	scrollArea:SetScrollChild(editBox)

	local close = CreateFrame("Button", "CopyCloseButton", frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

	isf = true
end

local function GetLines(...)
	--[[		Grab all those lines		]]--
	local ct = 1
	for i = select("#", ...), 1, -1 do
		local region = select(i, ...)
		if region:GetObjectType() == "FontString" then
			lines[ct] = tostring(region:GetText())
			ct = ct + 1
		end
	end
	return ct - 1
end

local function Copy(cf)
	local _, size = cf:GetFont()
	FCF_SetChatWindowFontSize(cf, cf, 0.01)
	local lineCt = GetLines(cf:GetRegions())
	local text = table.concat(lines, "\n", 1, lineCt)
	FCF_SetChatWindowFontSize(cf, cf, size)
	if not isf then CreatCopyFrame() end
	frame:Show()
	editBox:SetText(text)
	editBox:HighlightText(0)
end

for i = 1, NUM_CHAT_WINDOWS do
	local cf = _G[format("ChatFrame%d",  i)]
	local button = CreateFrame("Button", format("ButtonCF%d", i), cf)
	button:SetPoint("BOTTOMRIGHT", 0, 0)
	button:SetHeight(TukuiDB:Scale(20))
	button:SetWidth(TukuiDB:Scale(20))
	button:SetAlpha(0)
	TukuiDB:SetTemplate(button)
	button:SetScript("OnClick", function() Copy(cf) end)
	button:SetScript("OnEnter", function() 
		button:SetAlpha(1) 
	end)
	button:SetScript("OnLeave", function() button:SetAlpha(0) end)
	button:Hide()
	---------------------------------------------------------------------------------------------------------TABS!!!
	local tab = _G[format("ChatFrame%dTab", i)]
	tab:SetScript("OnShow", function() button:Show() end)
	tab:SetScript("OnHide", function() button:Hide() end)
end
-----------//CHAT FRAME BG's//----------------------
--LEFT CHAT
local leftchat = CreateFrame("Frame", "LeftChat", UIParent)
TukuiDB:CreatePanel(leftchat, 1, 1, "BOTTOMLEFT", ChatFrame1, "BOTTOMLEFT", 0, 0, 1)
leftchat:ClearAllPoints()
leftchat:SetPoint("BOTTOMLEFT", ChatFrame1, "BOTTOMLEFT", -6, -6)
leftchat:SetPoint("TOPRIGHT", ChatFrame1, "TOPRIGHT", 6, 4)
leftchat:SetBackdropColor(0.05,0.05,0.05,0.5)
leftchat:SetBackdropBorderColor(0, 0, 0, 0.8)
leftchat:SetFrameStrata("BACKGROUND")

local lootchat = CreateFrame("Frame", "LootChat", UIParent)
TukuiDB:CreatePanel(lootchat, 1, 1, "BOTTOMLEFT", ChatFrame5, "BOTTOMLEFT", 0, 0, 1)
lootchat:ClearAllPoints()
lootchat:SetPoint("BOTTOMLEFT", ChatFrame5, "BOTTOMLEFT", -6, -6)
lootchat:SetPoint("TOPRIGHT", ChatFrame5, "TOPRIGHT", 6, 4)
lootchat:SetBackdropColor(0.05,0.05,0.05,0.5)
lootchat:SetBackdropBorderColor(0, 0, 0, 0.7)
lootchat:SetFrameStrata("BACKGROUND")

local alertchat = CreateFrame("Frame", "AlertChat", UIParent)
TukuiDB:CreatePanel(alertchat, 1, 1, "BOTTOMLEFT", ChatFrame6, "BOTTOMLEFT", 0, 0, 1)
alertchat:ClearAllPoints()
alertchat:SetPoint("BOTTOMLEFT", ChatFrame6, "BOTTOMLEFT", -6, -6)
alertchat:SetPoint("TOPRIGHT", ChatFrame6, "TOPRIGHT", 6, 4)
alertchat:SetBackdropColor(0.05,0.05,0.05,0.5)
alertchat:SetBackdropBorderColor(0, 0, 0, 0.7)
alertchat:SetFrameStrata("BACKGROUND")
----------------------------------------------------------------------------------------
------------//CHICCHAI//----------------------------------------------------------------

local function getMinHeight(self)
	local minHeight = 0
	for i=1, minimizedLines do
		local line = select(1+i, self:GetRegions())
		if(line) then
			minHeight = minHeight + line:GetHeight() + 2.5
		end
	end
	if(minHeight == 0) then
		minHeight = select(2, self:GetFont()) + 2.5
	end
	return minHeight
end

local function Update(self, elapsed)
	if(self.WaitTime) then
		self.WaitTime = self.WaitTime - elapsed
		if(self.WaitTime > 0) then return end
		self.WaitTime = nil
	end

	self.State = nil

	self.TimeRunning = self.TimeRunning + elapsed
	local animPercent = min(self.TimeRunning/animTime, 1)

	local heightPercent = self.Animate == DOWN and 1-animPercent or animPercent

	local minHeight = getMinHeight(self.Frame)
	if (self.Frame == ChatFrame5) then
		self.Frame:SetHeight(minHeight + (75-minHeight) * heightPercent)
	else
		self.Frame:SetHeight(minHeight + (maxHeight-minHeight) * heightPercent)
	end

	if(animPercent >= 1) then
		self.State = self.Animate
		self.Animate = nil
		self.TimeRunning = nil
		self:Hide()
		if(self.finishedFunc) then self:finishedFunc() end
	end
end

local function getChicchai(self)
	if(self:GetObjectType() == "Frame") then self = self.Frame  end
	if(self.isDocked) then self = DOCKED_CHAT_FRAMES[1] end
	return self.Chicchai
end

local function SetFrozen(self, isFrozen)
	getChicchai(self).Frozen = isFrozen
end

local function Animate(self, dir, waitTime, finishedFunc)
	local self = getChicchai(self)
	if(self.Frozen) then return end
	if(self.Animate == dir or self.State == dir and not self.Animate) then return end

	if(self.Animate == -dir) then
		self.TimeRunning = animTime - self.TimeRunning
	else
		self.TimeRunning = 0
	end
	self.WaitTime = waitTime
	self.Animate = dir
	self.finishedFunc = finishedFunc
	self:Show()
end

local function Maximize(self) Animate(self, UP) end
local function Minimize(self) Animate(self, DOWN) end

local function MinimizeAfterWait(self)
	Animate(self, DOWN, minimizeTime)
end

local CheckEnterLeave
if(MaximizeOnEnter) then
	CheckEnterLeave = function(self)
		self = getChicchai(self)
		if(MouseIsOver(self.Frame) and not self.wasOver) then
			if(self.Frame ~= ChatFrame1) then
				ChatFrame1.wasOver = nil
				self.wasOver = true
				Animate(ChatFrame1, DOWN, WaitAfterLeave)
				Animate(self, UP, WaitAfterEnter)
			end
		elseif(self.wasOver and not MouseIsOver(self.Frame)) then
			if(self.Frame ~= ChatFrame1) then
				ChatFrame1.wasOver = true
				self.wasOver = nil
				Animate(ChatFrame1, UP, WaitAfterEnter)
				Animate(self, DOWN, WaitAfterLeave)
			end
		end
	end
end

if(MaximizeCombatLog) then
	hooksecurefunc("FCF_Tab_OnClick", function(self)
		local frame = getChicchai(ChatFrame1)
		if(self == ChatFrame2Tab) then
			Animate(frame, UP)
			SetFrozen(frame, true)
		elseif(frame.Frozen) then
			SetFrozen(frame, nil)
			Animate(frame, DOWN)
		end
	end)
end

local function UpdateHeight(self)
	local self = getChicchai(self)
	if(self.State ~= DOWN) then return end
	self.Frame:SetHeight(getMinHeight(self.Frame))
end

local function chatEvent(self)
	if(event == "CHAT_MSG_CHANNEL" and channelNumbers and not channelNumbers[arg8]) then return end

	if(not LockInCombat or not UnitAffectingCombat("player") or not IsMovingOrSizing) then
		Animate(self, UP, nil, MinimizeAfterWait)
		Animate(ChatFrame5, DOWN, nil)
	end
end

for chatname, options in pairs(ChatFrameConfig) do
	local chatframe = _G[chatname]
	local frame = CreateFrame"Frame"
	if(MaximizeOnEnter) then
		local updater = CreateFrame("Frame", nil, chatframe)
		updater:SetScript("OnUpdate", CheckEnterLeave)
		updater.Frame = chatframe
	end
	frame.Frame = chatframe
	chatframe.Chicchai = frame
	for _, event in pairs(options) do
		frame:RegisterEvent(event)
	end
	ChatFrameConfig[chatname] = frame
	
	chatframe.Maximize = Maximize
	chatframe.Minimize = Minimize
	chatframe.UpdateHeight = UpdateHeight
	chatframe.SetFrozen = SetFrozen

	frame:SetScript("OnUpdate", Update)
	frame:SetScript("OnEvent", chatEvent)
	frame:Hide()

	hooksecurefunc(chatframe, "AddMessage", UpdateHeight)
end


---------//CHAT TAB BUTTONS//--------------------------
--GENERAL TAB------------------------------------------
local genTab = CreateFrame("Frame", "GeneralSW", UIParent)
TukuiDB:CreatePanel(genTab, TukuiDB:Scale(72), TukuiDB:Scale(20), "CENTER", OPanel1, "CENTER", 0, 0,4)
genTab:SetBackdropColor(colorz[1] * 0.5, colorz[2] * 0.5, colorz[3] * 0.5)
genTab:SetBackdropBorderColor(0,0,0,1)
genTab:SetFrameStrata("MEDIUM")
local tabOne  = GeneralSW:CreateFontString(nil, "OVERLAY")
tabOne:SetFont(TukuiDB["media"].pixelfont, 8)
tabOne:SetHeight(TukuiDB:Scale(20))
tabOne:SetPoint("CENTER", GeneralSW)
tabOne:SetTextColor(1, 1, 1, 0.5)
tabOne:SetText("General")
genTab:EnableMouse(true)
genTab:SetScript("OnMouseUp", function() ChatFrame1:Show();ChatFrame2:Hide();ChatFrame3:Hide();ChatFrame4:Hide() end)
genTab:HookScript("OnEnter", function(self) genTab:SetBackdropColor(colorz[1], colorz[2], colorz[3], 1);tabOne:SetTextColor(1, 1, 1, 1) end)
genTab:HookScript("OnLeave", function(self) genTab:SetBackdropColor(colorz[1] * 0.5, colorz[2] * 0.5, colorz[3] * 0.5);tabOne:SetTextColor(1, 1, 1, 0.5) end)

--COMBAT TAB------------------------------------------
local combatTab = CreateFrame("Frame", "CombatSW", UIParent)
TukuiDB:CreatePanel(combatTab, TukuiDB:Scale(72), TukuiDB:Scale(20), "CENTER", OPanel2, "CENTER", 0, 0,4)
combatTab:SetBackdropColor(colorz[1] * 0.5, colorz[2] * 0.5, colorz[3] * 0.5)
combatTab:SetBackdropBorderColor(0,0,0,1)
combatTab:SetFrameStrata("MEDIUM")
local tabTwo  = CombatSW:CreateFontString(nil, "OVERLAY")
tabTwo:SetFont(TukuiDB["media"].pixelfont, 8)
tabTwo:SetHeight(TukuiDB:Scale(20))
tabTwo:SetPoint("CENTER", CombatSW)
tabTwo:SetTextColor(1, 1, 1, 0.5)
tabTwo:SetText("Combat")
combatTab:EnableMouse(true)
combatTab:SetScript("OnMouseUp", function() ChatFrame2:Show();Animate(ChatFrame2, UP);Animate(ChatFrame5, DOWN);ChatFrame1:Hide();ChatFrame3:Hide();ChatFrame4:Hide() end)
combatTab:HookScript("OnEnter", function(self) combatTab:SetBackdropColor(colorz[1], colorz[2], colorz[3], 1);tabTwo:SetTextColor(1, 1, 1, 1) end)
combatTab:HookScript("OnLeave", function(self) combatTab:SetBackdropColor(colorz[1] * 0.5, colorz[2] * 0.5, colorz[3] * 0.5);tabTwo:SetTextColor(1, 1, 1, 0.5) end)

--SPAM TAB------------------------------------------
local spamTab = CreateFrame("Frame", "SpamSW", UIParent)
TukuiDB:CreatePanel(spamTab, TukuiDB:Scale(72), TukuiDB:Scale(20), "CENTER", OPanel3, "CENTER", 0, 0,4)
spamTab:SetBackdropColor(colorz[1] * 0.5, colorz[2] * 0.5, colorz[3] * 0.5)
spamTab:SetBackdropBorderColor(0,0,0,1)
spamTab:SetFrameStrata("MEDIUM")
local tabThree  = SpamSW:CreateFontString(nil, "OVERLAY")
tabThree:SetFont(TukuiDB["media"].pixelfont, 8)
tabThree:SetHeight(TukuiDB:Scale(20))
tabThree:SetPoint("CENTER", SpamSW)
tabThree:SetTextColor(1, 1, 1, 0.5)
tabThree:SetText("Spam")
spamTab:EnableMouse(true)
spamTab:SetScript("OnMouseUp", function() ChatFrame3:Show();ChatFrame1:Hide();ChatFrame2:Hide();ChatFrame4:Hide() end)
spamTab:HookScript("OnEnter", function(self) spamTab:SetBackdropColor(colorz[1], colorz[2], colorz[3], 1);tabThree:SetTextColor(1, 1, 1, 1) end)
spamTab:HookScript("OnLeave", function(self) spamTab:SetBackdropColor(colorz[1] * 0.5, colorz[2] * 0.5, colorz[3] * 0.5);tabThree:SetTextColor(1, 1, 1, 0.5) end)

--WHISPER TAB------------------------------------------
local whTab = CreateFrame("Frame", "WhisperSW", UIParent)
TukuiDB:CreatePanel(whTab, TukuiDB:Scale(72), TukuiDB:Scale(20), "CENTER", OPanel4, "CENTER", 0, 0,4)
whTab:SetBackdropColor(colorz[1] * 0.5, colorz[2] * 0.5, colorz[3] * 0.5)
whTab:SetBackdropBorderColor(0,0,0,1)
whTab:SetFrameStrata("MEDIUM")
local tabFour  = WhisperSW:CreateFontString(nil, "OVERLAY")
tabFour:SetFont(TukuiDB["media"].pixelfont, 8)
tabFour:SetHeight(TukuiDB:Scale(20))
tabFour:SetPoint("CENTER", WhisperSW)
tabFour:SetTextColor(1, 1, 1, 0.5)
tabFour:SetText("Whispers")
whTab:EnableMouse(true)

----//PULSE ANIMATION//-------------------------------------------------------------------------------------
TukuiDB:SetPulse(whTab, 1, 0.2)
------//END ANIMATION//----------------------------------------------------------------------------------------
whTab:RegisterEvent("CHAT_MSG_WHISPER_INFORM")
whTab:SetScript("OnEvent", function(self) if not whTab.pulse:IsPlaying() then whTab:SetBackdropColor(1, 0, 1, 1);tabFour:SetTextColor(1, 1, 1, 1);whTab.pulse:Play() end end)
whTab:SetScript("OnMouseUp", function() ChatFrame4:Show();ChatFrame1:Hide();ChatFrame2:Hide();ChatFrame3:Hide();whTab.pulse:Stop() end)
whTab:HookScript("OnEnter", function(self) if not whTab.pulse:IsPlaying() then whTab:SetBackdropColor(colorz[1], colorz[2], colorz[3], 1);tabFour:SetTextColor(1, 1, 1, 1) end end)
whTab:HookScript("OnLeave", function(self) if not whTab.pulse:IsPlaying() then whTab:SetBackdropColor(colorz[1] * 0.5, colorz[2] * 0.5, colorz[3] * 0.5);tabFour:SetTextColor(1, 1, 1, 0.5) end end)
-------------//-------------------------------------
local cleanChat = CreateFrame("Frame")
local function sHrinK()
    if ChatFrame6:IsShown() then 
		Animate(ChatFrame6, DOWN)
	end
	if ChatFrame5:IsShown() then
		Animate(ChatFrame5, DOWN)
	end
end
cleanChat:RegisterEvent('PLAYER_ENTERING_WORLD')
cleanChat:RegisterEvent('PLAYER_LOGIN')
cleanChat:RegisterEvent('ZONE_CHANGED')
cleanChat:SetScript("OnEvent",sHrinK)

_G.Chicchai = ChatFrameConfig

--------------------------------------------------------------// SPELL ALERT SYSTEM By: NightCracker //---------------------------------------------------
local ncSpellalert = CreateFrame("Frame", "ncSpellalert")	
local band, bor = bit.band, bit.bor
local enemy = bor(COMBATLOG_OBJECT_REACTION_HOSTILE, COMBATLOG_OBJECT_TYPE_PLAYER)
local deathcoil = GetSpellInfo(62904)
local special = {
	[GetSpellInfo(59752)] = 1, -- horde pvp trink
	[GetSpellInfo(42292)] = 1, -- ally
	[GetSpellInfo(7744)] = 2, -- wotf
	[GetSpellInfo(57073)] = 3, -- drink
}
local ssym = {}

local function GetText(string)
   if not string then return end
   local len = string:len()
   local newstring = ""
   local i,k = 1,1
   while i <=len  do
	  local c = string:byte(i)
	  local shift
	  if (c > 0 and c <= 127) then
		 shift = 1
	  elseif (c >= 192 and c <= 223) then
		 shift = 2
	  elseif (c >= 224 and c <= 239) then
		 shift = 3
	  elseif (c >= 240 and c <= 247) then
		 shift = 4
	  end
	  local char = string:sub(i, i+shift-1)
	  if char then ssym[k]=char k=k+1 end
	  i = i+shift
   end
   return (k)
end

local function isenemy(flags) return band(flags, enemy)==enemy end
local function tohex(val) return string.format("%.2x", val) end
local function getclasscolor(class) local color = RAID_CLASS_COLORS[class] if not color then return "ffffff" end return tohex(color.r*255)..tohex(color.g*255)..tohex(color.b*255) end
local function colorize(name) if name then return "|cff"..getclasscolor(select(2,UnitClass(name)))..name.."|r" else return nil end end

function ncSpellalert:PLAYER_LOGIN()
	if ncSpellalertDB.CONFIG.pvponly then
		self:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		self:ZONE_CHANGED_NEW_AREA()
	else
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end
	self:UnregisterEvent("PLAYER_LOGIN")
end

function ncSpellalert:ZONE_CHANGED_NEW_AREA()
	local pvp = GetZonePVPInfo()
	if not pvp or pvp ~= "sanctuary" then
		self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	else
		self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
		self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	end
end

local function isallowedunit(unit)
	for key, val in pairs(ncSpellalertDB.CONFIG.units) do
		if UnitIsUnit(unit, val) then return true end
	end
	return false
end


function ncSpellalert:COMBAT_LOG_EVENT_UNFILTERED(event, timestamp, eventType, sourceGUID, sourcename, sourceFlags, destGUID, destname, destFlags, spellid, spellname)
	if (spellname==deathcoil and select(2, UnitClass(sourceGUID))=="DEATHKNIGHT") or spellid == 59752 or spellid == 42292 or spellid == 7744 then return end -- ignores

	if eventType == "SPELL_AURA_APPLIED" and ncSpellalertDB.BUFF_SPELLS[spellname] and isenemy(destFlags) and (ncSpellalertDB.CONFIG.allunits or isallowedunit(destname)) then
		ChatFrame6:AddMessage(format(ACTION_SPELL_AURA_APPLIED_BUFF_FULL_TEXT_NO_SOURCE, nil, "|cff00ff00"..spellname.."|r", nil, colorize(destname)))
		Animate(ChatFrame6, UP, nil, MinimizeAfterWait)
	elseif eventType == "SPELL_CAST_START" and isenemy(sourceFlags) and (ncSpellalertDB.CONFIG.allunits or isallowedunit(sourcename)) then
		local color		
		
		if ncSpellalertDB.HARMFUL_SPELLS[spellname] then
			color = "ff0000"
		elseif ncSpellalertDB.HEALING_SPELLS[spellname] then
			color = "ffff00"
		end
		
		if color then
			local template
			if sourcename and destname then
				template = ACTION_SPELL_CAST_START_FULL_TEXT_NO_SOURCE
			elseif sourcename then
				template = ACTION_SPELL_CAST_START_FULL_TEXT_NO_DEST
			elseif destname then
				template = ACTION_SPELL_CAST_START_FULL_TEXT
			end
			ChatFrame6:AddMessage(format(template, colorize(sourcename), "|cff"..color..spellname.."|r", nil, colorize(destname)))
			Animate(ChatFrame6, UP, nil, MinimizeAfterWait)
		end
	end
end

function ncSpellalert:UNIT_SPELLCAST_SUCCEEDED(event, unit, spell, rank)
	event = special[spell]
	if event and UnitIsEnemy("player", unit) then
		if event == 1 then
			ChatFrame6:AddMessage(format("%s used a |cff00ff00PvP trinket|r.", colorize(UnitName(unit))))
			Animate(ChatFrame6, UP, nil, MinimizeAfterWait)
		elseif event == 2 then	
			ChatFrame6:AddMessage(format("%s used |cff00ff00Will of the Forsaken|r.", colorize(UnitName(unit))))
			Animate(ChatFrame6, UP, nil, MinimizeAfterWait)
		elseif event == 3 then
			ChatFrame6:AddMessage(format("%s is drinking.", colorize(UnitName(unit))))
			Animate(ChatFrame6, UP, nil, MinimizeAfterWait)
		end
	end
end
SLASH_LOLTEST1 = "/loltest"
SlashCmdList["LOLTEST"] = function() ChatFrame6:AddMessage("TEST");Animate(ChatFrame6, UP, nil, MinimizeAfterWait) end
ncSpellalert:SetScript("OnEvent", function(self, event, ...) self[event](self, event, ...) end)
ncSpellalert:RegisterEvent("PLAYER_LOGIN")