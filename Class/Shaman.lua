Xeon.class.shaman = CreateFrame("Frame", nil, UIParent)
Xeon.class.shaman:RegisterEvent("ADDON_LOADED")

Xeon.class.shaman:SetScript(
    "OnEvent",
    function(...)
        if Xeon.library.player.values.class == "Shaman" then
            if event == "ADDON_LOADED" then
                this:UnregisterEvent("ADDON_LOADED")

                -- Register Events
                this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
                this:RegisterEvent("CHAT_MSG_COMBAT_FRIENDLY_DEATH")
                this:RegisterEvent("UI_ERROR_MESSAGE")
                return
            elseif event == "UI_ERROR_MESSAGE" then
                if _sFind(arg1, "Nothing to dispel") then
                    this.values.noPurgeTime = GetTime()
                    this.values.noPurgeList[Xeon.library.player.values.activatedTargetName] = this.values.noPurgeTime + 10
                end
                return
            elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
                if _sFind(arg1, "You cast Searing Totem") then
                    this.values.searingTotem.active = true
                    this.values.searingTotem.pos_x, this.values.searingTotem.pos_y = GetPlayerMapPosition("player")
                    this.values.searingTotem.castTime = GetTime()
                elseif _sFind(arg1, "You cast Magma Totem") then
                    this.values.magmaTotem.active = true
                    this.values.magmaTotem.pos_x, this.values.magmaTotem.pos_y = GetPlayerMapPosition("player")
                    this.values.magmaTotem.castTime = GetTime()
                elseif _sFind(arg1, "You cast Grounding Totem") then
                    this.values.groundingTotem.active = true
                    this.values.groundingTotem.pos_x, this.values.groundingTotem.pos_y = GetPlayerMapPosition("player")
                    this.values.groundingTotem.castTime = GetTime()
                elseif _sFind(arg1, "You cast Earthbind Totem") then
                    this.values.earthbindTotem.active = true
                    this.values.earthbindTotem.pos_x, this.values.earthbindTotem.pos_y = GetPlayerMapPosition("player")
                    this.values.earthbindTotem.castTime = GetTime()
                elseif _sFind(arg1, "You cast Tremor Totem") then
                    this.values.tremorTotem.active = true
                    this.values.tremorTotem.pos_x, this.values.tremorTotem.pos_y = GetPlayerMapPosition("player")
                    this.values.tremorTotem.castTime = GetTime()
                elseif _sFind(arg1, "You cast Poison Cleansing Totem") then
                    this.values.poisonCleansingTotem.active = true
                    this.values.poisonCleansingTotem.pos_x, this.values.poisonCleansingTotem.pos_y = GetPlayerMapPosition("player")
                    this.values.poisonCleansingTotem.castTime = GetTime()
                end
                return
            elseif event == "CHAT_MSG_COMBAT_FRIENDLY_DEATH" then
                if _sFind(arg1, "Searing Totem is destroyed") then
                    this.values.searingTotem.active = false
                elseif _sFind(arg1, "Magma Totem is destroyed") then
                    this.values.magmaTotem.active = false
                elseif _sFind(arg1, "Grounding Totem is destroyed") then
                    this.values.groundingTotem.active = false
                elseif _sFind(arg1, "Earthbind Totem is destroyed") then
                    this.values.earthbindTotem.active = false
                elseif _sFind(arg1, "Tremor Totem is destroyed") then
                    this.values.tremorTotem.active = false
                elseif _sFind(arg1, "Poison Cleansing Totem is destroyed") then
                    this.values.poisonCleansingTotem.active = false
                end
            end
        end
    end
)

Xeon.class.shaman:SetScript(
    "OnUpdate",
    function(...)
        local y1 = 0.00023697217305499913
        if Xeon.library.player.values.class == "Shaman" then
            if GetTime() - this.values.updateTime >= 0.2 then
                this.values.updateTime = GetTime()
                -- trinket swap
               Xeon.library.item:TrinketSwap(13, "Caster_DPS")
               Xeon.library.item:TrinketSwap(14, "Survive")

                -- totem update
                local _T = GetTime()
                local _X, _Y = GetPlayerMapPosition("player")
                if
                    _T - this.values.searingTotem.castTime >= 30 or
                        (this.values.searingTotem.pos_x - _X > (y1 * 25) or _X - this.values.searingTotem.pos_x > (y1 * 25)) and
                            (this.values.searingTotem.pos_y - _Y > (y1 * 25) or _Y - this.values.searingTotem.pos_y > (y1 * 25))
                 then
                    this.values.searingTotem.active = false
                end
                if
                    _T - this.values.magmaTotem.castTime >= 20 or
                        (this.values.magmaTotem.pos_x - _X > (y1 * 15) or _X - this.values.magmaTotem.pos_x > (y1 * 15)) and
                            (this.values.magmaTotem.pos_y - _Y > (y1 * 15) or _Y - this.values.magmaTotem.pos_y > (y1 * 15))
                 then
                    this.values.magmaTotem.active = false
                end
                if
                    _T - this.values.groundingTotem.castTime >= 45 or
                        (this.values.groundingTotem.pos_x - _X > (y1 * 15) or _X - this.values.groundingTotem.pos_x > (y1 * 15)) and
                            (this.values.groundingTotem.pos_y - _Y > (y1 * 15) or _Y - this.values.groundingTotem.pos_y > (y1 * 15))
                 then
                    this.values.groundingTotem.active = false
                end
                if
                    _T - this.values.earthbindTotem.castTime >= 45 or
                        (this.values.earthbindTotem.pos_x - _X > (y1 * 20) or _X - this.values.earthbindTotem.pos_x > (y1 * 20)) and
                            (this.values.earthbindTotem.pos_y - _Y > (y1 * 20) or _Y - this.values.earthbindTotem.pos_y > (y1 * 20))
                 then
                    this.values.earthbindTotem.active = false
                end
                if
                    _T - this.values.tremorTotem.castTime >= 120 or
                        (this.values.tremorTotem.pos_x - _X > (y1 * 40) or _X - this.values.tremorTotem.pos_x > (y1 * 40)) and
                            (this.values.tremorTotem.pos_y - _Y > (y1 * 40) or _Y - this.values.tremorTotem.pos_y > (y1 * 40))
                 then
                    this.values.tremorTotem.active = false
                end
                if
                    _T - this.values.poisonCleansingTotem.castTime >= 120 or
                        (this.values.poisonCleansingTotem.pos_x - _X > (y1 * 40) or _X - this.values.poisonCleansingTotem.pos_x > (y1 * 40)) and
                            (this.values.poisonCleansingTotem.pos_y - _Y > (y1 * 40) or _Y - this.values.tremorTotem.pos_y > (y1 * 40))
                 then
                    this.values.poisonCleansingTotem.active = false
                end
            end
        end
    end
)

Xeon.class.shaman.values = {
    updateTime = GetTime(),
    noPurgeTime = GetTime(),
    noPurgeList = {},
    searingTotem = {active = false, pos_x = 0, pos_y = 0, castTime = GetTime()},
    magmaTotem = {active = false, pos_x = 0, pos_y = 0, castTime = GetTime()},
    groundingTotem = {active = false, pos_x = 0, pos_y = 0, castTime = GetTime()},
    earthbindTotem = {active = false, pos_x = 0, pos_y = 0, castTime = GetTime()},
    tremorTotem = {active = false, pos_x = 0, pos_y = 0, castTime = GetTime()},
    poisonCleansingTotem = {active = false, pos_x = 0, pos_y = 0, castTime = GetTime()}
}

function Xeon.class.shaman:IsNothingToDispell(name)
    local cTime = GetTime()
    if cTime < self.values.noPurgeTime then
        self.values.noPurgeList = {}
        self.values.noPurgeTime = 0
    end
    if self.values.noPurgeList[name] == nil or self.values.noPurgeList[name] < cTime then
        return false
    else
        return true
    end
end

function Xeon.class.shaman:SwapShield()
    if not UnitIsDeadOrGhost("player") and Xeon.library.item:IsEquiped(16, "Hammer of the Twisting Nether") then
        if Xeon.library.player.values.isMoving and Xeon.library.combat:isUnderAttack("MELEE") then
            Xeon.library.item:Equip(17, "Stygian Buckler")
        elseif Xeon.library.player.values.isCasting then
            Xeon.library.item:Equip(17, "Shield of Condemnation")
        end
    end
end

function Xeon.class.shaman:Heal(dpsMode)
    -- dpsMode : true == dps healing mode
    -- dpsMode : false == full healing mode
    local _T = GetTime()
    local cd_global = _T - Xeon.library.player.values.globalcooldownTime >= 1.5 and true or false
    local cd_item = true
    local cd_noggen = _T > Xeon.library.player.values.noggenTime and true or false
    local notActive = Xeon.library.player.values.isActivity and false or true
    local notHealCasting = (_T - Xeon.library.player.values.healInactiveTime >= 0.1) and true or false
    --_query(Xeon.library.player.values.isActivity)
    -- if Xeon.library.player.values.isActivity == false then
    --_print("Activity : ".._query(Xeon.library.player.values.isActivity))

    if not UnitIsDeadOrGhost("player") then
        -- use Noggen and Rum
        if cd_noggen then
            Xeon.library.item:UseNoggen()
        end

        -- for auto follow
        -- Xeon.library.util:FollowUpdate()

        -- for Petrified scrab buff
        if Xeon.library.item:UseEquippedItem("Petrified Scarab") then
            return
        end
        -----
        Xeon.library.player.values.target = UnitName("target")
        local targetIsEnemy = (Xeon.library.player.values.target and UnitIsEnemy("player", "target")) and true or false

        Xeon.library.heal:MakeupList()
        Xeon.library.heal:SerchValidTarget()

        if Xeon.library.heal.values.toDo == "HEAL" then
            Xeon.library.util:DebugMsg_class("[HEAL] " .. UnitName(Xeon.library.heal.values.healTarget))
        elseif Xeon.library.heal.values.toDo == "DISPELL" then
            Xeon.library.util:DebugMsg_class("[DISPELL] " .. UnitName(Xeon.library.heal.values.dispellInfo.unit) .. " type : " .. Xeon.library.heal.values.dispellInfo.dispellType)
        elseif Xeon.library.heal.values.toDo == "BUFF" then
            Xeon.library.util:DebugMsg_class("[BUFF] " .. UnitName(Xeon.library.heal.values.buffInfo.unit) .. " buff : " .. Xeon.library.heal.values.buffInfo.buff)
        end

        -- Modify  target HP rate for correct value (without Target healing weight value)
        local healTargetPerHP
        if Xeon.library.heal.values.toDo == "HEAL" then
            healTargetPerHP = Xeon.library.util:UnitHP(Xeon.library.heal.values.healTarget)
        end

        if Xeon.library.player.values.isCasting then
        -- Xeon.library.heal:StopOverHeal()
        end

        -- check MP
        if UnitAffectingCombat("player") and healTargetPerHP and healTargetPerHP <= 60 and Xeon.library.util:UnitMP("player") <= 10 then
            if Xeon.library.item:UseBagItem("Mana Potion") or Xeon.library.item:UseBagItem("Mana Draught") then
                return
            end
        end

        -- self dispell

        local isEmergency
        --_print("x : ".._txt(Xeon.library.heal.values.toDo))
        --_print("y : ".._txt(Xeon.library.heal.values.dispellInfo.priority))
        if (healTargetPerHP and healTargetPerHP <= 80) or (Xeon.library.heal.values.toDo == "DISPELL" and Xeon.library.heal.values.dispellInfo.priority == "A") then
            isEmergency = true
        end

        if notActive then
            if Xeon.library.buff.values.playerDebuff["FEAR"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["FLEE"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["CHARM"] then
                if isEmergency then
                    return
                end
            elseif Xeon.library.buff.values.playerDebuff["POLYMORPH"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["SAP"] then
                if isEmergency then
                    return
                end
            elseif Xeon.library.buff.values.playerDebuff["STUN"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["BLIND"] then
                if isEmergency then
                    return
                end
            elseif Xeon.library.buff.values.playerDebuff["HORR"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["FROZEN"] then
                if isEmergency then
                    return
                end
            elseif Xeon.library.buff.values.playerDebuff["SILENCE"] then
                if isEmergency then
                    return
                end
            -- elseif Xeon.library.buff.values.playerDebuff["COT"] then   ?? divine??
            end
        end
        -- survive
        if self:COMMON_SURVIVE() then
            return
        end

        if notActive then
            -- self buff

            -- heal part
            if Xeon.library.heal.values.toDo then
                if Xeon.library.heal.values.toDo == "HEAL" and not dpsMode then
                    if not Xeon.library.player.values.isMoving and notHealCasting then
                        -- use healing power trinkets
                        if ((Xeon.library.heal.values.injuredIn11y >= 2 or Xeon.library.heal.values.injuredIn28y >= 2) and healTargetPerHP < 60) or healTargetPerHP < 40 then
                            if Xeon.library.item:UseEquippedItem("Eye of the Dead") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Scrolls of Blinding Light") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Scarab Brooch") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Zandalarian Hero Charm") then
                                return
                            end
                        end
                        -- normal healing
                        if
                            healTargetPerHP <= 30 and UnitAffectingCombat(Xeon.library.heal.values.healTarget) and Xeon.library.util:IsLearned("Nature's Swiftness") and
                                Xeon.library.util:IsSpellReady("Nature's Swiftness")
                         then
                            Xeon.library.combat:CastSpell("Nature's Swiftness", "player", "NONE_TARGET")
                            return
                        elseif healTargetPerHP <= 40 and Xeon.library.buff:IsBuffed("Nature's Swiftness", "player") and Xeon.library.util:IsSpellReady("Healing Wave") then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif healTargetPerHP <= 40 and Xeon.library.util:IsSpellReady("Lesser Healing Wave") then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Lesser Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif
                            healTargetPerHP <= 50 and Xeon.library.heal.values.injuredIn11y >= 2 and CheckInteractDistance(Xeon.library.heal.values.healTarget, 2) and
                                Xeon.library.util:IsSpellReady("Chain Heal")
                         then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Chain Heal", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif
                            healTargetPerHP <= 85 and (Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget) <= Xeon.cfg.shaman.lossHP_point_lesserHealingWave) and
                                (Xeon.library.util:IsSpellReady("Lesser Healing Wave"))
                         then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Lesser Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif
                            healTargetPerHP <= 85 and (Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget) > Xeon.cfg.shaman.lossHP_point_lesserHealingWave) and
                                (Xeon.library.util:IsSpellReady("Healing Wave"))
                         then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        else
                            -- target healing mode
                            if Xeon.library.heal.values.healTarget and Xeon.library.player.values.target then
                                if UnitIsUnit(Xeon.library.heal.values.healTarget, "target") and UnitAffectingCombat("target") and (Xeon.library.util:IsSpellReady("Lesser Healing Wave")) then
                                    Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Lesser Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget), 1)
                                    return
                                end
                            end
                        end
                    elseif
                        healTargetPerHP <= 40 and UnitAffectingCombat(Xeon.library.heal.values.healTarget) and Xeon.library.util:IsLearned("Nature's Swiftness") and
                            Xeon.library.util:IsSpellReady("Nature's Swiftness")
                     then
                        Xeon.library.combat:CastSpell("Nature's Swiftness", "player", "NONE_TARGET")
                        return
                    elseif healTargetPerHP <= 40 and Xeon.library.buff:IsBuffed("Nature's Swiftness", "player") and Xeon.library.util:IsSpellReady("Healing Wave") then
                        Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                        return
                    end
                elseif Xeon.library.heal.values.toDo == "HEAL" and dpsMode then
                    if not Xeon.library.player.values.isMoving then
                        -- use healing power trinkets
                        if ((Xeon.library.heal.values.injuredIn11y >= 2 or Xeon.library.heal.values.injuredIn28y >= 2) and healTargetPerHP < 60) or healTargetPerHP < 40 then
                            if Xeon.library.item:UseEquippedItem("Eye of the Dead") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Scrolls of Blinding Light") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Scarab Brooch") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Zandalarian Hero Charm") then
                                return
                            end
                        end
                        -- normal healing
                        if
                            healTargetPerHP <= 30 and UnitAffectingCombat(Xeon.library.heal.values.healTarget) and Xeon.library.util:IsLearned("Nature's Swiftness") and
                                Xeon.library.util:IsSpellReady("Nature's Swiftness")
                         then
                            Xeon.library.combat:CastSpell("Nature's Swiftness", "player", "NONE_TARGET")
                            return
                        elseif healTargetPerHP <= 40 and Xeon.library.buff:IsBuffed("Nature's Swiftness", "player") and Xeon.library.util:IsSpellReady("Healing Wave") then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif healTargetPerHP <= 40 and Xeon.library.util:IsSpellReady("Lesser Healing Wave") then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Lesser Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif
                            healTargetPerHP <= 50 and (Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget) <= Xeon.cfg.shaman.lossHP_point_lesserHealingWave) and
                                (Xeon.library.util:IsSpellReady("Lesser Healing Wave"))
                         then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Lesser Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif
                            healTargetPerHP <= 50 and (Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget) > Xeon.cfg.shaman.lossHP_point_lesserHealingWave) and
                                (Xeon.library.util:IsSpellReady("Healing Wave"))
                         then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        end
                    elseif
                        healTargetPerHP <= 40 and UnitAffectingCombat(Xeon.library.heal.values.healTarget) and Xeon.library.util:IsLearned("Nature's Swiftness") and
                            Xeon.library.util:IsSpellReady("Nature's Swiftness")
                     then
                        Xeon.library.combat:CastSpell("Nature's Swiftness", "player", "NONE_TARGET")
                        return
                    elseif healTargetPerHP <= 40 and Xeon.library.buff:IsBuffed("Nature's Swiftness", "player") and Xeon.library.util:IsSpellReady("Healing Wave") then
                        Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Healing Wave", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                        return
                    end
                elseif Xeon.library.heal.values.toDo == "DISPELL" then
                    if Xeon.library.heal.values.dispellInfo.dispellType == "POISON" and Xeon.library.util:IsSpellReady("Cure Poison") then
                        Xeon.library.combat:CastSpell("Cure Poison", Xeon.library.heal.values.dispellInfo.unit)
                        return
                    end
                elseif Xeon.library.heal.values.toDo == "BUFF" then
                    -- use buff totems?
                    return
                end
            end
        end
    end
end

function Xeon.class.shaman:DPS()
    local _T = GetTime()
    local cd_noggen = _T > Xeon.library.player.values.noggenTime and true or false
    local notActive = Xeon.library.player.values.isActivity and false or true
    local uClass = UnitClass("target")

    if not UnitIsDeadOrGhost("player") then
        -- use Noggen and Rum
        if cd_noggen then
            Xeon.library.item:UseNoggen()
        end

        -- servive
        if self:COMMON_SURVIVE() then
            return
        end

        -- lightning distance check
        local distance_ok = Xeon.library.util:SpellRangeCheck("Lightning Bolt")
        local isAttackAble = true
        if Xeon.library.enemy:IsEnemyBuffed("Divine Shield", "target") or Xeon.library.enemy:IsEnemyBuffed("Ice Block", "target") then
            isAttackAble = false
        end

        -- totem
       -- if GetNumBattlefieldStats() ~= 0 then
        if  UnitIsPlayer("target") then
            --      if true then
            if UnitIsUnit("targettarget", "player") and distance_ok then
                if not self.values.groundingTotem.active and Xeon.library.util:IsSpellReady("Grounding Totem") and not (uClass == "Warrior" or uClass == "Rogue") then
                    Xeon.library.combat:CastSpell("Grounding Totem", "player", "NONE_TARGET")
                    return
                end
                if
                    not self.values.tremorTotem.active and Xeon.library.util:IsSpellReady("Tremor Totem") and Xeon.library.util:SpellRangeCheck("Earth Shock") and
                        (uClass == "Warrior" or uClass == "Warlock" or uClass == "Priest")
                 then
                    Xeon.library.combat:CastSpell("Tremor Totem", "player", "NONE_TARGET")
                    return
                end
            end

            if
                UnitIsUnit("targettarget", "player") and ((uClass == "Rogue" and Xeon.library.util:SpellRangeCheck("Earth Shock")) or uClass == "Hunter") and
                    not self.values.poisonCleansingTotem.active and
                    Xeon.library.util:IsSpellReady("Poison Cleansing Totem") and
                    distance_ok
             then
                Xeon.library.combat:CastSpell("Poison Cleansing Totem", "player", "NONE_TARGET")
                return
            end

            if Xeon.library.combat:isUnderAttack("MELEE") then
                if
                    (not self.values.earthbindTotem.active and not self.values.tremorTotem.active) and not (uClass == "Hunter" or uClass == "Warlock") and
                        Xeon.library.util:IsSpellReady("Earthbind Totem")
                 then
                    Xeon.library.combat:CastSpell("Earthbind Totem", "player", "NONE_TARGET")
                    return
                end
            end

            if Xeon.library.combat:isUnderAttack("MELEE") or (UnitIsUnit("targettarget", "player") and Xeon.library.util:SpellRangeCheck("Earth Shock")) then
                if (not self.values.searingTotem.active and not self.values.magmaTotem.active) and Xeon.library.util:IsSpellReady("Searing Totem") then
                    Xeon.library.combat:CastSpell("Searing Totem(Rank 1)", "player", "NONE_TARGET")
                    return
                end
            end
        end

        -- self healing
        local playerHP = Xeon.library.util:UnitHP("player")
        if not Xeon.library.player.values.isMoving then
            if playerHP <= 30 and UnitAffectingCombat("player") and Xeon.library.util:IsLearned("Nature's Swiftness") and Xeon.library.util:IsSpellReady("Nature's Swiftness") then
                Xeon.library.combat:CastSpell("Nature's Swiftness", "player", "NONE_TARGET")
                return
            elseif playerHP <= 40 and Xeon.library.buff:IsBuffed("Nature's Swiftness", "player") and Xeon.library.util:IsSpellReady("Healing Wave") then
                Xeon.library.combat:CastHeal("player", "Healing Wave", Xeon.library.util:UnitLossesHP("player"))
                return
            elseif playerHP <= 40 and Xeon.library.util:IsSpellReady("Lesser Healing Wave") then
                Xeon.library.combat:CastHeal("player", "Lesser Healing Wave", Xeon.library.util:UnitLossesHP("player"))
                return
            end
        elseif playerHP <= 40 and UnitAffectingCombat("player") and Xeon.library.util:IsLearned("Nature's Swiftness") and Xeon.library.util:IsSpellReady("Nature's Swiftness") then
            Xeon.library.combat:CastSpell("Nature's Swiftness", "player", "NONE_TARGET")
            return
        elseif playerHP <= 40 and Xeon.library.buff:IsBuffed("Nature's Swiftness", "player") and Xeon.library.util:IsSpellReady("Healing Wave") then
            Xeon.library.combat:CastHeal("player", "Healing Wave", Xeon.library.util:UnitLossesHP("player"))
            return
        end

        -- self buff
        Xeon.library.player.values.target = UnitName("target")
        if not Xeon.library.player.values.target then
            if not Xeon.library.buff:IsBuffed("Lightning Shield", "player") and Xeon.library.util:IsSpellReady("Lightning Shield") then
                Xeon.library.combat:CastSpell("Lightning Shield", "player", "NONE_TARGET")
            end
            TargetNearestEnemy()
            return
        end

        if not Xeon.library.buff:IsWeaponEnchanted("Flametongue") and Xeon.library.util:IsSpellReady("Flametongue Weapon") then
            Xeon.library.combat:CastSpell("Flametongue Weapon", "player", "NONE_TARGET")
        end

        local targetIsEnemy = (Xeon.library.player.values.target and UnitCanAttack("player", "target")) and true or false

        if not Xeon.library.buff:IsBuffed("Lightning Shield", "player") and Xeon.library.util:IsSpellReady("Lightning Shield") then
            Xeon.library.combat:CastSpell("Lightning Shield", "player", "NONE_TARGET")
            return
        end

        local enemyCastingSpell = Xeon.library.enemy:IsEnemyCasting("target")
        if targetIsEnemy and enemyCastingSpell and Xeon.library.util:IsSpellReady("Earth Shock") and Xeon.library.util:SpellRangeCheck("Earth Shock") and isAttackAble then
            -- if uClass ~= "Mage" or (enemyCastingSpell == "Polymorph" or enemyCastingSpell == "Arcane Missiles") then
            if true then
                if Xeon.library.player.values.isCasting then
                    SpellStopCasting()
                elseif Xeon.library.item:UseEquippedItem("Tidal Charm") then
                    return
                else
                    Xeon.library.combat:CastSpell("Earth Shock", "target")
                    return
                end
            end
        end

        if Xeon.library.buff:SerchDispellAbleDebuff("player") and Xeon.library.util:IsSpellReady("Cure Poison") and not self.values.poisonCleansingTotem.active then
            Xeon.library.combat:CastSpell("Cure Poison", "target")
            return
        end

        -- DPS part
        if targetIsEnemy and distance_ok and isAttackAble then
            if UnitIsPlayer("target") then
                --if true then
                if
                    (Xeon.library.enemy:IsEnemyBuffed("Ice Barrier", "target") or Xeon.library.enemy:IsEnemyBuffed("Power Word: Shield", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Blessing of Protection", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Sacrifice", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Frost Ward", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Fel Domination", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Major Spellstone", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Nature's Swiftness", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Lightning Shield", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Rejuvenation", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Regrowth", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Seal of the Crusader", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Seal of Righteousness", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Seal of Command", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Innervate", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Presence of Mind", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Arcane Power", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Combustion", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Arcane Intellect", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Dampen Magic", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Mage Armor", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Slow Fall", "target") or
                        Xeon.library.enemy:IsEnemyBuffed("Rapid Fire", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or

                        -- trinket buff
                        Xeon.library.enemy:IsEnemyBuffed("Frost Reflector", "target") or
                      --  Xeon.library.enemy:IsEnemyBuffed("Burrower's Shell", "target") or
                        -- Xeon.library.enemy:IsEnemyBuffed("Mercurial Shield", "target") or
                       -- Xeon.library.enemy:IsEnemyBuffed("Unstable Power", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or
                        --Xeon.library.enemy:IsEnemyBuffed("Cold Blood", "target") or

                        Xeon.library.enemy:IsEnemyBuffed("Blessing of Freedom", "target")) and
                        Xeon.library.util:IsSpellReady("Purge") and
                        Xeon.library.util:SpellRangeCheck("Purge")
                 then
                    if
                        Xeon.library.player.values.isCasting and
                            (Xeon.library.enemy:IsEnemyBuffed("Fel Domination", "target") or Xeon.library.enemy:IsEnemyBuffed("Power Word: Shield", "target") or
                                Xeon.library.enemy:IsEnemyBuffed("Major Spellstone", "target") or
                                Xeon.library.enemy:IsEnemyBuffed("Nature's Swiftness", "target") or
                                Xeon.library.enemy:IsEnemyBuffed("Presence of Mind", "target") or
                                Xeon.library.enemy:IsEnemyBuffed("Burrower's Shell", "target"))
                     then
                        SpellStopCasting()
                        return
                    elseif not Xeon.library.player.values.isCasting then
                        Xeon.library.combat:CastSpell("Purge", "target")
                        return
                    end
                end

                if not Xeon.library.player.values.isCasting then
                    if Xeon.library.item:UseEquippedItem("The Restrained Essence of Sapphiron") then
                        return
                    elseif Xeon.library.item:UseEquippedItem("Natural Alignment Crystal") then
                        return
                    elseif Xeon.library.item:UseEquippedItem("Zandalarian Hero Charm") then
                        return
                    elseif Xeon.library.item:UseEquippedItem("Talisman of Ephemeral Power") then
                        return
                    elseif Xeon.library.item:UseEquippedItem("Barov Peasant Caller") then
                        return
                    elseif Xeon.library.item:UseEquippedItem("Defender of the Timbermaw") then
                        return
                    end
                    local unitType = UnitCreatureType("Target")
                    if
                        Xeon.library.util:IsSpellReady("Frost Shock") and Xeon.library.util:SpellRangeCheck("Frost Shock") and
                            (uClass == "Warrior" or uClass == "Rogue" or uClass == "Hunter" or (uClass == "Druid" and unitType == "Beast"))
                     then
                        Xeon.library.combat:CastSpell("Frost Shock", "target")
                        return
                    end

                    if
                        not Xeon.library.buff:IsBuffed("Nature's Swiftness", "player") and Xeon.library.util:IsSpellReady("Nature's Swiftness") and
                            (Xeon.library.util:UnitHP("target") <= 40 or UnitIsUnit("targettarget", "player"))
                     then
                        Xeon.library.combat:CastSpell("Nature's Swiftness", "player", "NONE_TARGET")
                        return
                    end
                    if not Xeon.library.player.values.isMoving or Xeon.library.buff:IsBuffed("Nature's Swiftness", "player") then
                        if Xeon.library.util:IsSpellReady("Chain Lightning") then
                            Xeon.library.combat:CastSpell("Chain Lightning", "target")
                            return
                        end
                        if Xeon.library.util:IsSpellReady("Lightning Bolt") then
                            Xeon.library.combat:CastSpell("Lightning Bolt", "target")
                            return
                        end
                    end
                    if
                        Xeon.library.player.values.isMoving and Xeon.library.util:IsSpellReady("Purge") and Xeon.library.util:SpellRangeCheck("Purge") and
                            not self:IsNothingToDispell(UnitName("target"))
                     then
                        Xeon.library.combat:CastSpell("Purge", "target")
                        return
                    end

                    if CheckInteractDistance("target", 3) and Xeon.library.combat:isUnderAttack("MELEE") and Xeon.library.player.values.isMoving then
                        if Xeon.library.item:UseEquippedItem("Tidal Charm") then
                            return
                        else
                            Xeon.library.util:Attack()
                        end
                    end
                end
            else
                if not Xeon.library.player.values.isCasting then
                    if not Xeon.library.player.values.isMoving then
                        if _sFind(UnitName("target"), "totem") then
                            if Xeon.library.util:IsSpellReady("Lightning Bolt") then
                                Xeon.library.combat:CastSpell("Lightning Bolt(Rank 1)", "target")
                                return
                            end
                        else
                            if Xeon.library.util:IsSpellReady("Lightning Bolt") then
                                Xeon.library.combat:CastSpell("Lightning Bolt", "target")
                                return
                            end
                        end
                    else
                        if CheckInteractDistance("target", 3) then
                            Xeon.library.util:Attack()
                        end
                    end
                end
            end
        end
    end
end

function Xeon.class.shaman:COMMON_SURVIVE()
    if Xeon.library.item:UseEquippedItem("Petrified Scarab") then
        return
    end

    if Xeon.library.buff.values.playerDebuff["STUN"] then
        if Xeon.library.item:UseEquippedItem("Insignia") then
            return
        end
    end

    if UnitAffectingCombat("player") and not Xeon.library.player.values.isActivity then
        if not Xeon.library.player.values.isMoving then
            if Xeon.library.util:UnitHP("player") <= 40 then
                if Xeon.library.combat:isUnderAttack("CASTER") then
                    if Xeon.library.item:UseEquippedItem("Loatheb's Reflection") then
                        return
                    end
                end
                if Xeon.library.item:UseBagItem("Healing Potion") or Xeon.library.item:UseBagItem("Healing Draught") or Xeon.library.item:UseBagItem("Healthstone") then
                    return true
                end
                if Xeon.library.item:UseEquippedItem("The Burrower's Shell") then
                    return
                end
            end
        else
            if Xeon.library.util:UnitHP("player") <= 50 then
                if Xeon.library.combat:isUnderAttack("CASTER") then
                    if Xeon.library.item:UseEquippedItem("Loatheb's Reflection") then
                        return
                    end
                end
                if Xeon.library.item:UseBagItem("Healing Potion") or Xeon.library.item:UseBagItem("Healing Draught") or Xeon.library.item:UseBagItem("Healthstone") then
                    return true
                end
                if Xeon.library.item:UseEquippedItem("The Burrower's Shell") then
                    return
                end
            end
        end
        return false
    end
    return false
end

function Xeon.class.shaman:EQ_DPS()
    if not UnitAffectingCombat("player") then
        -- head
        Xeon.library.item:Equip(GetInventorySlotInfo("HeadSlot"), "Avenger's Crown")
        -- Nack
        Xeon.library.item:Equip(GetInventorySlotInfo("NeckSlot"), "Onyxia Tooth Pendant")
        -- Shoulder
        Xeon.library.item:Equip(GetInventorySlotInfo("ShoulderSlot"), "Avenger's Pauldrons")
        -- Back
        Xeon.library.item:Equip(GetInventorySlotInfo("BackSlot"), "Shroud of Dominion")
        -- Chest
        Xeon.library.item:Equip(GetInventorySlotInfo("ChestSlot"), "Avenger's Breastplate")
        -- Tabard
        Xeon.library.item:Equip(GetInventorySlotInfo("TabardSlot"), "Stone Guard's Herald")
        -- Wrist
        Xeon.library.item:Equip(GetInventorySlotInfo("WristSlot"), "Wristguards of Vengeance")
        -- Hand
        Xeon.library.item:Equip(GetInventorySlotInfo("HandsSlot"), "Gauntlets of the Righteous Champion")
        -- Waist
        Xeon.library.item:Equip(GetInventorySlotInfo("WaistSlot"), "Girdle of the Mentor")
        -- legs
        Xeon.library.item:Equip(GetInventorySlotInfo("LegsSlot"), "Avenger's Legguards")
        -- Feet
        Xeon.library.item:Equip(GetInventorySlotInfo("FeetSlot"), "Avenger's Greaves")
        -- ring1
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger0Slot"), "Band of Unnatural Forces")
        -- ring2
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger1Slot"), "Master Dragonslayer's Ring")
        -- Trinket1
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket0Slot"), "Drake Fang Talisman")
        -- Trinket2
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket1Slot"), "Blackhand's Breadth")
        -- Range
        Xeon.library.item:Equip(GetInventorySlotInfo("RangedSlot"), "Libram of Fervor")
    end
end

function Xeon.class.shaman:EQ_Heal()
    if not UnitAffectingCombat("player") then
        -- head
        Xeon.library.item:Equip(GetInventorySlotInfo("HeadSlot"), "Redemption Headpiece")
        -- Nack
        Xeon.library.item:Equip(GetInventorySlotInfo("NeckSlot"), "Gem of Trapped Innocents")
        -- Shoulder
        Xeon.library.item:Equip(GetInventorySlotInfo("ShoulderSlot"), "Redemption Spaulders")
        -- Back
        Xeon.library.item:Equip(GetInventorySlotInfo("BackSlot"), "Cloak of Suturing")
        -- Chest
        Xeon.library.item:Equip(GetInventorySlotInfo("ChestSlot"), "Redemption Tunic")
        -- Tabard
        Xeon.library.item:Equip(GetInventorySlotInfo("TabardSlot"), "Private's Tabard")
        -- Wrist
        Xeon.library.item:Equip(GetInventorySlotInfo("WristSlot"), "Redemption Wristguards")
        -- Hand
        Xeon.library.item:Equip(GetInventorySlotInfo("HandsSlot"), "Redemption Handguards")
        -- Waist
        Xeon.library.item:Equip(GetInventorySlotInfo("WaistSlot"), "Redemption Girdle")
        -- legs
        Xeon.library.item:Equip(GetInventorySlotInfo("LegsSlot"), "Redemption Legguards")
        -- Feet
        Xeon.library.item:Equip(GetInventorySlotInfo("FeetSlot"), "Redemption Boots")
        -- ring1
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger0Slot"), "Ring of Redemption")
        -- ring2
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger1Slot"), "Pure Elementium Band")
        -- Trinket1
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket0Slot"), "Eye of the Dead")
        -- Trinket2
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket1Slot"), "Rejuvenating Gem")
        -- Range
        Xeon.library.item:Equip(GetInventorySlotInfo("RangedSlot"), "Libram of Light")
    end
end

function Xeon.class.shaman:EQ_FM()
    if not UnitAffectingCombat("player") then
        -- head
        Xeon.library.item:Equip(GetInventorySlotInfo("HeadSlot"), "Field Marshal's Lamellar Faceguard")
        -- Nack
        Xeon.library.item:Equip(GetInventorySlotInfo("NeckSlot"), "Onyxia Tooth Pendant")
        -- Shoulder
        Xeon.library.item:Equip(GetInventorySlotInfo("ShoulderSlot"), "Field Marshal's Lamellar Pauldrons")
        -- Back
        Xeon.library.item:Equip(GetInventorySlotInfo("BackSlot"), "Shroud of Dominion")
        -- Chest
        Xeon.library.item:Equip(GetInventorySlotInfo("ChestSlot"), "Field Marshal's Lamellar Chestplate")
        -- Tabard
        Xeon.library.item:Equip(GetInventorySlotInfo("TabardSlot"), "Stone Guard's Herald")
        -- Wrist
        Xeon.library.item:Equip(GetInventorySlotInfo("WristSlot"), "Wristguards of Vengeance")
        -- Hand
        Xeon.library.item:Equip(GetInventorySlotInfo("HandsSlot"), "Marshal's Lamellar Gloves")
        -- Waist
        Xeon.library.item:Equip(GetInventorySlotInfo("WaistSlot"), "Girdle of the Mentor")
        -- legs
        Xeon.library.item:Equip(GetInventorySlotInfo("LegsSlot"), "Marshal's Lamellar Legplates")
        -- Feet
        Xeon.library.item:Equip(GetInventorySlotInfo("FeetSlot"), "Marshal's Lamellar Boots")
        -- ring1
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger0Slot"), "Band of Unnatural Forces")
        -- ring2
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger1Slot"), "Master Dragonslayer's Ring")
        -- Trinket1
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket0Slot"), "Drake Fang Talisman")
        -- Trinket2
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket1Slot"), "Blackhand's Breadth")
        -- Range
        Xeon.library.item:Equip(GetInventorySlotInfo("RangedSlot"), "Libram of Fervor")
        -- MainHandSlot
        Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Corrupted Ashbringer")
    end
end

function Xeon.class.shaman:EQ_1H()
    -- MainHandSlot
    Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Might of Menethil")
end

function Xeon.class.shaman:EQ_SH()
    -- MainHandSlot
    Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Hammer of the Twisting Nether")
    -- SecondaryHandSlot
    Xeon.library.item:Equip(GetInventorySlotInfo("SecondaryHandSlot"), "Shield of Condemnation")
end
