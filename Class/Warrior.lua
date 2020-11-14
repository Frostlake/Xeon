-- warr 2H PvE dps
-- https://www.bobo-talents.com/?c=warrior&t=qfrqrryKyLyMqlryrzrArBqmslsxsHySyTqCsyszsAsBqEs8s9s_s.qIsQH2qcrsrtyNyOqjp-rIrJrKrLqkqisYqAsCH8H9qerCsD
-- warr aoe aggro tank

Xeon.class.warrior = CreateFrame("Frame", nil, UIParent)
Xeon.class.warrior:RegisterEvent("ADDON_LOADED")

Xeon.class.warrior:SetScript(
    "OnEvent",
    function(...)
        if Xeon.library.player.values.class == "Warrior" then
            if event == "ADDON_LOADED" then
                this:UnregisterEvent("ADDON_LOADED")

                -- Register Events
                this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES")
                this:RegisterEvent("CHAT_MSG_COMBAT_SELF_MISSES")
                this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
                -- this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
                return
            elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_MISSES" then
                this.values.revengeTime = GetTime()
                return
            elseif event == "CHAT_MSG_COMBAT_SELF_MISSES" then
                for unitName, targetName in string.gfind(arg1, "(.+) attack.(.+) dodges.") do
                    if (unitName ~= "You") then
                        return
                    end
                    this.values.opTime = GetTime()
                    return
                end
            elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
                for targetName, spell in string.gfind(arg1, "Your (.+) was dodged by (.+).") do
                    this.values.opTime = GetTime()
                    return
                end
            elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
                if _sFind(arg1, "Rage from Charge") then
                    this.values.chargeTime = GetTime()
                end
                return
            end
        end
    end
)

Xeon.class.warrior:SetScript(
    "OnUpdate",
    function(...)
        if Xeon.library.player.values.class == "Warrior" then
            if GetTime() - this.values.updateTime >= 0.2 then
                this.values.updateTime = GetTime()
                if Xeon.library.item:IsEquiped(GetInventorySlotInfo("HeadSlot"), "Dreadnaught Helmet") then
                    --  Xeon.library.item:TrinketSwap(14, "Survive")
                else
                    -- Xeon.library.item:TrinketSwap(13, "Melee_DPS")
                end
                --   Xeon.library.item:TrinketSwap(13, "Melee_DPS")
                return
            end
        end
    end
)

Xeon.class.warrior.values = {
    updateTime = GetTime(),
    stance = nil,
    revengeTime = GetTime(),
    opTime = GetTime(),
    chargeTime = GetTime()
}

function Xeon.class.warrior:GetSunderInfo()
    for i = 1, 40 do
        local icon, count = UnitDebuff("target", i)
        if _sFind(icon, "sunder") then
            return count
        end
    end
    return nil
end

function Xeon.class.warrior:GetNearbyGroupMembersCount()
    local numRaidMembers = GetNumRaidMembers()
    local numPartyMembers = GetNumPartyMembers()
    local count = 1

    if numRaidMembers > 0 then
        for i = 1, numRaidMembers do
            if Xeon.library.heal:IsHealable("raid" .. i) and CheckInteractDistance("raid" .. i, 2) then
                count = count + 1
            end
            if Xeon.library.heal:IsHealable("raidpet" .. i) and CheckInteractDistance("raidpet" .. i, 2) then
                count = count + 1
            end
        end
    elseif numPartyMembers > 0 then
        for i = 1, numPartyMembers do
            if Xeon.library.heal:IsHealable("party" .. i) and CheckInteractDistance("party" .. i, 2) then
                count = count + 1
            end
            if Xeon.library.heal:IsHealable("partypet" .. i) and CheckInteractDistance("partypet" .. i, 2) then
                count = count + 1
            end
        end
    end
    return count
end

function Xeon.class.warrior:DPS()
    local _T = GetTime()
    --local cd_global = _T - Xeon.library.player.values.globalcooldownTime >= 1.5 and true or false
    local cd_noggen = _T > Xeon.library.player.values.noggenTime and true or false

    -- local notActive = Xeon.library.player.values.isActivity and false or true

    local _, _, isBattle = GetShapeshiftFormInfo(1)
    local _, _, isDefensive = GetShapeshiftFormInfo(2)
    local _, _, isBerserker = GetShapeshiftFormInfo(3)
    if isBattle then
        self.values.stance = "Battle Stance"
    elseif isDefensive then
        self.values.stance = "Defensive Stance"
    elseif isBerserker then
        self.values.stance = "Berserker Stance"
    end

    local isMeleeRange
    -- dps part
    if not UnitIsDeadOrGhost("player") then
        -- use Noggen and Rum
        if cd_noggen then
        --    Xeon.library.item:UseNoggen()
        end

        Xeon.library.player.values.target = UnitName("target")
        if not Xeon.library.player.values.target then
            TargetNearestEnemy()
            return
        end
        isMeleeRange = CheckInteractDistance("target", 3)
        local targetIsEnemy = (Xeon.library.player.values.target and UnitIsEnemy("player", "target")) and true or false

        -- self dispell
        self:COMMON_SELF_DISPELL()

        -- survive
        self:COMMON_SURVIVE()

        -- self buff
        self:COMMON_SELF_BUFF()

        -- dps

        if isMeleeRange then
            if Xeon.library.buff:IsDebuffed("Disarm", "player") then
                -- disarm
                if self.values.stance ~= "Defensive Stance" and Xeon.library.util:IsSpellReady("Defensive Stance") then
                    Xeon.library.combat:CastSpell("Defensive Stance", "player", "NONE_TARGET")
                    return
                else
                end
            else
                -- normal
                ---- ATTACK!!!
                Xeon.library.util:Attack()

                self:EQ_Weapon()
                self:COMMON_USE_TRINKET()
                if Xeon.library.util:IsSpellReady("Execute") and Xeon.library.util:UnitMP("player") >= 10 and Xeon.library.util:UnitHP("target") <= 20 then
                    Xeon.library.combat:StanceCast("Execute", "target")
                    return
                end
                --[[ if
                    Xeon.library.util:IsSpellReady("Berserker Rage") and not Xeon.library.util:IsEnemyPlayer("target") and
                        (self.values.stance == "Berserker Stance" or (self.values.stance ~= "Berserker Stance") and Xeon.library.util:UnitMP("player") <= 25)
                 then
                    Xeon.library.combat:StanceCast("Berserker Rage", "player", "NONE_TARGET")
                    return
                end ]]
                if Xeon.library.util:IsSpellReady("Berserker Rage") and not Xeon.library.util:IsEnemyPlayer("target") and Xeon.library.util:UnitMP("player") <= 25 then
                    Xeon.library.combat:StanceCast("Berserker Rage", "player", "NONE_TARGET")
                    return
                end

                --[[ if
                    Xeon.library.util:IsSpellReady("Overpower") and GetTime() - self.values.opTime <= 5 and Xeon.library.util:UnitMP("player") >= 5 and
                        (self.values.stance == "Battle Stance" or (self.values.stance ~= "Battle Stance") and Xeon.library.util:UnitMP("player") <= 25)
                 then
                    Xeon.library.combat:StanceCast("Overpower", "target")
                    return
                end ]]
                if Xeon.library.util:IsLearned("Bloodthirst") and Xeon.library.util:IsSpellReady("Bloodthirst") and Xeon.library.util:UnitMP("player") >= 30 then
                    Xeon.library.combat:CastSpell("Bloodthirst", "target")
                    return
                end

                if Xeon.library.util:IsLearned("Mortal Strike") and Xeon.library.util:IsSpellReady("Mortal Strike") and Xeon.library.util:UnitMP("player") >= 30 then
                    Xeon.library.combat:CastSpell("Mortal Strike", "target")
                    return
                end

                --[[ if
                    Xeon.library.util:IsSpellReady("Whirlwind") and Xeon.library.util:UnitMP("player") >= 25 and
                        (self.values.stance == "Berserker Stance" or (self.values.stance ~= "Berserker Stance") and Xeon.library.util:UnitMP("player") <= 35)
                 then
                    Xeon.library.combat:StanceCast("Whirlwind", "target")
                    return
                end ]]
                if Xeon.library.util:IsSpellReady("Whirlwind") and Xeon.library.util:UnitMP("player") >= 25 then
                    Xeon.library.combat:StanceCast("Whirlwind", "target")
                    return
                end

                if Xeon.library.util:IsSpellReady("Heroic Strike") and Xeon.library.util:UnitMP("player") >= 42 then
                    Xeon.library.combat:CastSpell("Heroic Strike", "target")
                    return
                end
            end
        else
            -- target is not in the melee distance
            self:COMMON_RANGE()
        end
    end
end

function Xeon.class.warrior:DPS_TANK()
    local _T = GetTime()
    --local cd_global = _T - Xeon.library.player.values.globalcooldownTime >= 1.5 and true or false
    local cd_noggen = _T > Xeon.library.player.values.noggenTime and true or false

    -- local notActive = Xeon.library.player.values.isActivity and false or true

    local _, _, isBattle = GetShapeshiftFormInfo(1)
    local _, _, isDefensive = GetShapeshiftFormInfo(2)
    local _, _, isBerserker = GetShapeshiftFormInfo(3)
    if isBattle then
        self.values.stance = "Battle Stance"
    elseif isDefensive then
        self.values.stance = "Defensive Stance"
    elseif isBerserker then
        self.values.stance = "Berserker Stance"
    end

    local isMeleeRange
    -- dps part
    if not UnitIsDeadOrGhost("player") then
        -- use Noggen and Rum
        if cd_noggen then
        --    Xeon.library.item:UseNoggen()
        end

        Xeon.library.player.values.target = UnitName("target")
        if not Xeon.library.player.values.target then
            TargetNearestEnemy()
            return
        end
        isMeleeRange = CheckInteractDistance("target", 3)
        local targetIsEnemy = (Xeon.library.player.values.target and UnitIsEnemy("player", "target")) and true or false

        -- self dispell
        self:COMMON_SELF_DISPELL()

        -- survive
        self:COMMON_SURVIVE()

        -- self buff
        self:COMMON_SELF_BUFF()

        -- dps

        if isMeleeRange then
            if Xeon.library.buff:IsDebuffed("Disarm", "player") then
                -- disarm
                if self.values.stance ~= "Defensive Stance" and Xeon.library.util:IsSpellReady("Defensive Stance") then
                    Xeon.library.combat:CastSpell("Defensive Stance", "player", "NONE_TARGET")
                    return
                else
                end
            else
                -- normal
                ---- ATTACK!!!
                Xeon.library.util:Attack()

                self:EQ_Weapon()
                self:COMMON_USE_TRINKET()
                if Xeon.library.util:IsSpellReady("Execute") and Xeon.library.util:UnitMP("player") >= 10 and Xeon.library.util:UnitHP("target") <= 20 then
                    Xeon.library.combat:StanceCast("Execute", "target")
                    return
                end

                if Xeon.library.util:IsSpellReady("Berserker Rage") and not Xeon.library.util:IsEnemyPlayer("target") and Xeon.library.util:UnitMP("player") <= 25 then
                    Xeon.library.combat:StanceCast("Berserker Rage", "player", "NONE_TARGET")
                    return
                end

                if (self.values.stance == "Battle Stance" or (self.values.stance ~= "Battle Stance") and Xeon.library.util:UnitMP("player") <= 25) then
                    if Xeon.library.util:IsSpellReady("Overpower") and GetTime() - self.values.opTime <= 5 and Xeon.library.util:UnitMP("player") >= 5 then
                        Xeon.library.combat:StanceCast("Overpower", "target")
                        return
                    end

                    if not Xeon.library.buff:IsDebuffed("Demoralizing Shout", "target") and Xeon.library.util:IsSpellReady("Demoralizing Shout") and Xeon.library.util:UnitMP("player") >= 10 then
                        Xeon.library.combat:CastSpell("Demoralizing Shout", "player", "NONE_TARGET")
                        return
                    end

                    if not Xeon.library.buff:IsDebuffed("Rend", "target") and Xeon.library.util:IsSpellReady("Rend") and Xeon.library.util:UnitMP("player") >= 10 then
                        Xeon.library.combat:StanceCast("Rend", "target")
                        return
                    end

                    if not Xeon.library.buff:IsDebuffed("Thunder Clap", "target") and Xeon.library.util:IsSpellReady("Thunder Clap") and Xeon.library.util:UnitMP("player") >= 20 then
                        Xeon.library.combat:CastSpell("Thunder Clap", "player", "NONE_TARGET")
                        return
                    end
                end

                
                if Xeon.library.util:IsLearned("Bloodthirst") and Xeon.library.util:IsSpellReady("Bloodthirst") and Xeon.library.util:UnitMP("player") >= 30 then
                    Xeon.library.combat:CastSpell("Bloodthirst", "target")
                    return
                end

                if Xeon.library.util:IsLearned("Mortal Strike") and Xeon.library.util:IsSpellReady("Mortal Strike") and Xeon.library.util:UnitMP("player") >= 30 then
                    Xeon.library.combat:CastSpell("Mortal Strike", "target")
                    return
                end

                if Xeon.library.util:IsSpellReady("Whirlwind") and Xeon.library.util:UnitMP("player") >= 25 then
                    Xeon.library.combat:StanceCast("Whirlwind", "target")
                    return
                end

                if Xeon.library.util:IsSpellReady("Heroic Strike") and Xeon.library.util:UnitMP("player") >= 42 then
                    Xeon.library.combat:CastSpell("Heroic Strike", "target")
                    return
                end
            end
        else
            -- target is not in the melee distance
            self:COMMON_RANGE()
        end
    end
end

function Xeon.class.warrior:DPS_AOE()
    local _T = GetTime()
    --local cd_global = _T - Xeon.library.player.values.globalcooldownTime >= 1.5 and true or false
    local cd_noggen = _T > Xeon.library.player.values.noggenTime and true or false

    -- local notActive = Xeon.library.player.values.isActivity and false or true

    local _, _, isBattle = GetShapeshiftFormInfo(1)
    local _, _, isDefensive = GetShapeshiftFormInfo(2)
    local _, _, isBerserker = GetShapeshiftFormInfo(3)
    if isBattle then
        self.values.stance = "Battle Stance"
    elseif isDefensive then
        self.values.stance = "Defensive Stance"
    elseif isBerserker then
        self.values.stance = "Berserker Stance"
    end

    local isMeleeRange
    -- dps part
    if not UnitIsDeadOrGhost("player") then
        -- use Noggen and Rum
        if cd_noggen then
        --   Xeon.library.item:UseNoggen()
        end

        Xeon.library.player.values.target = UnitName("target")
        if not Xeon.library.player.values.target then
            TargetNearestEnemy()
            return
        end
        isMeleeRange = CheckInteractDistance("target", 3)
        local targetIsEnemy = (Xeon.library.player.values.target and UnitIsEnemy("player", "target")) and true or false

        -- self dispell
        self:COMMON_SELF_DISPELL()

        -- survive
        self:COMMON_SURVIVE()

        -- self buff
        self:COMMON_SELF_BUFF()

        -- dps

        if isMeleeRange then
            if Xeon.library.buff:IsDebuffed("Disarm", "player") then
                -- disarm
                if self.values.stance ~= "Defensive Stance" and Xeon.library.util:IsSpellReady("Defensive Stance") then
                    Xeon.library.combat:CastSpell("Defensive Stance", "player", "NONE_TARGET")
                    return
                else
                end
            else
                -- normal
                ---- ATTACK!!!
                Xeon.library.util:Attack()

                --  self:EQ_2H()
                self:COMMON_USE_TRINKET()

                if
                    self.values.stance == "Battle Stance" and Xeon.library.util:IsLearned("Sweeping Strikes") and Xeon.library.util:IsSpellReady("Sweeping Strikes") and
                        Xeon.library.util:IsSpellReady("Bloodrage") and
                        Xeon.library.util:UnitMP("player") < 30
                 then
                    Xeon.library.combat:CastSpell("Bloodrage", "player", "NONE_TARGET")
                    return
                end

                if Xeon.library.util:IsLearned("Sweeping Strikes") and Xeon.library.util:IsSpellReady("Sweeping Strikes") then
                    Xeon.library.combat:StanceCast("Sweeping Strikes", "player", "NONE_TARGET")
                    return
                end

                if self.values.stance ~= "Berserker Stance" and Xeon.library.util:IsSpellReady("Berserker Stance") then
                    Xeon.library.combat:CastSpell("Berserker Stance", "player", "NONE_TARGET")
                    return
                end

                if Xeon.library.buff:IsBuffed("Sweeping Strikes", "player") then
                    --[[ if Xeon.library.util:IsSpellReady("Overpower") and GetTime() - self.values.opTime <= 5 and self.values.stance == "Battle Stance" then
                        Xeon.library.combat:CastSpell("Overpower", "target")
                        return
                    end ]]
                    if Xeon.library.util:IsSpellReady("Execute") and Xeon.library.util:UnitMP("player") >= 10 and Xeon.library.util:UnitHP("target") <= 20 then
                        Xeon.library.combat:StanceCast("Execute", "target")
                        return
                    end
                    if Xeon.library.util:IsLearned("Mortal Strike") and Xeon.library.util:IsSpellReady("Mortal Strike") and Xeon.library.util:UnitMP("player") >= 30 then
                        Xeon.library.combat:CastSpell("Mortal Strike", "target")
                        return
                    end
                    if Xeon.library.util:IsSpellReady("Heroic Strike") and Xeon.library.util:UnitMP("player") >= 42 then
                        Xeon.library.combat:CastSpell("Heroic Strike", "target")
                        return
                    end
                else
                    if Xeon.library.util:IsSpellReady("Whirlwind") and Xeon.library.util:UnitMP("player") >= 25 then
                        Xeon.library.combat:StanceCast("Whirlwind", "target")
                        return
                    end
                    if Xeon.library.util:IsSpellReady("Cleave") and Xeon.library.util:UnitMP("player") >= 45 then
                        Xeon.library.combat:CastSpell("Cleave", "target")
                        return
                    end
                end
            end
        else
            -- target is not in the melee distance
            self:COMMON_RANGE()
        end
    end
end

function Xeon.class.warrior:TANK()
    local _T = GetTime()
    local cd_global = _T - Xeon.library.player.values.globalcooldownTime >= 1.5 and true or false
    local cd_item = true
    local cd_noggen = _T > Xeon.library.player.values.noggenTime and true or false
    local notActive = Xeon.library.player.values.isActivity and false or true

    local _, _, isBattle = GetShapeshiftFormInfo(1)
    local _, _, isDefensive = GetShapeshiftFormInfo(2)
    local _, _, isBerserker = GetShapeshiftFormInfo(3)
    if isBattle then
        self.values.stance = "Battle Stance"
    elseif isDefensive then
        self.values.stance = "Defensive Stance"
    elseif isBerserker then
        self.values.stance = "Berserker Stance"
    end

    local isMeleeRange
    -- dps part
    if not UnitIsDeadOrGhost("player") then
        -- use Noggen and Rum
        if cd_noggen then
        --    Xeon.library.item:UseNoggen()
        end

        Xeon.library.player.values.target = UnitName("target")
        if not Xeon.library.player.values.target then
            TargetNearestEnemy()
            return
        end
        isMeleeRange = CheckInteractDistance("target", 3)
        local targetIsEnemy = (Xeon.library.player.values.target and UnitIsEnemy("player", "target")) and true or false

        local isTargetMe = UnitIsUnit("targettarget", "player")

        -- self dispell
        self:COMMON_SELF_DISPELL()

        -- survive
        self:COMMON_SURVIVE()

        -- self buff
        self:COMMON_SELF_BUFF()
        -- dps

        if isMeleeRange then
            -- normal
            ---- ATTACK!!!
            Xeon.library.util:Attack()
            -- taunt
            if not isTargetMe and UnitAffectingCombat("target") and not Xeon.library.util:IsEnemyPlayer("target") then
                self:COMMON_TANK_TAUNT()
            end

            self:EQ_SH()
            self:COMMON_USE_TRINKET()

            if Xeon.library.util:IsSpellReady("Berserker Rage") then
                if not Xeon.library.util:IsEnemyPlayer("target") then
                    Xeon.library.combat:StanceCast("Berserker Rage", "player", "NONE_TARGET")
                    return
                end
            end

            -- change stance to defensive
            if self.values.stance ~= "Defensive Stance" and Xeon.library.util:IsSpellReady("Defensive Stance") then
                Xeon.library.combat:CastSpell("Defensive Stance", "player", "NONE_TARGET")
                return
            end

            if Xeon.library.util:IsSpellReady("Bloodrage") and Xeon.library.util:UnitMP("player") <= 10 then
                if not Xeon.library.util:IsEnemyPlayer("target") then
                    Xeon.library.combat:CastSpell("Bloodrage", "player", "NONE_TARGET")
                    return
                end
            end

            if Xeon.library.util:IsSpellReady("Revenge") and GetTime() - self.values.revengeTime <= 4 and Xeon.library.util:UnitMP("player") >= 5 then
                Xeon.library.combat:StanceCast("Revenge", "target")
                return
            end

            if Xeon.library.util:IsSpellReady("Sunder Armor") and Xeon.library.util:UnitMP("player") >= 15 then
                if not Xeon.library.buff:IsDebuffed("Sunder Armor", "target") or self:GetSunderInfo() < 5 then
                    Xeon.library.combat:StanceCast("Sunder Armor", "target")
                    return
                end
            end

            if Xeon.library.util:IsSpellReady("Shield Block") and Xeon.library.util:UnitMP("player") >= 10 and Xeon.library.util:UnitHP("player") <= 50 then
                Xeon.library.combat:StanceCast("Shield Block", "player", "NONE_TARGET")
                return
            end

            if Xeon.library.util:IsLearned("Bloodthirst") and Xeon.library.util:IsSpellReady("Bloodthirst") and Xeon.library.util:UnitMP("player") >= 30 then
                Xeon.library.combat:CastSpell("Bloodthirst", "target")
                return
            end

            if Xeon.library.util:IsLearned("Mortal Strike") and Xeon.library.util:IsSpellReady("Mortal Strike") and Xeon.library.util:UnitMP("player") >= 30 then
                Xeon.library.combat:CastSpell("Mortal Strike", "target")
                return
            end

            if Xeon.library.util:IsSpellReady("Heroic Strike") and Xeon.library.util:UnitMP("player") >= 70 then
                Xeon.library.combat:StanceCast("Heroic Strike", "target")
                return
            end
            if Xeon.library.util:IsSpellReady("Sunder Armor") and Xeon.library.util:UnitMP("player") >= 15 then
                Xeon.library.combat:StanceCast("Sunder Armor", "target")
                return
            end
        end
    else
        -- target is not in the melee distance
        self:COMMON_RANGE()
    end
end

function Xeon.class.warrior:TANK_AOE()
    local _T = GetTime()
    local cd_global = _T - Xeon.library.player.values.globalcooldownTime >= 1.5 and true or false
    local cd_item = true
    local cd_noggen = _T > Xeon.library.player.values.noggenTime and true or false
    local notActive = Xeon.library.player.values.isActivity and false or true

    local _, _, isBattle = GetShapeshiftFormInfo(1)
    local _, _, isDefensive = GetShapeshiftFormInfo(2)
    local _, _, isBerserker = GetShapeshiftFormInfo(3)
    if isBattle then
        self.values.stance = "Battle Stance"
    elseif isDefensive then
        self.values.stance = "Defensive Stance"
    elseif isBerserker then
        self.values.stance = "Berserker Stance"
    end

    local isMeleeRange
    -- dps part
    if not UnitIsDeadOrGhost("player") then
        -- use Noggen and Rum
        if cd_noggen then
        --    Xeon.library.item:UseNoggen()
        end

        Xeon.library.player.values.target = UnitName("target")
        if not Xeon.library.player.values.target then
            TargetNearestEnemy()
            return
        end
        isMeleeRange = CheckInteractDistance("target", 3)
        local targetIsEnemy = (Xeon.library.player.values.target and UnitIsEnemy("player", "target")) and true or false

        local isTargetMe = UnitIsUnit("targettarget", "player")

        -- self dispell
        self:COMMON_SELF_DISPELL()

        -- survive
        self:COMMON_SURVIVE()

        -- self buff
        self:COMMON_SELF_BUFF()

        -- dps

        if isMeleeRange then
            -- normal
            ---- ATTACK!!!
            Xeon.library.util:Attack()
            -- taunt
            if not isTargetMe and UnitAffectingCombat("target") and not Xeon.library.util:IsEnemyPlayer("target") then
                self:COMMON_TANK_TAUNT()
            end

            if not isTargetMe then
                self:TANK()
            else
                -- AOE tanking
                self:EQ_SH2()
                self:COMMON_USE_TRINKET()
                if Xeon.library.util:IsSpellReady("Berserker Rage") then
                    if not Xeon.library.util:IsEnemyPlayer("target") then
                        Xeon.library.combat:StanceCast("Berserker Rage", "player", "NONE_TARGET")
                        return
                    end
                end

                if
                    self.values.stance == "Battle Stance" and Xeon.library.util:IsLearned("Sweeping Strikes") and Xeon.library.util:IsSpellReady("Sweeping Strikes") and
                        Xeon.library.util:IsSpellReady("Bloodrage") and
                        Xeon.library.util:UnitMP("player") < 30
                 then
                    Xeon.library.combat:CastSpell("Bloodrage", "player", "NONE_TARGET")
                    return
                end

                if Xeon.library.util:IsLearned("Sweeping Strikes") and Xeon.library.util:IsSpellReady("Sweeping Strikes") then
                    Xeon.library.combat:StanceCast("Sweeping Strikes", "player", "NONE_TARGET")
                    return
                end

                -- change stance to defensive
                if self.values.stance ~= "Defensive Stance" and Xeon.library.util:IsSpellReady("Defensive Stance") then
                    Xeon.library.combat:CastSpell("Defensive Stance", "player", "NONE_TARGET")
                    return
                end
                if Xeon.library.buff:IsBuffed("Sweeping Strikes", "player") then
                    if Xeon.library.util:IsSpellReady("Revenge") and GetTime() - self.values.revengeTime <= 4 and Xeon.library.util:UnitMP("player") >= 5 then
                        Xeon.library.combat:StanceCast("Revenge", "target")
                        return
                    end
                    if Xeon.library.util:IsLearned("Bloodthirst") and Xeon.library.util:IsSpellReady("Bloodthirst") and Xeon.library.util:UnitMP("player") >= 30 then
                        Xeon.library.combat:CastSpell("Bloodthirst", "target")
                        return
                    end

                    if Xeon.library.util:IsLearned("Mortal Strike") and Xeon.library.util:IsSpellReady("Mortal Strike") and Xeon.library.util:UnitMP("player") >= 30 then
                        Xeon.library.combat:CastSpell("Mortal Strike", "target")
                        return
                    end

                    if Xeon.library.util:IsSpellReady("Heroic Strike") and Xeon.library.util:UnitMP("player") >= 42 then
                        Xeon.library.combat:StanceCast("Heroic Strike", "target")
                        return
                    end
                else
                    if Xeon.library.util:IsSpellReady("Bloodrage") and Xeon.library.util:UnitMP("player") <= 10 then
                        if not Xeon.library.util:IsEnemyPlayer("target") then
                            Xeon.library.combat:CastSpell("Bloodrage", "player", "NONE_TARGET")
                            return
                        end
                    end
                    if Xeon.library.util:IsSpellReady("Demoralizing Shout") and Xeon.library.util:UnitMP("player") >= 10 then
                        if not Xeon.library.buff:IsDebuffed("Demoralizing Shout", "target") then
                            Xeon.library.combat:StanceCast("Demoralizing Shout", "player", "NONE_TARGET")
                            return
                        end
                    end
                    if Xeon.library.util:IsSpellReady("Shield Block") and Xeon.library.util:UnitMP("player") >= 10 and Xeon.library.util:UnitHP("player") <= 50 then
                        Xeon.library.combat:StanceCast("Shield Block", "player", "NONE_TARGET")
                        return
                    end

                    --[[  if Xeon.library.util:IsSpellReady("Thunder Clap") and Xeon.library.util:UnitMP("player") >= 20 then
                        if not Xeon.library.buff:IsDebuffed("Thunder Clap", "target") then
                            Xeon.library.combat:StanceCast("Thunder Clap", "player", "NONE_TARGET")
                            return
                        end
                    end ]]
                    if Xeon.library.util:IsSpellReady("Cleave") and Xeon.library.util:UnitMP("player") >= 50 then
                        Xeon.library.combat:StanceCast("Cleave", "target")
                        return
                    end

                    if self:GetNearbyGroupMembersCount() >= 2 and Xeon.library.util:UnitMP("player") >= 10 then
                        if Xeon.library.util:IsSpellReady("Battle Shout") then
                            Xeon.library.combat:CastSpell("Battle Shout", "player", "NONE_TARGET")
                            return
                        end
                    else
                        if Xeon.library.util:IsSpellReady("Demoralizing Shout") then
                            Xeon.library.combat:CastSpell("Demoralizing Shout", "player", "NONE_TARGET")
                            return
                        end
                    end
                end
            end
        end
    else
        -- target is not in the melee distance
        self:COMMON_RANGE()
    end
end

function Xeon.class.warrior:COMMON_USE_TRINKET()
    if Xeon.library.item:UseEquippedItem("Kiss of the Spider") then
        return
    end
end

function Xeon.class.warrior:COMMON_RANGE()
    if Xeon.library.util:IsSpellReady("Charge") and not UnitAffectingCombat("player") then
        Xeon.library.combat:StanceCast("Charge", "target")
        self.values.chargeTime = GetTime()
        return
    elseif Xeon.library.util:IsSpellReady("Intercept") and GetTime() - self.values.chargeTime >= 2 then
        if Xeon.library.util:UnitMP("player") >= 10 then
            Xeon.library.combat:StanceCast("Intercept", "target")
            return
        elseif Xeon.library.util:IsSpellReady("Bloodrage") and ((GetNumPartyMembers() >= 3 or GetNumRaidMembers() >= 3) or UnitIsPlayer("target")) then
            Xeon.library.combat:CastSpell("Bloodrage", "player", "NONE_TARGET")
            return
        end
    end
end

function Xeon.class.warrior:COMMON_TANK_TAUNT()
    if
        not (Xeon.library.buff:SerchDebuffDescription("stun", "target") or Xeon.library.buff:SerchBuffDescription("fear", "target") or Xeon.library.buff:SerchBuffDescription("terror", "target") or
            Xeon.library.buff:SerchBuffDescription("polymorph", "target"))
     then
        if Xeon.library.util:IsSpellReady("Taunt") then
            Xeon.library.combat:StanceCast("Taunt", "target")
            return
        elseif Xeon.library.util:IsSpellReady("Mocking Blow") then
            Xeon.library.combat:StanceCast("Mocking Blow", "target")
            return
        elseif Xeon.library.util:IsSpellReady("Challenging Shout") then
            Xeon.library.combat:StanceCast("Challenging Shout", "player", "NONE_TARGET")
            return
        end
    end
end

function Xeon.class.warrior:COMMON_SELF_DISPELL()
    if Xeon.library.buff.values.playerDebuff["FEAR"] then
        if Xeon.library.util:IsLearned("Will of the Forsaken") and Xeon.library.util:IsSpellReady("Will of the Forsaken") then
            Xeon.library.combat:CastSpell("Will of the Forsaken", "player", "NONE_TARGET")
            return
        else
            return
        end
    elseif Xeon.library.buff.values.playerDebuff["FLEE"] then
        if Xeon.library.util:IsLearned("Will of the Forsaken") and Xeon.library.util:IsSpellReady("Will of the Forsaken") then
            Xeon.library.combat:CastSpell("Will of the Forsaken", "player", "NONE_TARGET")
            return
        else
            return
        end
    elseif Xeon.library.buff.values.playerDebuff["CHARM"] then
        if Xeon.library.util:IsLearned("Will of the Forsaken") and Xeon.library.util:IsSpellReady("Will of the Forsaken") then
            Xeon.library.combat:CastSpell("Will of the Forsaken", "player", "NONE_TARGET")
            return
        else
            return
        end
    elseif Xeon.library.buff.values.playerDebuff["POLYMORPH"] then
        return
    elseif Xeon.library.buff.values.playerDebuff["SAP"] then
        return
    elseif Xeon.library.buff.values.playerDebuff["STUN"] and Xeon.library.buff.values.playerDebuff["STUN"] >= 2 then
        if Xeon.library.item:UseEquippedItem("Insignia") then
            return
        else
            return
        end
    elseif Xeon.library.buff.values.playerDebuff["BLIND"] then
        return
    elseif Xeon.library.buff.values.playerDebuff["HORR"] then
        if Xeon.library.util:IsLearned("Will of the Forsaken") and Xeon.library.util:IsSpellReady("Will of the Forsaken") then
            Xeon.library.combat:CastSpell("Will of the Forsaken", "player", "NONE_TARGET")
            return
        else
            return
        end
    elseif Xeon.library.buff.values.playerDebuff["FROZEN"] then
        if Xeon.library.item:UseEquippedItem("Insignia") then
            return
        else
            return
        end
    end
end

function Xeon.class.warrior:COMMON_SURVIVE()
    --[[ if UnitAffectingCombat("player") then
        if Xeon.library.util:UnitHP("player") <= 40 then
            if Xeon.library.item:UseBagItem("Healing Potion") or Xeon.library.item:UseBagItem("Healing Draught") or Xeon.library.item:UseBagItem("Healthstone") then
                return
            end
        elseif Xeon.library.util:UnitHP("player") <= 30 and Xeon.library.combat:isUnderAttack("MELEE") then
        end
    end ]]
end

function Xeon.class.warrior:COMMON_SELF_BUFF()
    if not Xeon.library.buff:IsBuffed("Battle Shout", "player") then
        if Xeon.library.util:UnitMP("player") >= 10 and Xeon.library.util:IsSpellReady("Battle Shout") then
            Xeon.library.combat:CastSpell("Battle Shout", "player", "NONE_TARGET")
            return
        end
    end
end

function Xeon.class.warrior:EQ_DPS()
    if not UnitAffectingCombat("player") then
        -- head
        Xeon.library.item:Equip(GetInventorySlotInfo("HeadSlot"), "Lionheart Helm")
        -- Nack
        Xeon.library.item:Equip(GetInventorySlotInfo("NeckSlot"), "Onyxia Tooth Pendant")
        -- Shoulder
        Xeon.library.item:Equip(GetInventorySlotInfo("ShoulderSlot"), "Conqueror's Spaulders")
        -- Back
        Xeon.library.item:Equip(GetInventorySlotInfo("BackSlot"), "Shroud of Dominion")
        -- Chest
        Xeon.library.item:Equip(GetInventorySlotInfo("ChestSlot"), "Plated Abomination Ribcage")
        -- Wrist
        Xeon.library.item:Equip(GetInventorySlotInfo("WristSlot"), "Wristguards of Vengeance")
        -- Hand
        Xeon.library.item:Equip(GetInventorySlotInfo("HandsSlot"), "Gauntlets of Annihilation")
        -- Waist
        Xeon.library.item:Equip(GetInventorySlotInfo("WaistSlot"), "Onslaught Girdle")
        -- legs
        Xeon.library.item:Equip(GetInventorySlotInfo("LegsSlot"), "Titanic Leggings")
        -- Feet
        Xeon.library.item:Equip(GetInventorySlotInfo("FeetSlot"), "Chromatic Boots")
        -- ring1
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger0Slot"), "Band of Unnatural Forces")
        -- ring2
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger1Slot"), "Master Dragonslayer's Ring")
        -- Trinket1
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket0Slot"), "Kiss of the Spider")
        -- Trinket2
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket1Slot"), "Drake Fang Talisman")
        -- RangedSlot
        Xeon.library.item:Equip(GetInventorySlotInfo("RangedSlot"), "Striker's Mark")
    end
end

function Xeon.class.warrior:EQ_NORMAL()
    if not UnitAffectingCombat("player") then
        -- head
        Xeon.library.item:Equip(GetInventorySlotInfo("HeadSlot"), "Lionheart Helm")
        -- Nack
        Xeon.library.item:Equip(GetInventorySlotInfo("NeckSlot"), "Stormrage's Talisman of Seething")
        -- Shoulder
        Xeon.library.item:Equip(GetInventorySlotInfo("ShoulderSlot"), "Champion's Plate Shoulders")
        -- Back
        Xeon.library.item:Equip(GetInventorySlotInfo("BackSlot"), "Shroud of Dominion")
        -- Chest
        Xeon.library.item:Equip(GetInventorySlotInfo("ChestSlot"), "Ghoul Skin Tunic")
        -- Wrist
        Xeon.library.item:Equip(GetInventorySlotInfo("WristSlot"), "Wristguards of Vengeance")
        -- Hand
        Xeon.library.item:Equip(GetInventorySlotInfo("HandsSlot"), "Gauntlets of Annihilation")
        -- Waist
        Xeon.library.item:Equip(GetInventorySlotInfo("WaistSlot"), "Girdle of the Mentor")
        -- legs
        Xeon.library.item:Equip(GetInventorySlotInfo("LegsSlot"), "Leggings of Apocalypse")
        -- Feet
        Xeon.library.item:Equip(GetInventorySlotInfo("FeetSlot"), "Chromatic Boots")
        -- ring1
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger0Slot"), "Band of Unnatural Forces")
        -- ring2
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger1Slot"), "Ring of the Qiraji Fury")
        -- Trinket1
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket0Slot"), "Blackhand's Breadth")
        -- Trinket2
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket1Slot"), "Drake Fang Talisman")
        -- RangedSlot
        Xeon.library.item:Equip(GetInventorySlotInfo("RangedSlot"), "Nerubian Slavemaker")
    end
end

function Xeon.class.warrior:EQ_TANK()
    if not UnitAffectingCombat("player") then
        -- head
        Xeon.library.item:Equip(GetInventorySlotInfo("HeadSlot"), "Dreadnaught Helmet")
        -- Nack
        Xeon.library.item:Equip(GetInventorySlotInfo("NeckSlot"), "Mark of C'Thun")
        -- Shoulder
        Xeon.library.item:Equip(GetInventorySlotInfo("ShoulderSlot"), "Dreadnaught Pauldrons")
        -- Back
        Xeon.library.item:Equip(GetInventorySlotInfo("BackSlot"), "Cryptfiend Silk Cloak")
        -- Chest
        Xeon.library.item:Equip(GetInventorySlotInfo("ChestSlot"), "Dreadnaught Breastplate")
        -- Wrist
        Xeon.library.item:Equip(GetInventorySlotInfo("WristSlot"), "Dreadnaught Bracers")
        -- Hand
        Xeon.library.item:Equip(GetInventorySlotInfo("HandsSlot"), "Dreadnaught Gauntlets")
        -- Waist
        Xeon.library.item:Equip(GetInventorySlotInfo("WaistSlot"), "Dreadnaught Waistguard")
        -- legs
        Xeon.library.item:Equip(GetInventorySlotInfo("LegsSlot"), "Dreadnaught Legplates")
        -- Feet
        Xeon.library.item:Equip(GetInventorySlotInfo("FeetSlot"), "Dreadnaught Sabatons")
        -- ring1
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger0Slot"), "Ring of the Dreadnaught")
        -- ring2
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger1Slot"), "Ring of Emperor Vek'lor")
        -- Trinket1
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket0Slot"), "Styleen's Impeding Scarab")
        -- Trinket2
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket1Slot"), "Drake Fang Talisman")
        -- ranged
        Xeon.library.item:Equip(GetInventorySlotInfo("RangedSlot"), "Striker's Mark")
    end
end

function Xeon.class.warrior:EQ_TANK_DPS()
    if not UnitAffectingCombat("player") then
        -- head
        Xeon.library.item:Equip(GetInventorySlotInfo("HeadSlot"), "Dreadnaught Helmet")
        -- Nack
        Xeon.library.item:Equip(GetInventorySlotInfo("NeckSlot"), "Stormrage's Talisman of Seething")
        -- Shoulder
        Xeon.library.item:Equip(GetInventorySlotInfo("ShoulderSlot"), "Dreadnaught Pauldrons")
        -- Back
        Xeon.library.item:Equip(GetInventorySlotInfo("BackSlot"), "Cryptfiend Silk Cloak")
        -- Chest
        Xeon.library.item:Equip(GetInventorySlotInfo("ChestSlot"), "Dreadnaught Breastplate")
        -- Wrist
        Xeon.library.item:Equip(GetInventorySlotInfo("WristSlot"), "Dreadnaught Bracers")
        -- Hand
        Xeon.library.item:Equip(GetInventorySlotInfo("HandsSlot"), "Dreadnaught Gauntlets")
        -- Waist
        Xeon.library.item:Equip(GetInventorySlotInfo("WaistSlot"), "Dreadnaught Waistguard")
        -- legs
        Xeon.library.item:Equip(GetInventorySlotInfo("LegsSlot"), "Dreadnaught Legplates")
        -- Feet
        Xeon.library.item:Equip(GetInventorySlotInfo("FeetSlot"), "Dreadnaught Sabatons")
        -- ring1
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger0Slot"), "Ring of the Dreadnaught")
        -- ring2
        Xeon.library.item:Equip(GetInventorySlotInfo("Finger1Slot"), "Ring of the Qiraji Fury")
        -- Trinket1
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket0Slot"), "Styleen's Impeding Scarab")
        -- Trinket2
        Xeon.library.item:Equip(GetInventorySlotInfo("Trinket1Slot"), "Drake Fang Talisman")
        -- ranged
        Xeon.library.item:Equip(GetInventorySlotInfo("RangedSlot"), "Nerubian Slavemaker")
    end
end

function Xeon.class.warrior:EQ_2H()
    Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Might of Menethil")
    --  Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Severance")
    -- Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Ravager")
end

function Xeon.class.warrior:EQ_DW()
    if Xeon.library.item:IsEquiped(16, "The Hungering Cold") then
        Xeon.library.item:Equip(GetInventorySlotInfo("SecondaryHandSlot"), "Gressil, Dawn of Ruin")
        PickupInventoryItem(16)
        EquipCursorItem(17)
    else
        Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "Gressil, Dawn of Ruin")
        Xeon.library.item:Equip(GetInventorySlotInfo("SecondaryHandSlot"), "The Hungering Cold")
    end
end

function Xeon.class.warrior:EQ_SH()
    if Xeon.library.item:IsEquiped(17, "The Hungering Cold") then
        PickupInventoryItem(17)
        EquipCursorItem(16)
        Xeon.library.item:Equip(GetInventorySlotInfo("SecondaryHandSlot"), "The Face of Death")
    else
        Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "The Hungering Cold")
        Xeon.library.item:Equip(GetInventorySlotInfo("SecondaryHandSlot"), "The Face of Death")
    end
end

function Xeon.class.warrior:EQ_SH2()
    if Xeon.library.item:IsEquiped(17, "The Hungering Cold") then
        PickupInventoryItem(17)
        EquipCursorItem(16)
        Xeon.library.item:Equip(GetInventorySlotInfo("SecondaryHandSlot"), "Force Reactive Disk")
    else
        Xeon.library.item:Equip(GetInventorySlotInfo("MainHandSlot"), "The Hungering Cold")
        Xeon.library.item:Equip(GetInventorySlotInfo("SecondaryHandSlot"), "Force Reactive Disk")
    end
end

function Xeon.class.warrior:EQ_Weapon()
    if Xeon.library.util:IsLearned("Bloodthirst") then
        --    self:EQ_DW()
        self:EQ_2H()
        return
    elseif Xeon.library.util:IsLearned("Mortal Strike") then
        self:EQ_2H()
        return
    else
        _print("[Xeon]: Check default weapon set by your talent !!")
        return
    end
end
