Xeon.library.util = CreateFrame("Frame", nil, UIParent)

Xeon.library.util:SetScript(
    "OnEvent",
    function(...)
        if event == "ADDON_LOADED" then
            this:UnregisterEvent("ADDON_LOADED")
            -- Register Events
            this:RegisterEvent("AUTOFOLLOW_BEGIN")
            this:RegisterEvent("AUTOFOLLOW_END")
            return
        elseif event == "AUTOFOLLOW_BEGIN" then
            this.values.Following = true
            return
        elseif event == "AUTOFOLLOW_END" then
            this.values.Following = false
            return
        end
    end
)

Xeon.library.util:SetScript(
    "OnUpdate",
    function(...)
        if GetTime() - this.values.updateTime >= 0.2 then
            this.values.updateTime = GetTime()
            ---
            this:FollowUpdate()
        end
    end
)

Xeon.library.util.values = {
    updateTime = GetTime(),
    spemFilter_combat = nil,
    spemFilter_heal = nil,
    spemFilter_class = nil,
    followTarget = nil,
    following = false
}

function _print(txt)
    DEFAULT_CHAT_FRAME:AddMessage(txt)
end

function _txt(txt)
    if txt then
        return txt
    else
        return "NIL"
    end
end

function _TableKeyRemover(table, key)
    local ele = table[key]
    table[key] = nil
    return ele
end

function _sFind(txt1, txt2)
    return string.find(strlower(txt1), strlower(txt2))
end

function _query(value)
    if value then
        _print("TRUE")
    else
        _print("FALSE")
    end
end

function Xeon.library.util:ChatCommand(cmd)
    DEFAULT_CHAT_FRAME.editBox:SetText(cmd)
    ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
end

function Xeon.library.util:DebugMsg_combat(txt)
    if Xeon.cfg.common.debug_combat_msg == 1 then
        if txt ~= self.values.spemFilter_combat then
            self.values.spemFilter_combat = txt
            _print("|cff00D8FF" .. _txt(txt))
        end
    end
end

function Xeon.library.util:DebugMsg_heal(txt)
    if Xeon.cfg.common.debug_heal_msg == 1 then
        if txt ~= self.values.spemFilter_heal then
            self.values.spemFilter_heal = txt
            _print(_txt(txt))
        end
    end
end

function Xeon.library.util:DebugMsg_class(txt)
    if Xeon.cfg.common.debug_class_msg == 1 then
        if txt ~= self.values.spemFilter_class then
            self.values.spemFilter_class = txt
            _print(_txt(txt))
        end
    end
end

function Xeon.library.util:DebugMsg_enemy(txt)
    if Xeon.cfg.common.debug_enemy_msg == 1 then
        if txt ~= self.values.spemFilter_class then
            self.values.spemFilter_class = txt
            _print(_txt(txt))
        end
    end
end

function Xeon.library.util:UnitHP(unit)
    return (UnitHealth(unit) / UnitHealthMax(unit)) * 100
end

function Xeon.library.util:UnitMP(unit)
    return (UnitMana(unit) / UnitManaMax(unit)) * 100
end

function Xeon.library.util:UnitLossesHP(unit)
    local value = UnitHealthMax(unit) - UnitHealth(unit)
    if Xeon.library.buff:IsDebuffed("Mortal Strike", unit) then
        value = value * 2
    end
    return value
end

function Xeon.library.util:IsSpellReady(spellName, bookType)
    local spell = self:GetSpellIDByName(spellName)
    if not bookType then
        bookType = BOOKTYPE_SPELL
    end
    local _, duration, _ = GetSpellCooldown(spell, bookType)
    if duration <= 0 then
        return true
    else
        return false
    end
end

function Xeon.library.util:GetSpellIDByName(SpellName, bookType)
    if not bookType then
        bookType = BOOKTYPE_SPELL
    end
    local id = 0
    repeat
        id = id + 1
        spell, _ = GetSpellName(id, bookType)
    until spell == nil or spell == SpellName
    if spell == nil then
        return nil
    else
        return id
    end
end

function Xeon.library.util:IsPet(unit)
    local uType = UnitCreatureType(unit)
    if uType ~= nil then
        if (string.find(uType, "Beast") and UnitClass(unit) ~= "Druid") or string.find(uType, "Demon") or string.find(uType, "Not specified") then
            return true
        end
    end
    return false
end

function Xeon.library.util:IsEnemyPlayer(unit)
    if UnitIsPlayer(unit) and UnitIsEnemy("player", unit) and not UnitIsDead(unit) and not self:IsPet(unit) then
        return true
    else
        return false
    end
end

function Xeon.library.util:IsUnitMyGroup(unit)
    if UnitPlayerOrPetInParty(unit) or UnitPlayerOrPetInRaid(unit) then
        return true
    else
        return false
    end
end

function Xeon.library.util:IsLearned(SkillName)
    local a = 0
    repeat
        a = a + 1
        skill, _ = GetSpellName(a, BOOKTYPE_SPELL)
    until skill == nil or skill == SkillName
    if skill == nil then
        return false
    else
        return true
    end
end

function Xeon.library.util:GetMaxSpellRank(skill)
    local i = 1
    local high = 0
    local isLesser = false
    if string.find(skill, "Lesser") then
        isLesser = true
    end
    name, rank = GetSpellName(i, "spell")
    repeat
        if not isLesser then
            if string.find(name, skill) ~= nil and string.find(name, "Lesser") == nil then
                high = rank
            end
        else
            if string.find(name, skill) ~= nil then
                high = rank
            end
        end
        i = i + 1
        name, rank = GetSpellName(i, "spell")
    until name == nil
    high = string.gsub(high, "Rank ", "")
    high = tonumber(high)
    return high
end

function Xeon.library.util:SerchFreeSlot()
    for i = 1, 72 do
        if not HasAction(i) then
            return i
        end
    end
    return nil
end

function Xeon.library.util:SerchActionSlotByName(name)
    local tooltip = xeon_scan
    local textleft1 = getglobal(tooltip:GetName() .. "TextLeft1")

    for i = 1, 72 do
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:ClearLines()
        tooltip:SetAction(i)
        txt = textleft1:GetText()
        if txt then
            if _sFind(txt, name) then
                return i
            end
        end
    end
    return nil
end

function Xeon.library.util:PickUpSpellByID(id, bookType)
    if not bookType then
        bookType = BOOKTYPE_SPELL
    end
    PickupSpell(id, bookType)
end

function Xeon.library.util:Attack()
    if not attackSlot then
        for i = 1, 72 do
            if IsAttackAction(i) then
                attackSlot = i
            end
        end
    end
    if not attackSlot then
        self:PickUpSpellByID(self:GetSpellIDByName("Attack"))
        PlaceAction(attackSlot)
    elseif (attackSlot) then
        if not IsCurrentAction(attackSlot) then
            UseAction(attackSlot)
        end
    else
        AttackTarget("target")
    end
end

function Xeon.library.util:AttackRangeCheck(range)
    -- range
    -- 10Y , 30Y , 40Y
    local slot = self:SerchActionSlotByName(xeon_attack_range_check_spell_data[Xeon.library.player.values.class][range])

    if slot then
        if IsActionInRange(slot) == 1 then
            return true
        else
            return false
        end
    else
        _print("[Xeon]: Can't find [" .. xeon_range_check_spell_data[Xeon.library.player.values.class][range] .. "] in your action slots !!")
        return false

       --[[  local emptySlot = self:SerchFreeSlot()
        if emptySlot then
            self:PickUpSpellByID(self:GetSpellIDByName(xeon_attack_range_check_spell_data[Xeon.library.player.values.class][range]))
            PlaceAction(emptySlot)
        else
            _print("[Xeon]: Must need empty action slot for put in [" .. xeon_range_check_spell_data[Xeon.library.player.values.class][range] .. "] !!")
        end
        return false ]]

    end
end

function Xeon.library.util:SpellRangeCheck(spell)
    local slot = self:SerchActionSlotByName(spell)

    if slot then
        if IsActionInRange(slot) == 1 then
            return true
        else
            return false
        end
    else
        _print("[Xeon]: Can't find [" .. spell .. "] in your action slots !!")      
        return 

        --[[ local emptySlot = self:SerchFreeSlot()
        if emptySlot then
            self:PickUpSpellByID(self:GetSpellIDByName(spell))
            PlaceAction(emptySlot)
        else
            _print("[Zeon]: Must need empty action slot for put in [" .. spell .. "] !!")
        end
        return false ]]
    end
end

function Xeon.library.util:StartFollow()
    local tName = UnitName("target")
    if tName and self:IsUnitMyGroup("target") then
        if GetNumRaidMembers() ~= 0 then
            for i = 1, GetNumRaidMembers() do
                if UnitName("raid" .. i) == tName then
                    self.values.followTarget = "raid" .. i
                end
            end
        elseif GetNumPartyMembers() ~= 0 then
            for i = 1, GetNumPartyMembers() do
                if UnitName("party" .. i) == tName then
                    self.values.followTarget = "party" .. i
                end
            end
        end

        _print("[Xeon]: Start Following " .. UnitName(self.values.followTarget) .. " !!")
    else
        _print("[Xeon]: Can't follow current target !!")
    end
end

function Xeon.library.util:FollowUpdate()
    if self.values.followTarget then
        if not CheckInteractDistance(self.values.followTarget, 2) then
            if not Xeon.library.player.values.isCasting then
                FollowUnit(self.values.followTarget)
            end
        end
    end
end

function Xeon.library.util:StopFollow()
    self.values.followTarget = nil
    _print("[Xeon]: Stop Following !!")
end


-- easy talent swap
local _TL = {}

function Xeon.library.util:SaveTalent()
    local talentTabs = GetNumTalentTabs()

    for i = 1, GetNumTalents(1) do
        local name, _, _, _, rank = GetTalentInfo(1, i)
        _print("name: " .. name .. " rank: " .. rank)
        _TL[name] = rank
    end
end

function Xeon.library.util:LoadTalent()
    -- need delay for LearnTalent()

    if UnitCharacterPoints("player") ~= 0 then
        for i = 1, GetNumTalents(1) do
            name, _, _, _, rank = GetTalentInfo(1, i)
            if rank < _TL[name] then
                LearnTalent(1, i)
                _, _, _, _, _rank = GetTalentInfo(1, i)
                rank = _rank
                _print("learn " .. name .. " rank : " .. rank)
                return
            end
        end
    end
end
