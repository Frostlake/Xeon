Xeon.library.enemy = CreateFrame("Frame", nil, UIParent)
Xeon.library.enemy:RegisterEvent("ADDON_LOADED")

Xeon.library.enemy:SetScript(
    "OnEvent",
    function(...)
        if event == "ADDON_LOADED" then
            this:UnregisterEvent("ADDON_LOADED")
            ShowNameplates()
            -- Register Events
            this:RegisterEvent("MINIMAP_ZONE_CHANGED")
            this:RegisterEvent("UNIT_AURA")
            this:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

            this:RegisterEvent("SPELLCAST_START")
            this:RegisterEvent("SPELLCAST_STOP")

            this:RegisterEvent("CHAT_MSG_SPELL_AURA_GONE_OTHER")
            this:RegisterEvent("CHAT_MSG_SPELL_BREAK_AURA")
            this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILE_DEATH")

            --events for gain/refresh frames
            this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS")
            this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF")
            this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE")
            this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
            this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE")
            this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
            this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE")
            return
        elseif event == "MINIMAP_ZONE_CHANGED" then
            --    this:ResetData()
            return
        elseif event == "UNIT_AURA" then
            Xeon.library.util:DebugMsg_enemy("UNIT_AURA : " .. arg1)
            return
        elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
            Xeon.library.util:DebugMsg_enemy("COMBAT_LOG_EVENT_UNFILTERED : " .. arg1)
            return
        elseif event == "SPELLCAST_START" then
            Xeon.library.util:DebugMsg_enemy("SPELLCAST_START : " .. arg1)
            return
        elseif event == "SPELLCAST_STOP" then
            Xeon.library.util:DebugMsg_enemy("SPELLCAST_STOP : " .. _txt(arg1), _txt(arg2), _txt(arg3))
            return
        elseif event == "CHAT_MSG_SPELL_AURA_GONE_OTHER" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_AURA_GONE_OTHER : " .. arg1)
            for buff, name in string.gfind(arg1, "(.+) fades from (.+).") do
                this:UpdateBuffGone(name, buff)
                this:UpdateCooltime(name, buff)
            end
            return
        elseif event == "CHAT_MSG_SPELL_BREAK_AURA" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_BREAK_AURA : " .. arg1)
            return
        elseif event == "CHAT_MSG_COMBAT_HOSTILE_DEATH" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_COMBAT_HOSTILE_DEATH : " .. arg1)
            return
        elseif event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_BUFFS : " .. arg1)
            for name, buff in string.gfind(arg1, "(.+) gains (.+).") do
                this:UpdateBuffGain(name, buff)
                this:UpdateCastingStart(name, buff)
            end
            return
        elseif event == "CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_HOSTILEPLAYER_BUFF : " .. arg1)
            for name, spell in string.gfind(arg1, "(.+) begins to cast (.+).") do
                this:UpdateCastingStart(name, spell)
            end
            for name, spell in string.gfind(arg1, "(.+) 's (.+) heals ") do
                this:UpdateCooltime(name, spell)
            end
            for name, spell in string.gfind(arg1, "(.+) 's (.+) critically heals ") do
                this:UpdateCooltime(name, spell)
            end
            return
        elseif event == "CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_PERIODIC_HOSTILEPLAYER_DAMAGE : " .. arg1)
            return
        elseif event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE : " .. arg1)
            for name, spell in string.gfind(arg1, "(.+) begins to cast (.+).") do
                this:UpdateCastingStart(name, spell)
            end
            --- spell cast done and channeling update
            for name, spell in string.gfind(arg1, "(.+) 's (.+) hits ") do
                this:UpdateCooltime(name, spell)
                this:UpdateChannelingStart(name, spell)
            end
            for name, spell in string.gfind(arg1, "(.+) 's (.+) was ") do
                this:UpdateCooltime(name, spell)
                this:UpdateChannelingStart(name, spell)
            end
            for name, spell in string.gfind(arg1, "(.+) 's (.+) crits ") do
                this:UpdateCooltime(name, spell)
                this:UpdateChannelingStart(name, spell)
            end
            return
        elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_PERIODIC_CREATURE_DAMAGE : " .. arg1)
            return
        elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS : " .. arg1)
            return
        elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE" then
            Xeon.library.util:DebugMsg_enemy("CHAT_MSG_SPELL_PERIODIC_SELF_DAMAGE : " .. arg1)
            for name, spell in string.gfind(arg1, "from (.+) 's (.+).") do
                this:UpdateChannelingStart(name, spell)
            end
            return
        end
    end
)

Xeon.library.enemy:SetScript(
    "OnUpdate",
    function(...)
        if GetTime() - this.values.updateTime >= 0.2 then
            this.values.updateTime = GetTime()
        -- this:RemoveIdleData()
        -- this:UpdateNearbyEnemy()
        end
    end
)
Xeon.library.enemy.values = {
    updateTime = GetTime(),
    list = {},
    nearbyEnemyCount = 0
}

function Xeon.library.enemy:InitListByName(name)
    self.values.list[name] = {}
    self.values.list[name].buff = {}
    self.values.list[name].cast = {}
    self.values.list[name].update = nil
    self.values.list[name].cooltime = {}
    return
end

function Xeon.library.enemy:UpdateBuffGain(name, buff)
    local _T = GetTime()
    if not self.values.list[name] then
        self:InitListByName(name)
    end
    self.values.list[name].buff[buff] = _T
    self.values.list[name].cooltime[buff] = xeon_buff_data[buff] and _T + xeon_buff_data[buff].cooltime or _T
    self.values.list[name].update = _T
    return
end

function Xeon.library.enemy:UpdateCastingStart(name, spell)
    local _T = GetTime()
    if not self.values.list[name] then
        self:InitListByName(name)
    end
    self.values.list[name].cast[spell] = xeon_spell_data[spell] and _T + xeon_spell_data[spell].castTime or _T
    self.values.list[name].update = _T
    return
end

function Xeon.library.enemy:UpdateChannelingStart(name, spell)
    if xeon_spell_data[spell] and xeon_spell_data[spell].channeled == true then
        local _T = GetTime()
        if not self.values.list[name] then
            self:InitListByName(name)
        end

        if self.values.list[name].cast[spell] then
            if self.values.list[name].cast[spell] - _T < xeon_spell_data[spell].castTime and self.values.list[name].cast[spell] - _T > 0 then
                return
            end
        end
        self.values.list[name].cast[spell] = xeon_spell_data[spell] and _T + xeon_spell_data[spell].castTime or _T
        self.values.list[name].update = _T
    end
    return
end

function Xeon.library.enemy:UpdateCooltime(name, spell)
    local _T = GetTime()
    if not self.values.list[name] then
        self:InitListByName(name)
    end
    -- self.values.list[name].cast = {}
    self.values.list[name].cooltime[spell] = xeon_spell_data[spell] and _T + xeon_spell_data[spell].cooltime or _T
    self.values.list[name].update = _T
    return
end

function Xeon.library.enemy:UpdateBuffGone(name, buff)
    local _T = GetTime()
    if self.values.list[name] then
        self.values.list[name].update = _T
        if self.values.list[name].buff[buff] then
            self.values.list[name].buff[buff] = -999
        -- _TableKeyRemover(self.values.list[name].buff, buff)
        end
    end
    return
end

function Xeon.library.enemy:ResetData()
    _print("[Xeon]: Enermy data is reseted !!")
    self.values.updateTime = GetTime()
    self.values.list = {}
end

function Xeon.library.enemy:RemoveIdleData()
    local _T = GetTime()
    for k1, v1 in pairs(self.values.list) do
        if v1 then -- if k1 then
            for k2, v2 in pairs(self.values.list[k1]) do
                if _T - self.values.list[k1].update > 60 * 5 then
                    _TableKeyRemover(self.values.list, k1)
                end
            end
        end
    end
end

function Xeon.library.enemy:IsEnemyBuffed(buff, name)
    if name == "target" then
        name = UnitName("target")
    end
    local _T = GetTime()
    if self.values.list[name] then
        if self.values.list[name].buff[buff] and xeon_buff_data[buff] then
            local remainingTime = xeon_buff_data[buff].dura - (_T - self.values.list[name].buff[buff])
            if remainingTime > 0 then
                return remainingTime, xeon_buff_data[buff].priority
            end
        end
    end
    return nil, nil
end

function Xeon.library.enemy:IsEnemyCasting(name)
    if string.find(name, "target") or string.find(name, "%d") then
        name = UnitName(name)
    end
    local _T = GetTime()
    if self.values.list[name] then
        for k, v in pairs(self.values.list[name].cast) do
            if self.values.list[name].cast[k] then
                local pastTime = self.values.list[name].cast[k] - _T
                if self.values.list[name].cast[k] > _T then
                    return k, pastTime
                end
            end
        end
    end
    return nil
end

function Xeon.library.enemy:IsEnemyCooldown(buff, name)
    if string.find(name, "target") or string.find(name, "%d") then
        name = UnitName(name)
    end
    local _T = GetTime()
    if self.values.list[name] then
        if self.values.list[name].cooltime[buff] then
            local pastTime = self.values.list[name].cooltime[buff] - _T
            if self.values.list[name].cooltime[buff] > _T then
                return pastTime
            else
                return false
            end
        end
    end
    return nil
end

function Xeon.library.enemy:UpdateNearbyEnemy()
    local function IsNamePlateFrame(frame)
        local overlayRegion = frame:GetRegions()
        if not overlayRegion or overlayRegion:GetObjectType() ~= "Texture" or overlayRegion:GetTexture() ~= "Interface\\Tooltips\\Nameplate-Border" then
            return false
        end
        return true
    end
    local frames = {WorldFrame:GetChildren()}
    local num = 0
    for _, namePlate in ipairs(frames) do
        if IsNamePlateFrame(namePlate) and namePlate:IsVisible() and true then
            num = num + 1
        end
    end
    self.values.nearbyEnemyCount = num
end
