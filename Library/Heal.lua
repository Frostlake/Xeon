Xeon.library.heal = CreateFrame("Frame", nil, UIParent)
Xeon.library.heal:RegisterEvent("ADDON_LOADED")

Xeon.library.heal:SetScript(
    "OnEvent",
    function(...)
        if event == "ADDON_LOADED" then
            this:UnregisterEvent("ADDON_LOADED")

            -- Register Events
            this:RegisterEvent("CHAT_MSG_SPELL_FAILED_LOCALPLAYER")
            return
        elseif event == "CHAT_MSG_SPELL_FAILED_LOCALPLAYER" then
            Xeon.library.util:DebugMsg_heal("CHAT_MSG_SPELL_FAILED_LOCALPLAYER : " .. arg1)
            if
                Xeon.library.player.values.isActivity == true and string.find(arg1, "You fail to cast " .. Xeon.library.player.values.activatedSpell) and
                    string.find(arg1, "You fail to cast " .. Xeon.library.player.values.activatedSpell .. ": Out of range")
             then
                this.values.bannedTime = GetTime()
                this.values.bannedList[Xeon.library.player.values.activatedTargetName] = this.values.bannedTime + 5
            elseif
                Xeon.library.player.values.isActivity == true and string.find(arg1, "You fail to cast " .. Xeon.library.player.values.activatedSpell) and
                    string.find(arg1, "You fail to cast " .. Xeon.library.player.values.activatedSpell .. ": Target not in line of sight")
             then
                this.values.blackListTime = GetTime()
                this.values.blackList[Xeon.library.player.values.activatedTargetName] = this.values.blackListTime + 3
            end
            return
        end
    end
)

Xeon.library.heal.values = {
    toDo = nil,
    playerList = {},
    petList = {},
    bannedList = {},
    blackList = {},
    injuredIn11y = 0,
    injuredIn28y = 0,
    numRaidMembers = nil,
    numPartyMembers = nil,
    bannedTime = 0,
    blackListTime = 0,
    dispellInfo = {},
    buffInfo = {},
    healTarget = nil,
    healTargetHP = nil,
    healCurrentAmount = 0
}

function Xeon.library.heal:IsHealable(unit)
    if UnitExists(unit) then
        if not UnitIsPVP(unit) and not UnitPlayerControlled(unit) then
            return false
        end
        if UnitIsEnemy(unit, "player") then
            return false
        end
        if UnitIsDeadOrGhost(unit) then
            return false
        end
        if UnitCanAttack("player", unit) then
            return false
        end
        if not UnitIsConnected(unit) then
            return false
        end
        if not UnitIsVisible(unit) then
            return false
        end
        if not UnitIsFriend(unit, "player") then
            return false
        end
        return true
    else
        return false
    end
end

function Xeon.library.heal:IsBanned(name)
    local cTime = GetTime()
    if cTime < self.values.bannedTime then
        self.values.bannedList = {}
        self.values.bannedTime = 0
    end
    if self.values.bannedList[name] == nil or self.values.bannedList[name] < cTime then
        return false
    else
        return true
    end
end

function Xeon.library.heal:IsBlackList(name)
    local cTime = GetTime()
    if cTime < self.values.blackListTime then
        self.values.blackList = {}
        self.values.blackListTime = 0
    end
    if self.values.blackList[name] == nil or self.values.blackList[name] < cTime then
        return false
    else
        return true
    end
end

function Xeon.library.heal:AddInjuredCount(unit)
    if (CheckInteractDistance(unit, 2)) then
        self.values.injuredIn11y = self.values.injuredIn11y + 1
    end
    if (CheckInteractDistance(unit, 4)) then
        self.values.injuredIn28y = self.values.injuredIn28y + 1
    end
end

function Xeon.library.heal:MakeupList()
    self.values.toDo = nil
    self.values.playerList = {}
    self.values.petList = {}
    self.values.injuredIn11y = 0
    self.values.injuredIn28y = 0
    self.values.numRaidMembers = GetNumRaidMembers()
    self.values.numPartyMembers = GetNumPartyMembers()
    self.values.dispellInfo = {}
    self.values.buffInfo = {}

    if Xeon.library.player.values.class == "Paladin" then
        Xeon.class.paladin.values.secrificeNum = 0
        Xeon.class.paladin.values.secrificeList = {}
        Xeon.class.paladin.values.hammerList = {}
    end

    if self.values.numRaidMembers > 0 then
        for i = 1, self.values.numRaidMembers do
            if self:IsHealable("raid" .. i) then
                self.values.playerList["raid" .. i] = i
            end
            if self:IsHealable("raidpet" .. i) then
                self.values.petList["raidpet" .. i] = i
            end
        end
    elseif self.values.numPartyMembers > 0 then
        if (self:IsHealable("player")) then
            self.values.playerList["player"] = 0
        end
        if (self:IsHealable("pet")) then
            self.values.petList["pet"] = 0
        end
        for i = 1, self.values.numPartyMembers do
            if self:IsHealable("party" .. i) then
                self.values.playerList["party" .. i] = i
            end
            if self:IsHealable("partypet" .. i) then
                self.values.petList["partypet" .. i] = i
            end
        end
    else
        if (self:IsHealable("player")) then
            self.values.playerList["player"] = 0
        end
        if (self:IsHealable("pet")) then
            self.values.petList["pet"] = 0
        end
    end
end

function Xeon.library.heal:SerchValidTarget()
    self.values.healTargetHP = 100
    self.values.healTarget = nil

    for unit, i in self.values.playerList do
        if not self:IsBanned(GetUnitName(unit)) and not self:IsBlackList(GetUnitName(unit)) then
            if not Xeon.library.buff:IsBuffed("Graccu", unit) and not Xeon.library.buff:IsDebuffed("Mind Control", unit) then
                local hp = Xeon.library.util:UnitHP(unit)

                -- check dispell able debuff
                local dispellInfo = Xeon.library.buff:SerchDispellAbleDebuff(unit)
                if dispellInfo and CheckInteractDistance(unit, 4) and (self.values.dispellInfo.priority == nil or self.values.dispellInfo.priority <= dispellInfo.priority) then
                    self.values.dispellInfo = dispellInfo
                end

                -- check for buff
                local buffInfo = Xeon.library.buff:SerchBuffTarget(unit)
                if buffInfo then
                    self.values.buffInfo = buffInfo
                    if Xeon.library.player.values.class == "Paladin" then
                        if Xeon.library.buff:IsBuffed("Blessing of Sacrifice", unit) then
                            Xeon.class.paladin.values.secrificeNum = Xeon.class.paladin.values.secrificeNum + 1
                        end
                    end
                end
                -- check for AOE heal
                if (hp <= 70) then
                    self:AddInjuredCount(unit)
                end
                -- check for heal
                if hp < self.values.healTargetHP then
                    self.values.healTarget = unit
                    self.values.healTargetHP = hp
                end
            end
        end
    end

    -- Pets
    if (GetNumBattlefieldStats() == 0) then
        for unit, i in self.values.petList do
            if not self:IsBanned(GetUnitName(unit)) or CheckInteractDistance(unit, 4) then
                if not self:IsBlackList(GetUnitName(unit)) then
                    local hp = Xeon.library.util:UnitHP(unit)

                    if (hp <= 70) then
                        self:AddInjuredCount(unit)
                    end

                    if hp < self.values.healTargetHP then
                        self.values.healTarget = unit
                        self.values.healTargetHP = hp
                    end
                end
            end
        end
    end

    -- target HP compare
    local currentTargetHP
    if Xeon.library.player.values.target ~= nil and self:IsHealable("target") then
        currentTargetHP = Xeon.library.util:UnitHP("target")
        -- for healing focus on target
        currentTargetHP = currentTargetHP - Xeon.cfg.heal.targetHealWeight
    end

    if self.values.healTarget and currentTargetHP then
        if self.values.healTargetHP >= currentTargetHP then
            self.values.healTarget = "target"
            self.values.healTargetHP = currentTargetHP
        end
    elseif (not self.values.healTarget) and (currentTargetHP) then
        self.values.healTarget = "target"
        self.values.healTargetHP = currentTargetHP
    end

    if self.values.healTarget then
        if self:IsCastAble(self.values.healTarget) then
            self.values.toDo = "HEAL"
        end
    end

    -- group buff
    if Xeon.cfg.buff.groupBuff ~= 0 and ((Xeon.cfg.buff.groupBuff == 1 and GetNumBattlefieldStats() ~= 0) or Xeon.cfg.buff.groupBuff == 3) then
        if not self.values.healTarget or self.values.healTargetHP >= Xeon.cfg.buff.groupBuffHP_rate then
            if self.values.buffInfo.unit then
                self.values.toDo = "BUFF"
            end
            if
                Xeon.library.player.values.class == "Paladin" and Xeon.cfg.paladin.secrificeBuff == 1 and Xeon.cfg.paladin.secrificeNum ~= Xeon.class.paladin.values.secrificeNum and
                    Xeon.class.paladin.values.secrificeList[1]
             then
                self.values.toDo = "BUFF"
                self.values.buffInfo.unit = Xeon.class.paladin.values.secrificeList[1]
                self.values.buffInfo.buff = "Blessing of Sacrifice"
            end
        end
    end

    -- Dispell target compare
    if Xeon.cfg.buff.dispellDebuff ~= 0 and (Xeon.cfg.buff.dispellDebuff == 1 and GetNumBattlefieldStats() ~= 0) or Xeon.cfg.buff.dispellDebuff == 3 then
        -- target dispell 2nd
        if Xeon.library.player.values.target and self:IsHealable("target") then
            local targetDispell = Xeon.library.buff:SerchDispellAbleDebuff("target")
            if targetDispell then
                self.values.dispellInfo = targetDispell
            end
        end
        -- player dispell 1st
        local playerDispell = Xeon.library.buff:SerchDispellAbleDebuff("player")
        if playerDispell then
            self.values.dispellInfo = playerDispell
        end

        if self.values.dispellInfo.unit and (self.values.healTargetHP >= Xeon.cfg.buff.dispellDebuffHP_rate or UnitIsUnit(self.values.dispellInfo.unit, "player")) or not self.values.toDo == "HEAL" then
            self.values.toDo = "DISPELL"
        end
    end
end

function Xeon.library.heal:GetHealAmount(spellName, rank)
    local healPower = Xeon.library.player.values.healingPower + Xeon.library.player.values.spellPower + Xeon.library.player.values.healingBuff
    local basePower = xeon_healing_spell_data[Xeon.library.player.values.class][spellName].spell[rank].basePower
    local basicCoefficient = xeon_healing_spell_data[Xeon.library.player.values.class][spellName].spell[rank].basicCoefficient
    local lvl = 0
    if xeon_healing_spell_data[Xeon.library.player.values.class][spellName].spell[rank].lvl < 20 then
        lvl = xeon_healing_spell_data[Xeon.library.player.values.class][spellName].spell[rank].lvl
    end
    local subLvL20Penalty = 1 - ((lvl) * 0.0375)
    local effectiveCoefficient = basicCoefficient * subLvL20Penalty
    local actualPower = basePower + healPower * effectiveCoefficient
    return actualPower
end

function Xeon.library.heal:StopOverHeal()
    if Xeon.library.player.values.isCasting and self.values.healTarget and self.values.healTarget ~= "target" then
        local lossHp = Xeon.library.util:UnitLossesHP(self.values.healTarget)
        if Xeon.library.util:UnitHP(self.values.healTarget) >= 80 and (self.values.healCurrentAmount / lossHp * 100) >= Xeon.cfg.heal.stopCastingRate then
            _print("Xeon: StopOverHeal - "..UnitName(self.values.healTarget).." / HP : "..Xeon.library.util:UnitLossesHP(self.values.healTarget))
            SpellStopCasting()
        end
    end
end

function Xeon.library.heal:HealRangeCheck(range)
    -- range
    -- 30Y or 40Y
    local slot = Xeon.library.util:SerchActionSlotByName(xeon_range_check_spell_data[Xeon.library.player.values.class][range])

    if slot then
        if IsActionInRange(slot) == 1 then
            return true
        else
            return false
        end
    else
        local emptySlot = Xeon.library.util:SerchFreeSlot()
        if emptySlot then
            Xeon.library.util:PickUpSpellByID(Xeon.library.util:GetSpellIDByName(xeon_range_check_spell_data[Xeon.library.player.values.class][range]))
            PlaceAction(emptySlot)
        else
            _print("[Zeon]: Must need empty action slot for put in [" .. xeon_range_check_spell_data[Xeon.library.player.values.class][range] .. "] !!")
        end
        return false
    end
end

function Xeon.library.heal:IsCastAble(unit)
    if unit == nil then
        unit = "player"
    end
    local unitHP = Xeon.library.util:UnitHP(unit)
    if Xeon.library.player.values.class == "Paladin" then
        if not Xeon.library.player.values.isMoving then
            return true
        elseif (Xeon.library.util:IsSpellReady("Blessing of Protection") and not Xeon.library.buff:IsDebuffed("Forbearance", unit)) and unitHP <= 40 then
            return true
        end
        return false
    elseif Xeon.library.player.values.class == "Shaman" then
        if not Xeon.library.player.values.isMoving then
            return true
        elseif Xeon.library.util:IsSpellReady("Nature's Swiftness") and unitHP <= 40 then
            return true
        end
        return false
    end
end
