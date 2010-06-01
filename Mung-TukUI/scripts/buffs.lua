TukuiBuff = CreateFrame("Frame","TukuiBuff")
TukuiBuff:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)
TukuiBuff:RegisterEvent("ADDON_LOADED")

local buffs = {}
local debuffs = {}
local wench = {}
local auras = {wench,buffs,debuffs}
local buffs_anchor, debuffs_anchor, cons_frame

local cons_num, cons_btn
local consolidatedbtn = {}
local consolidated = {}

local arset = {}

local defaults = {
    buffs_point = "TOPRIGHT",
    buffs_x = -124,
    buffs_y = -34,
    debuffs_point = "TOPRIGHT",
    debuffs_x = -124,
    debuffs_y = -134,
    growthy = "BOTTOM",
    growthx = "LEFT",
    orientation = "HORIZONTAL",
    maxlength = 8,
    gap = 5,
    width = 30,
    height = 25,
    hideblizzard = true,
    consolidate = true,
}

local function Flip(p1,x,y)
    local p2 = ""
    local dir
    if p1 == "CENTER" then return "CENTER" end
        if string.find(p1,"TOP") then p2 = p2..(y and "BOTTOM" or "TOP")end
        if string.find(p1,"BOTTOM") then p2 = p2..(y and "TOP" or "BOTTOM") end
        if string.find(p1,"LEFT") then p2 = p2..(x and "RIGHT" or "LEFT") end
        if string.find(p1,"RIGHT") then p2 = p2..(x and "LEFT" or "RIGHT") end
    if p2 == "RIGHT" or p2 == "LEFT" then
        dir = "HORIZONTAL"
    elseif p2 == "TOP" or p2 == "BOTTOM" then
        dir = "VERTICAL"
    end
    return p2, dir
end

function TukuiBuff.ADDON_LOADED(self,event,arg1)
    if arg1 == "Tukui" then
        TukuiBuffDB = TukuiBuffDB or {}
        TukuiBuffDB.cons_ids = TukuiBuffDB.cons_ids or {}
        TukuiBuffDB = setmetatable(TukuiBuffDB,{ __index = function(t,k) return defaults[k] end})
        
        TukuiBuff:UpdateLayoutSettings()
        buffs_anchor = self:CreateAnchor("buffs")
        debuffs_anchor = self:CreateAnchor("debuffs")
        
        TukuiBuff:RegisterEvent("UNIT_AURA")
        if TukuiBuffDB.hideblizzard then
            BuffFrame:UnregisterEvent("UNIT_AURA")
            BuffFrame:Hide()
            ConsolidatedBuffs.Show = ConsolidatedBuffs.Hide
            ConsolidatedBuffs:Hide()
            TemporaryEnchantFrame:Hide()
        end
        
        if TukuiBuffDB.consolidate then
            cons_btn = TukuiBuff:MakeConsButton()
            table.insert(auras, 1, consolidatedbtn)
            table.insert(auras, consolidated)
            consolidatedbtn[1] = cons_btn
            cons_frame = TukuiBuff:MakeConsolidatedFrame(cons_btn)
        end
        TukuiBuff.CheckWeaponEnchants(self)
        TukuiBuff:UNIT_AURA(nil, "player")
        
        SLASH_TukuiBuff1= "/TukuiBuff"
        SLASH_TukuiBuff2= "/TukuiSmallBuff"
        SlashCmdList["TukuiBuff"] = TukuiBuff.SlashCmd
    end
end

function TukuiBuff.UNIT_AURA(self, event, unit)
    if unit ~= "player" then return end
    
    if TukuiBuffDB.consolidate then 
        cons_num = 0
        for i,btn in pairs(consolidated) do
            consolidated[i] = nil
        end
    end
    
    local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID
    for i=1, BUFF_MAX_DISPLAY do
        name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura("player",i,"HELPFUL")
        if not name then
            for j=i,BUFF_MAX_DISPLAY do
                if buffs[j] then buffs[j]:Hide()
                else break end
            end
            break
        end
        
        if not buffs[i] then
            local btn = self:CreateBuffIcon("buff")
            btn.id = i
            buffs[i] = btn
        end
        
        local btn = buffs[i]
        btn.icon:SetTexture(icon)
        btn.bar:SetMinMaxValues(0, duration)
        btn.count:SetText(count)
        if count > 1 then btn.count:Show() else btn.count:Hide() end
        btn.duration = duration
        btn.expires = expires
        btn.OnUpdateCounter = 1
        btn:Show()
        
        if TukuiBuffDB.consolidate then
            if shouldConsolidate then
                consolidated[i] = btn
                btn:SetParent(cons_frame)
                cons_num = cons_num + 1
            else
                btn:SetParent(UIParent)
            end
        end
    end
    for i=1, DEBUFF_MAX_DISPLAY do
        name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID = UnitAura("player",i,"HARMFUL")
        if not name then
            for j=i,DEBUFF_MAX_DISPLAY do
                if debuffs[j] then debuffs[j]:Hide()
                else break end
            end
            break
        end
        
        if not debuffs[i] then
            local btn = self:CreateBuffIcon("debuff")
            btn.id = i
            debuffs[i] = btn
        end
        
        local btn = debuffs[i]
        btn.icon:SetTexture(icon)
            local color
            if ( dispelType ) then
                color = DebuffTypeColor[dispelType];
            else
                color = DebuffTypeColor["none"];
            end
            btn:SetBackdropColor(color.r,color.g,color.b)
        btn.bar:SetMinMaxValues(0, duration)
        btn.duration = duration
        btn.count:SetText(count)
        if count > 1 then btn.count:Show() else btn.count:Hide() end
        btn.expires = expires
        btn.OnUpdateCounter = 1
        btn:Show()
    end
    if TukuiBuffDB.consolidate then
        cons_btn.count:SetText(cons_num)
        if cons_num > 0 then cons_btn:Show() else cons_btn:Hide() end
        if cons_frame:IsShown() then cons_frame:ResizeFrame() end
    end
    TukuiBuff:ArrangeIcons()
end

function TukuiBuff.UpdateLayoutSettings(self)
    arset.gxdir = (TukuiBuffDB.growthx == "LEFT" and -1 or 1)
    arset.gydir = (TukuiBuffDB.growthy == "BOTTOM" and -1 or 1)
    arset.stepx = (TukuiBuffDB.orientation == "HORIZONTAL" and 1 or 0) * arset.gxdir * TukuiBuffDB.gap
    arset.stepy = (TukuiBuffDB.orientation == "VERTICAL" and 1 or 0) * arset.gydir * TukuiBuffDB.gap
    arset.point = Flip(TukuiBuffDB.growthy..TukuiBuffDB.growthx, true, true)
    arset.to = Flip(arset.point,(arset.stepx ~= 0),(arset.stepy ~= 0))
    arset.newrowto = Flip(arset.point,(arset.stepy ~= 0),(arset.stepx ~= 0))
    arset.max = TukuiBuffDB.maxlength

        for _, icons in pairs(auras) do
            for id,btn in pairs(icons) do
                btn:SetWidth(TukuiBuffDB.width)
                btn:SetHeight(TukuiBuffDB.height)
                btn.icon:SetWidth(TukuiBuffDB.height)
                btn.icon:SetHeight(TukuiBuffDB.height)
                btn.bar:SetWidth(TukuiBuffDB.width - TukuiBuffDB.height - 2)
                btn.bar:SetHeight(TukuiBuffDB.height)
                btn:ClearAllPoints()
            end
        end
end

function TukuiBuff.ArrangeIcons(self)
    local prev, prevcol
    local placed = 1
    local gxdir = arset.gxdir
    local gydir = arset.gydir
    local stepx = arset.stepx
    local stepy = arset.stepy
    local point = arset.point
    local to = arset.to
    local newrowto = arset.newrowto
    local max = arset.max
    for _, icons in ipairs(auras) do
        if icons == debuffs then
            prev = debuffs_anchor
            placed = 1
        elseif icons == consolidated then
            prev = cons_frame
            max = 3
            placed = 1
        elseif not prev then
            prev = buffs_anchor
        end
        for id,btn in pairs(icons) do

            local btn = icons[id]
            if not btn:IsShown() then break end
            if icons ~= buffs or not consolidated[id] then
            if placed > 1 and select(2,math.modf((placed-1)/max)) == 0 then
                btn:SetPoint(point,prevcol,newrowto, math.abs(stepy)*gxdir, math.abs(stepx)*gydir )
                prevcol = btn
            else
                if placed == 1 then prevcol = btn end
                btn:SetPoint(point,prev,to, stepx, stepy)
            end
            if placed == 1 and icons == consolidated then   
                btn:SetPoint(arset.point,cons_frame,arset.point,0,0)
            end
            placed = placed + 1
            prev = btn
            end
        end
    end
end

local function AuraOnUpdate(self,time)
        self.OnUpdateCounter = (self.OnUpdateCounter or 0) + time
        if self.OnUpdateCounter < 0.2 then return end
        self.OnUpdateCounter = 0
        local left = self.expires - GetTime()
        self.bar:SetValue(left)
        local r,g,b
        local duration = self.duration

        if duration == 0 and self.expires == 0 then
            r,g,b = 1,0.5,0.9
            self.bar:SetValue(1)
        else
            if left > duration / 2 then
                r,g,b = (duration - left)*2/duration, 1, 0
            else
                r,g,b = 1, left*2/duration, 0
            end
        end
        self.bar:SetStatusBarColor(r,g,b)
        self.bar.bg:SetVertexColor(r/2,g/2,b/2)
end

function TukuiBuff.CreateBuffIcon(self, auratype)
    local backdrop = {
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 0,
        insets = {left = -2, right = -2, top = -2, bottom = -2},
    }
    local f = CreateFrame("Button",nil,UIParent)
    local width = TukuiBuffDB.width
    local height = TukuiBuffDB.height
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetBackdrop(backdrop)
    f:SetBackdropColor(0, 0, 0, 0.7)

    f.icon = f:CreateTexture(nil,"ARTWORK")
    f.icon:SetTexCoord(.07, .93, .07, .93)
    f.icon:SetWidth(height)
    f.icon:SetHeight(height)
    f.icon:SetPoint("TOP", 0, 0)
    f.icon:SetPoint("RIGHT", 0, 0)
    
    f.count  =  f:CreateFontString(nil, "OVERLAY")
    f.count:SetFont("Fonts\\FRIZQT__.TTF",13,"OUTLINE")
    f.count:SetJustifyH("RIGHT")
    f.count:SetVertexColor(1,1,1)
    f.count:SetPoint("BOTTOMRIGHT",f.icon,"BOTTOMRIGHT",0,0)
    f.count:Hide()
    
    local bar = CreateFrame("StatusBar", nil, f)
    bar:SetStatusBarTexture(TukuiDB["media"].blank)
    bar:SetWidth(width - height - 2)
    bar:SetHeight(height)
    bar:SetOrientation("VERTICAL")
    bar:SetMinMaxValues(0,100)
    bar:SetValue(50)
    bar:SetPoint("TOPLEFT",f,"TOPLEFT",0,0)
    bar:SetStatusBarColor(1,0,0)
    f.bar = bar
    
    local bbg =  bar:CreateTexture(nil,"BACKGROUND")
    bbg:SetTexture(TukuiDB["media"].blank)
    bbg:SetAllPoints(bar)  
    bbg:SetVertexColor(0.4,0,0)
    f.bar.bg = bbg
    
    f:EnableMouse(true)
    if auratype ~= "debuff" then
        f:RegisterForClicks("RightButtonUp")
        f:SetScript("OnClick",function(self,button)
            CancelUnitBuff("player", self.id, self.filter)
        end)
    end
    
    f.filter = (auratype == "buff") and "HELPFUL" or "HARMFUL"
    f:SetScript("OnEnter",function(self)
        GameTooltip:SetOwner(self, "ANCHOR_BOTTOMLEFT")
        GameTooltip:SetUnitAura("player", self.id, self.filter)
    end)
    f:SetScript("OnLeave",function(self)
        GameTooltip:Hide()
    end)
    
    f:SetScript("OnUpdate",AuraOnUpdate)
    
    f:Show()
    
    return f
end

function TukuiBuff.CreateAnchor(self,tbl)
    local f = CreateFrame("Button",nil,UIParent)
    local width = TukuiBuffDB.width
    local height = TukuiBuffDB.height
    f:SetWidth(width)
    f:SetHeight(height)
    f:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 0,
        insets = {left = -2, right = -2, top = -2, bottom = -2},
    })
    f:SetBackdropColor(0, 1, 0, 1)
    
    f:RegisterForDrag("LeftButton")
    f:EnableMouse(true)
    f:SetMovable(true)
    f:SetFrameStrata("HIGH")
    f:SetFrameLevel(2)
    f:SetScript("OnDragStart",function(self) self:StartMoving() end)
    f:SetScript("OnDragStop",function(self)
        self:StopMovingOrSizing();
        _,_, TukuiBuffDB[tbl.."_point"], TukuiBuffDB[tbl.."_x"], TukuiBuffDB[tbl.."_y"] = self:GetPoint(1)
    end)

    f.SetPos = function(self,point, x, y )
        TukuiBuffDB[tbl.."_point"] = point
        TukuiBuffDB[tbl.."_x"] = x
        TukuiBuffDB[tbl.."_y"] = y
        self:ClearAllPoints()
        self:SetPoint(point, UIParent, point, x, y) 
    end
    f:SetPos(TukuiBuffDB[tbl.."_point"], TukuiBuffDB[tbl.."_x"], TukuiBuffDB[tbl.."_y"])
    
    f:Hide()
    
    return f
end

function TukuiBuff.MakeConsolidatedFrame(self, cbtn)
    local f = CreateFrame("Frame",nil,UIParent)
    f:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 0,
        insets = {left = -5, right = -5, top = -5, bottom = -5},
    })
    f:SetBackdropColor(0, 0, 0, 0.85)
    f:SetFrameLevel(5)
    f:SetPoint(arset.point,cbtn,Flip(arset.point, (arset.stepx == 0), (arset.stepy == 0)),0,-20)
    f:SetWidth(1)
    f:SetHeight(1)
    f.ResizeFrame = function(self)
        local num = 0
        local button = select(2,next(consolidated))
        if not button then return end
        for id, btn in pairs(consolidated) do
            num = num + 1
        end
        local i,f = math.modf(num/3)
        local hr = i + (f > 0 and 1 or 0)
        local wr = i > 0 and 3 or num
        local hf = (arset.stepx == 0) and "SetWidth" or "SetHeight"
        local wf = (arset.stepx == 0) and "SetHeight" or "SetWidth"
        local ghf = hf == "SetWidth" and "GetWidth" or "GetHeight"
        local gwf = wf == "SetWidth" and "GetWidth" or "GetHeight"
        self[hf](self,hr*button[ghf](button) + (hr-1)*TukuiBuffDB.gap)
        self[wf](self,wr*button[gwf](button) + (wr-1)*TukuiBuffDB.gap)
    end
    f:SetScript("OnShow", f.ResizeFrame)
    f.fadeOnUpdate = function(self,time)
        self.timeElapsed = (self.timeElapsed or 0) + time
        if self.timeElapsed > 3 then
            self:Hide()
            self:SetScript("OnUpdate",nil)
            self.timeElapsed = 0
        end
    end
    f:Hide()
    return f
end
function TukuiBuff.MakeConsButton(self)
    local btn = self:CreateBuffIcon("debuff")
    btn.icon:SetTexture("Interface\\Buttons\\BuffConsolidation")
    btn.icon:SetTexCoord(0.15, 0.35, 0.3, 0.7)
    btn:SetScript("OnUpdate",nil)
    btn:SetScript("OnEnter",function () cons_frame:Show(); end)
    btn:SetScript("OnLeave",function () cons_frame:SetScript("OnUpdate",cons_frame.fadeOnUpdate) end)
    btn.bar:SetStatusBarColor(1,0.5,0.5)
    btn.bar:SetValue(100)
    btn.count:Show()
    btn:Show()
    
    return btn
end

function TukuiBuff.MutateToWeaponEnchant(f, id)
    f.id = id
    f:SetBackdropColor(0.5,0.2,0.85,1)
    f:SetScript("OnEnter",function(self)
            GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
            GameTooltip:SetInventoryItem("player", self.id)
        end)
    f:SetScript("OnClick",function(self)
                CancelItemTempEnchantment(self.id - 15);   -- should be 1 for mh
                TukuiBuff:CheckWeaponEnchants()
        end)
    f.duration = 3600
    f.bar:SetMinMaxValues(0,f.duration)
    f:Hide()
    
    return f
end

function TukuiBuff.CheckWeaponEnchants(self)
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo();
    if ( hasOffHandEnchant ) then
		if not wench[2] then
            local btn = TukuiBuff:CreateBuffIcon("weapon")
            TukuiBuff.MutateToWeaponEnchant(btn, 17)
            wench[2] = btn
        end
        wench[2].icon:SetTexture(GetInventoryItemTexture("player", 17))
        wench[2].expires = offHandExpiration/1000+GetTime()
        if not wench[2]:IsShown()then
            wench[2]:Show()
            TukuiBuff:ArrangeIcons()
        end
    else
        if wench[2] then if wench[2]:IsShown() then wench[2]:Hide() TukuiBuff:ArrangeIcons() end end
	end
    if ( hasMainHandEnchant ) then
		if not wench[1] then
            local btn = TukuiBuff:CreateBuffIcon("weapon")
            TukuiBuff.MutateToWeaponEnchant(btn, 16)
            wench[1] = btn
        end
        wench[1].icon:SetTexture(GetInventoryItemTexture("player", 16))
        wench[1].expires = mainHandExpiration/1000+GetTime()
        if not wench[1]:IsShown()then
            wench[1]:Show()
            TukuiBuff:ArrangeIcons()
        end
    else
        if wench[1] then if wench[1]:IsShown() then wench[1]:Hide() TukuiBuff:ArrangeIcons() end end
	end
end

CreateFrame("Frame",nil):SetScript("OnUpdate",function(self,time)
    self.OnUpdateCounter = (self.OnUpdateCounter or 1) + time
    if self.OnUpdateCounter < 1 then return end
    self.OnUpdateCounter = 0
    
    TukuiBuff:CheckWeaponEnchants()
end)



local ParseOpts = function(str)
    local fields = {}
    for opt,args in string.gmatch(str,"(%w*)%s*=%s*([%w%,%-%_%.%:%\\%']+)") do
        fields[opt:lower()] = tonumber(args) or string.upper(args)
    end
    return fields
end
function TukuiBuff.SlashCmd(msg)
    k,v = string.match(msg, "([%w%+%-%=]+) ?(.*)")
    if not k or k == "help" then print([[Usage:
      |cffff99bb/TukuiBuff set|r width=26 height=20 growthx=left/right growthy=top/bottom maxlength=16 gap=5 orientation=vertical/horizontal
      |cffff99bb/TukuiBuff opts|r : display current settings
      |cffff99bb/TukuiBuff hideblizz|r
      |cffff99bb/TukuiBuff consolidate|r
      |cffff99bb/TukuiBuff lock|r
      |cffff99bb/TukuiBuff unlock|r ]]
    )end
    if k == "opts" then
        print ("Width: "..TukuiBuffDB.width)
        print ("Height: "..TukuiBuffDB.height)
        print ("Growth-X: "..TukuiBuffDB.growthx)
        print ("Growth-Y: "..TukuiBuffDB.growthy)
        print ("Orientation: "..TukuiBuffDB.orientation)
        print ("Max length: "..TukuiBuffDB.maxlength)
        print ("Gap: "..TukuiBuffDB.gap)
        print ("Hide Blizzard frames: "..(TukuiBuffDB.hideblizzard and "true" or "false"))
        print ("Consolidate Buffs: "..(TukuiBuffDB.consolidate and "true" or "false"))
    end
    if k == "set" then
        local p = ParseOpts(v)
        TukuiBuffDB.width = p["width"] or TukuiBuffDB.width
        TukuiBuffDB.height = p["height"] or TukuiBuffDB.height
        TukuiBuffDB.growthx = p["growthx"] or TukuiBuffDB.growthx
        TukuiBuffDB.growthy = p["growthy"] or TukuiBuffDB.growthy
        TukuiBuffDB.orientation = p["orientation"] or TukuiBuffDB.orientation
        TukuiBuffDB.maxlength = p["maxlength"] or TukuiBuffDB.maxlength
        TukuiBuffDB.gap = p["gap"] or TukuiBuffDB.gap
        TukuiBuff:UpdateLayoutSettings()
        TukuiBuff:ArrangeIcons()
    end
    if k == "hideblizz" then
        TukuiBuffDB.hideblizzard = not TukuiBuffDB.hideblizzard
        print('Changes will take effect after reloadui')
    end
    if k == "consolidate" then
        TukuiBuffDB.consolidate = not TukuiBuffDB.consolidate
        print("Consolidated Buffs "..(TukuiBuffDB.consolidate and "enabled" or "disabled"))
        print('Changes will take effect after reloadui')
    end
    if k == "unlock" then
        buffs_anchor:Show()
        debuffs_anchor:Show()
    end
    if k == "lock" then
        buffs_anchor:Hide()
        debuffs_anchor:Hide()
    end
end