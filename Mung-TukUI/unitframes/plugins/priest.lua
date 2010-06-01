-- some shit plugins i need for priest
if TukuiDB["unitframes"].enable ~= true then return end

if select(2, UnitClass("Player")) == "PRIEST" then

	local FONT					= "Fonts\\ARIALN.ttf"

	local function BarPanel(height, width, x, y, anchorPoint, anchorPointRel, anchor, level, parent, strata)
		local Panel = CreateFrame("Frame", _, parent)
		Panel:SetFrameLevel(level)
		Panel:SetFrameStrata(strata)
		Panel:SetHeight(height)
		Panel:SetWidth(width)
		Panel:SetPoint(anchorPoint, anchor, anchorPointRel, x, y)
		Panel:SetBackdrop( { 
		bgFile = TukuiDB["media"].blank, 
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
		})
		Panel:SetBackdropColor(0.1, 0.1, 0.1, 1)
		Panel:Show()
		return Panel
	end 

	-- Function to update each bar
	local function UpdateBar(self)
		local duration = self.Duration
		local timeLeft = self.EndTime-GetTime()
		local roundedt = math.floor(timeLeft*10.5)/10
		self.Bar:SetValue(timeLeft/duration)
		if roundedt % 1 == 0 then 
			self.Time:SetText(roundedt .. ".0")
		else 
			self.Time:SetText(roundedt)
		end

		if timeLeft < 0 then
			self.Panel:Hide()
			self:SetScript("OnUpdate", nil)
		end
	end

	-- Configures the Bar
	local function ConfigureBar(f)
		f.Bar = CreateFrame("StatusBar", _, f.Panel)
		f.Bar:SetStatusBarTexture(TukuiDB["media"].blank)
		f.Bar:SetStatusBarColor(81/255, 13/255, 13/255)
		f.Bar:SetPoint("BOTTOMLEFT", 0, 0)
		f.Bar:SetPoint("TOPRIGHT", 0, 0)
		f.Bar:SetMinMaxValues(0, 1)

		f.Time = f.Bar:CreateFontString(nil, "OVERLAY")
		f.Time:SetPoint("LEFT", 2, 1)
		f.Time:SetShadowOffset(1, -1)
		f.Time:SetShadowColor(0.1, 0.1, 0.1, 1)
		f.Time:SetFont(FONT, 10)
		f.Time:SetJustifyH("LEFT")

		if TukuiDB["unitframes"].ws_show_time == true then
			f.Time:Show()
		else
			f.Time:Hide()
		end

		f.Panel:Hide()
	end

	--------------------------------------------------------
	--  Weakened Soul Bar codes
	--------------------------------------------------------
	if (TukuiDB["unitframes"].ws_show_target) then
		local WeakenedTargetFrame = CreateFrame("Frame", _, oUF_Tukz_target)
		WeakenedTargetFrame.Panel = BarPanel(TukuiDB:Scale(8), TukuiDB:Scale(100), -2, 0, "TOPRIGHT", "BOTTOMRIGHT", oUF_Tukz_target, 1, WeakenedTargetFrame, "HIGH")
		WeakenedTargetFrame.Panel:SetFrameLevel(10)

		ConfigureBar(WeakenedTargetFrame)

		-- On Target Change or Weakened Soul check on the friendly target
		local function WeakenedTargetCheck(self, event, unit, spell)
			if (event == "PLAYER_TARGET_CHANGED") or (unit == "target" and UnitIsFriend("player", "target") and UnitDebuff("target", tukuilocal.priest_wsdebuff)) then      
				local name, _, _, _, _, duration, expirationTime, unitCaster = UnitDebuff("target", tukuilocal.priest_wsdebuff)
				if (event == "PLAYER_TARGET_CHANGED" and (not name)) or not UnitIsFriend("player", "target") then
					self.Panel:Hide()
				elseif name then
					self.EndTime = expirationTime
					self.Duration = duration
					self.Panel:Show()
					self:SetScript("OnUpdate", UpdateBar)
				end
			end
		end


		WeakenedTargetFrame:SetScript("OnEvent", WeakenedTargetCheck)
		WeakenedTargetFrame:RegisterEvent("UNIT_AURA")
		WeakenedTargetFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	end

	-- Weakened Soul bar on player when active.
	if (TukuiDB["unitframes"].ws_show_player) then
		local WeakenedPlayerFrame = CreateFrame("Frame", _, oUF_Tukz_player)
		WeakenedTargetFrame.Panel = BarPanel(TukuiDB:Scale(8), TukuiDB:Scale(174), 0, 0, "TOPLEFT", "BOTTOMLEFT", oUF_Tukz_target, 1, WeakenedTargetFrame, "HIGH")

		ConfigureBar(WeakenedPlayerFrame)
		-- Check for Weakened Soul on me and show bar if it is
		local function WeakenedPlayerCheck(self, event, unit, spell)
			if (unit == "player" and UnitDebuff("player", tukuilocal.priest_wsdebuff)) then
				local name, _, _, _, _, duration, expirationTime, unitCaster = UnitDebuff("player", tukuilocal.priest_wsdebuff)
				if name then
					self.EndTime = expirationTime
					self.Duration = duration
					self.Panel:Show()
					self:SetScript("OnUpdate", UpdateBar)
				end
			end
		end


	WeakenedPlayerFrame:SetScript("OnEvent", WeakenedPlayerCheck)
	WeakenedPlayerFrame:RegisterEvent("UNIT_AURA")
	end

	if TukuiDB["unitframes"].if_ve_warning == true then
		local WarningFrame = CreateFrame("Frame")
		
		local InnerFire = CreateFrame("Frame", "InnerFire", UIParent)
		TukuiDB:CreatePanel(InnerFire, 128, 128, "CENTER", UIParent, "CENTER", 0, 0,5)
		InnerFire.icon = InnerFire:CreateTexture(nil,"LOW")
		InnerFire.icon:SetTexture("Interface\\AddOns\\Tukui\\media\\innerfire")
		InnerFire.icon:SetPoint("center",InnerFire,"center",0,0)
		InnerFire.icon:SetVertexColor(1,0.5,0,0.7)
		InnerFire.icon:SetWidth(TukuiDB:Scale(128));
		InnerFire.icon:SetHeight(TukuiDB:Scale(128));

		local VampEmbrace = CreateFrame("Frame", "VampEmbrace", UIParent)
		TukuiDB:CreatePanel(VampEmbrace, 128, 128, "CENTER", UIParent, "CENTER", 0, 0,5)
		VampEmbrace.icon = VampEmbrace:CreateTexture(nil,"LOW")
		VampEmbrace.icon:SetTexture("Interface\\AddOns\\Tukui\\media\\vembrace")
		VampEmbrace.icon:SetPoint("center",VampEmbrace,"center",0,0)
		VampEmbrace.icon:SetVertexColor(1,0,1,0.7)
		VampEmbrace.icon:SetWidth(TukuiDB:Scale(128));
		VampEmbrace.icon:SetHeight(TukuiDB:Scale(128));
		
		local function PriestBuffCheck(event, unit, spell)
			local inCombat = UnitAffectingCombat("player")
			local hasVehicle = UnitHasVehicleUI("unit")  or UnitHasVehicleUI("name")
			if UnitLevel("player") >= 70 then
				if inCombat and not hasVehicle then
					if not UnitBuff("player", tukuilocal.priest_ifbuff) then
						InnerFire:Show()
					elseif UnitBuff("player", tukuilocal.priest_sfcheck) and not UnitBuff("player", tukuilocal.priest_vebuff) then
						VampEmbrace:Show()
					else
						InnerFire:Hide()
						VampEmbrace:Hide()
					end
				else
					InnerFire:Hide()
					VampEmbrace:Hide()
				end
			else
				InnerFire:Hide()
				VampEmbrace:Hide()
			end
		end
		
		WarningFrame:SetScript("OnEvent", PriestBuffCheck)
		WarningFrame:RegisterEvent("UNIT_AURA")
		WarningFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
		WarningFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
		WarningFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
	end
end