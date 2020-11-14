Xeon.class.paladin = CreateFrame("Frame", nil, UIParent)
Xeon.class.paladin:RegisterEvent("ADDON_LOADED")

Xeon.class.paladin:SetScript(
    "OnEvent",
    function(...)
        if Xeon.library.player.values.class == "Paladin" then
            if event == "ADDON_LOADED" then
                this:UnregisterEvent("ADDON_LOADED")

                -- Register Events
                this:RegisterEvent("UI_ERROR_MESSAGE")
                return
            elseif event == "UI_ERROR_MESSAGE" then
                Xeon.library.util:DebugMsg_combat("UI_ERROR_MESSAGE : " .. arg1)
                if _sFind(arg1, "Target needs to be in front of you") or _sFind(arg1, "Target not in line of sight") and Xeon.library.player.values.activatedSpell == "Hammer of Wrath" then
                    this.values.hammerErrorTime = GetTime()
                end
                return
            end
        end
    end
)

Xeon.class.paladin:SetScript(
    "OnUpdate",
    function(...)
        if Xeon.library.player.values.class == "Paladin" then
            if GetTime() - this.values.updateTime >= 0.2 then
                this.values.updateTime = GetTime()

                this:SwapShield()
                Xeon.library.item:TrinketSwap(13, "Healing")
                Xeon.library.item:TrinketSwap(14, "Survive")
                return
            end
        end
    end
)

Xeon.class.paladin.values = {
    updateTime = GetTime(),
    hammerList = {},
    justiceList = {},
    secrificeNum = 0,
    secrificeList = {},
    hammerErrorTime = GetTime()
}

function Xeon.class.paladin:SwapShield()
    if not UnitIsDeadOrGhost("player") and Xeon.library.item:IsEquiped(16, "Hammer of the Twisting Nether") then
        if Xeon.library.player.values.isMoving and Xeon.library.combat:isUnderAttack("MELEE") then
            Xeon.library.item:Equip(17, "Stygian Buckler")
        elseif Xeon.library.player.values.isCasting then
            Xeon.library.item:Equip(17, "Shield of Condemnation")
        end
    end
end

function Xeon.class.paladin:Heal()
    local _T = GetTime()
    local cd_noggen = _T > Xeon.library.player.values.noggenTime and true or false
    local notActive = Xeon.library.player.values.isActivity and false or true
    local notCasting = Xeon.library.player.values.isCasting and false or true
    -- _print(_T - Xeon.library.player.values.healInactiveTime)
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

        if notCasting and Xeon.library.player.values.activatedSpell ~= "Hammer of Wrath" then
        --  Xeon.library.heal:StopOverHeal()
        end

        -- check MP
        if UnitAffectingCombat("player") and healTargetPerHP and healTargetPerHP <= 60 and Xeon.library.util:UnitMP("player") <= 10 then
            if Xeon.library.item:UseBagItem("Mana Potion") or Xeon.library.item:UseBagItem("Mana Draught") then
                return
            end
        end

        -- self dispell
        -- divine shield is ready or trinket's cooldown is readty
        local divineReady = (Xeon.library.util:IsSpellReady("Divine Shield") and not Xeon.library.buff:IsDebuffed("Forbearance", "player")) and true or false

        local protectionReady = (Xeon.library.util:IsSpellReady("Blessing of Protection") and not Xeon.library.buff:IsDebuffed("Forbearance", "player")) and true or false

        local isEmergency
        --_print("x : ".._txt(Xeon.library.heal.values.toDo))
        --_print("y : ".._txt(Xeon.library.heal.values.dispellInfo.priority))
        if (healTargetPerHP and healTargetPerHP <= 80) or (Xeon.library.heal.values.toDo == "DISPELL" and Xeon.library.heal.values.dispellInfo.priority == "A") then
            isEmergency = true
        end

        if true then
            if Xeon.library.buff.values.playerDebuff["FEAR"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    elseif divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["FLEE"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    elseif divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["CHARM"] then
                if isEmergency then
                    if divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["POLYMORPH"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    elseif divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["SAP"] then
                if isEmergency then
                    if divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["STUN"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    elseif divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["BLIND"] then
                if isEmergency then
                    if divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["HORR"] then
                if isEmergency then
                    if Xeon.library.item:UseEquippedItem("Insignia") then
                        return
                    elseif divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["FROZEN"] then
                if isEmergency then
                    if divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            elseif Xeon.library.buff.values.playerDebuff["SILENCE"] then
                if isEmergency then
                    if divineReady and notActive then
                        Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                        return
                    else
                        return
                    end
                end
            -- elseif Xeon.library.buff.values.playerDebuff["COT"] then   ?? divine??
            end
        end
        -- survive
        if UnitAffectingCombat("player") then
            if not Xeon.library.player.values.isMoving then
                if Xeon.library.util:UnitHP("player") <= 40 then
                    if Xeon.library.combat:isUnderAttack("CASTER") then
                        if Xeon.library.item:UseEquippedItem("Loatheb's Reflection") then
                            return
                        end
                    end
                    if Xeon.library.item:UseBagItem("Healing Potion") or Xeon.library.item:UseBagItem("Healing Draught") or Xeon.library.item:UseBagItem("Healthstone") then
                        return
                    end
                    if Xeon.library.item:UseEquippedItem("The Burrower's Shell") then
                        return
                    end
                elseif Xeon.library.util:UnitHP("player") <= 30 then
                    if Xeon.library.player.values.isCasting and Xeon.library.player.values.activatedSpell ~= "Hammer of Wrath" then
                        SpellStopCasting()
                    else
                        if divineReady and notActive then
                            Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                            return
                        elseif protectionReady and Xeon.library.combat:isUnderAttack("MELEE") and notActive then
                            Xeon.library.combat:CastSpell("Blessing of Protection", "player")
                            return
                        end
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
                        return
                    end
                    if Xeon.library.item:UseEquippedItem("The Burrower's Shell") then
                        return
                    end
                elseif Xeon.library.util:UnitHP("player") <= 40 then
                    if Xeon.library.player.values.isCasting and Xeon.library.player.values.activatedSpell ~= "Hammer of Wrath" then
                        SpellStopCasting()
                    else
                        if divineReady and notActive then
                            Xeon.library.combat:CastSpell("Divine Shield", "player", "NONE_TARGET")
                            return
                        elseif protectionReady and Xeon.library.combat:isUnderAttack("MELEE") and notActive then
                            Xeon.library.combat:CastSpell("Blessing of Protection", "player")
                            return
                        end
                    end
                end
            end
        end

        if notActive then
            -- self buff
            if Xeon.library.player.values.zone == "The Molten Core" then
                if not Xeon.library.buff:IsBuffed("Fire Resistance Aura", "player") and Xeon.library.util:IsSpellReady("Fire Resistance Aura") then
                    Xeon.library.combat:CastSpell("Fire Resistance Aura", "player", "NONE_TARGET")
                    return
                end
            else
                if not Xeon.library.buff:IsBuffed("Concentration Aura", "player") and Xeon.library.util:IsSpellReady("Concentration Aura") then
                    Xeon.library.combat:CastSpell("Concentration Aura", "player", "NONE_TARGET")
                    return
                end
            end

            if
                not UnitAffectingCombat("player") and Xeon.library.util:IsSpellReady("Blessing of Wisdom") and not Xeon.library.buff:IsBuffed("Blessing of Wisdom", "player") and
                    not Xeon.library.buff:IsBuffed("Blessing of Freedom", "player") and
                    not Xeon.library.buff:IsBuffed("Blessing of Protection", "player") and
                    not Xeon.library.buff:IsBuffed("Mana Spring", "player")
             then
                Xeon.library.combat:CastSpell("Greater Blessing of Wisdom", "player")
                return
            end

            -- Hammer of Justice
            if Xeon.library.util:IsSpellReady("Hammer of Justice") and not Xeon.library.player.values.isCasting then
                if self.values.justiceList[1] and Xeon.library.util:IsEnemyPlayer(self.values.justiceList[1]) then
                    if CheckInteractDistance(self.values.justiceList[1], 3) then
                        Xeon.library.combat:CastSpell("Hammer of Justice", self.values.justiceList[1])
                        return
                    end
                elseif
                    targetIsEnemy and CheckInteractDistance("target", 3) and UnitIsPlayer("target") and
                        not (Xeon.library.enemy:IsEnemyBuffed("Divine Shield", "target") or Xeon.library.enemy:IsEnemyBuffed("Ice Block", "target")) and
                        (Xeon.library.enemy:IsEnemyCasting("target") or Xeon.library.util:UnitHP("player") <= 70)
                 then
                    Xeon.library.combat:CastSpell("Hammer of Justice", "target")
                    return
                elseif
                    GetNumBattlefieldStats() ~= 0 and Xeon.library.combat:isUnderAttack("MELEE") and not Xeon.library.enemy:IsEnemyBuffed("Divine Shield", Xeon.library.combat:isUnderAttack("MELEE"))
                 then
                    TargetByName(Xeon.library.combat:isUnderAttack("MELEE"))
                    Xeon.library.combat:CastSpell("Hammer of Justice", "target")
                    return
                end
            end

            -- Hammer of warth
            if
                not healTargetPerHP or
                    healTargetPerHP >= Xeon.cfg.paladin.hammerOfWarthHP_rate and Xeon.library.util:IsSpellReady("Hammer of Wrath") and not Xeon.library.player.values.isMoving and
                        not Xeon.library.player.values.isCasting and
                        not (GetTime() - self.values.hammerErrorTime >= 3)
             then
                if Xeon.cfg.paladin.useHammerOfWarth == 1 then
                    if
                        targetIsEnemy and Xeon.library.util:IsEnemyPlayer("target") and Xeon.library.util:UnitHP("target") <= 20 and
                            not (Xeon.library.enemy:IsEnemyBuffed("Divine Shield", "target") and Xeon.library.enemy:IsEnemyBuffed("Ice Block", "target"))
                     then
                        Xeon.library.combat:CastSpell("Hammer of Wrath", "target")
                        return
                    elseif self.values.hammerList[1] then
                        Xeon.library.combat:CastSpell("Hammer of Wrath", self.values.hammerList[1])
                        return
                    end
                elseif Xeon.cfg.paladin.useHammerOfWarth == 2 then
                    if
                        targetIsEnemy and Xeon.library.util:UnitHP("target") <= 20 and
                            not (Xeon.library.enemy:IsEnemyBuffed("Divine Shield", "target") and Xeon.library.enemy:IsEnemyBuffed("Ice Block", "target"))
                     then
                        Xeon.library.combat:CastSpell("Hammer of Wrath", "target")
                        return
                    end
                end
            end

            -- heal part
            if Xeon.library.heal.values.toDo then
                if Xeon.library.heal.values.toDo == "HEAL" then
                    if not Xeon.library.player.values.isMoving and notCasting and notHealCasting then
                        -- use healing power trinkets
                        if ((Xeon.library.heal.values.injuredIn11y >= 2 or Xeon.library.heal.values.injuredIn28y >= 2) and healTargetPerHP < 60) or healTargetPerHP < 50 then
                            if Xeon.library.item:UseEquippedItem("Eye of the Dead") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Scrolls of Blinding Light") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Hibernation Crystal") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Scarab Brooch") then
                                return
                            elseif Xeon.library.item:UseEquippedItem("Zandalarian Hero Charm") then
                                return
                            end
                        end
                        -- normal healing
                        if healTargetPerHP <= 20 and Xeon.library.util:IsSpellReady("Flash of Light") then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Flash of Light", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif healTargetPerHP <= 20 and Xeon.library.util:UnitMP("player") <= 10 and Xeon.library.util:IsSpellReady("Lay on Hands") then
                            Xeon.library.combat:CastSpell("Lay on Hands", Xeon.library.heal.values.healTarget)
                            return
                        elseif healTargetPerHP <= 50 and Xeon.library.util:IsLearned("Divine Favor") and Xeon.library.util:IsSpellReady("Divine Favor") then
                            Xeon.library.combat:CastSpell("Divine Favor", "player", "NONE_TARGET")
                            return
                        elseif
                            healTargetPerHP <= 85 and (Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget) <= Xeon.cfg.paladin.lossHP_point_flashOfLight) and
                                (Xeon.library.util:IsSpellReady("Flash of Light"))
                         then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Flash of Light", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        elseif
                            healTargetPerHP <= 85 and (Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget) > Xeon.cfg.paladin.lossHP_point_flashOfLight) and
                                (Xeon.library.util:IsSpellReady("Holy Light"))
                         then
                            Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Holy Light", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget))
                            return
                        else
                            -- target healing mode
                            if Xeon.library.heal.values.healTarget and Xeon.library.player.values.target then
                                if UnitIsUnit(Xeon.library.heal.values.healTarget, "target") and UnitAffectingCombat("target") and (Xeon.library.util:IsSpellReady("Flash of Light")) then
                                    Xeon.library.combat:CastHeal(Xeon.library.heal.values.healTarget, "Flash of Light", Xeon.library.util:UnitLossesHP(Xeon.library.heal.values.healTarget), 1)
                                    return
                                end
                            end
                        end
                    elseif healTargetPerHP <= 30 and Xeon.library.util:IsSpellReady("Blessing of Protection") then
                        Xeon.library.combat:CastSpell("Blessing of Protection", Xeon.library.heal.values.healTarget)
                        return
                    elseif healTargetPerHP <= 20 and Xeon.library.util:IsSpellReady("Lay on Hands") then
                        Xeon.library.combat:CastSpell("Lay on Hands", Xeon.library.heal.values.healTarget)
                        return
                    end
                elseif Xeon.library.heal.values.toDo == "DISPELL" then
                    if Xeon.library.heal.values.dispellInfo.dispellType == "ETC" and protectionReady then
                        Xeon.library.combat:CastSpell("Blessing of Protection", Xeon.library.heal.values.dispellInfo.unit)
                        return
                    elseif Xeon.library.heal.values.dispellInfo.dispellType == "SLOW" and Xeon.library.util:IsSpellReady("Blessing of Freedom") then
                        Xeon.library.combat:CastSpell("Blessing of Freedom", Xeon.library.heal.values.dispellInfo.unit)
                        return
                    elseif Xeon.library.heal.values.dispellInfo.dispellType == "MAGIC" and Xeon.library.util:IsSpellReady("Cleanse") then
                        Xeon.library.combat:CastSpell("Cleanse", Xeon.library.heal.values.dispellInfo.unit)
                        return
                    elseif Xeon.library.heal.values.dispellInfo.dispellType == "POISON" and Xeon.library.util:IsSpellReady("Cleanse") then
                        Xeon.library.combat:CastSpell("Cleanse", Xeon.library.heal.values.dispellInfo.unit)
                        return
                    end
                elseif Xeon.library.heal.values.toDo == "BUFF" and Xeon.library.util:IsSpellReady(Xeon.library.heal.values.buffInfo.buff) then
                    Xeon.library.combat:CastSpell(Xeon.library.heal.values.buffInfo.buff, Xeon.library.heal.values.buffInfo.unit)
                    return
                end
            end
        end
    end
end

function Xeon.class.paladin:DPS()
    if not UnitName("target") then
        TargetNearestEnemy()
    end
    Xeon.library.player.values.target = UnitName("target")
    -- dps part
    if not (Xeon.library.enemy:IsEnemyBuffed("Divine Shield", "target") and Xeon.library.enemy:IsEnemyBuffed("Ice Block", "target")) and CheckInteractDistance("target", 4) then
        if Xeon.library.util:IsSpellReady("Hammer of Wrath") and not Xeon.library.player.values.isMoving and not Xeon.library.player.values.isCasting then
            if Xeon.library.util:UnitHP("target") <= 20 then
                Xeon.library.combat:CastSpell("Hammer of Wrath", "target")
                return
            end
        end
        if CheckInteractDistance("target", 3) and Xeon.library.util:IsSpellReady("Hammer of Justice") and not Xeon.library.player.values.isCasting then
            if Xeon.library.enemy:IsEnemyCasting("target") or Xeon.library.util:UnitHP("player") < 40 then
                Xeon.library.combat:CastSpell("Hammer of Justice", "target")
                return
            end
        end
        if not GetInventoryItemLink("player", 17) then
            if not Xeon.library.buff:IsDebuffed("Judgement of the Crusader", "target") then
                if not Xeon.library.buff:IsBuffed("Seal of the Crusader", "player") and Xeon.library.util:IsSpellReady("Seal of the Crusader") then
                    Xeon.library.combat:CastSpell("Seal of the Crusader", "player", "NONE_TARGET")
                    return
                elseif CheckInteractDistance("target", 3) and Xeon.library.util:IsSpellReady("Judgement") then
                    Xeon.library.combat:CastSpell("Judgement", "target")
                    return
                end
            elseif not (Xeon.library.buff:IsBuffed("Seal of Righteousness", "player") or Xeon.library.buff:IsBuffed("Seal of Command", "player")) then
                if Xeon.library.util:IsLearned("Seal of Command") and Xeon.library.util:IsSpellReady("Seal of Command") then
                    Xeon.library.combat:CastSpell("Seal of Command", "player", "NONE_TARGET")
                    return
                elseif Xeon.library.util:IsSpellReady("Seal of Righteousness") then
                    Xeon.library.combat:CastSpell("Seal of Righteousness", "player", "NONE_TARGET")
                    return
                end
            elseif CheckInteractDistance("target", 3) and Xeon.library.util:IsSpellReady("Judgement") then
                Xeon.library.combat:CastSpell("Judgement", "target")
                return
            end
        else
            if not Xeon.library.buff:IsBuffed("Seal of Justice", "player") and Xeon.library.util:IsSpellReady("Seal of Justice") then
                Xeon.library.combat:CastSpell("Seal of Justice", "player", "NONE_TARGET")
                return
            end
        end
        if CheckInteractDistance("target", 3) then
            Xeon.library.util:Attack()
            return
        end
    end
end

function Xeon.class.paladin:EQ_DPS()
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

function Xeon.class.paladin:EQ_Heal()
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

function Xeon.class.paladin:EQ_FM()
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

function Xeon.class.paladin:EQ_1H()
    -- MainHandSlot
    Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Might of Menethil")
end

function Xeon.class.paladin:EQ_SH()
    -- MainHandSlot
    Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Hammer of the Twisting Nether")
    -- SecondaryHandSlot
    Xeon.library.item:Equip(GetInventorySlotInfo("SecondaryHandSlot"), "Shield of Condemnation")
end
