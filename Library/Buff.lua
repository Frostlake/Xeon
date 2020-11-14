Xeon.library.buff = CreateFrame("Frame", nil, UIParent)
Xeon.library.buff:RegisterEvent("ADDON_LOADED")

Xeon.library.buff:SetScript(
    "OnEvent",
    function(...)
        if event == "ADDON_LOADED" then
            this:UnregisterEvent("ADDON_LOADED")

            -- Register Events
            this:RegisterEvent("PLAYER_AURAS_CHANGED")
            return
        elseif event == "PLAYER_AURAS_CHANGED" then
            local num = 0
            this.values.playerDebuff = {}
            this.values.isLostControl = false
            while GetPlayerBuff(num) >= 0 do
                local idx, _ = GetPlayerBuff(num, "HARMFUL")
                if (idx >= 0) and (idx < 24) then
                    local tooltip = xeon_scan
                    tooltip:SetOwner(tooltip, "ANCHOR_NONE")
                    tooltip:ClearLines()
                    tooltip:SetPlayerBuff(idx)
                    local textLeft1 = getglobal("xeon_scanTextLeft1")
                    local textLeft2 = getglobal("xeon_scanTextLeft2")
                    local _T = GetTime()
                    if (textLeft2) then
                        local desc = textLeft2:GetText()
                        if (desc ~= nil) then
                            if _sFind(desc, "fear") and not _sFind(desc, "warded") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["FEAR"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "flee") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["FLEE"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "charm") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["CHARM"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "Cannot attack or cast spells") and _sFind(desc, "Increased regeneration") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["POLYMORPH"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "incapacitated") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["SAP"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "stun") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["STUN"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "disoriented") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["BLIND"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "horrified.") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["HORR"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "frozen") and not _sFind(desc, "in place.") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["FROZEN"] = _T + GetPlayerBuffTimeLeft(idx)
                                this.values.isLostControl = true
                            elseif _sFind(desc, "silence") and not _sFind(desc, "Immune") then
                                this.values.playerDebuff["SILENCE"] = _T + GetPlayerBuffTimeLeft(idx)
                            elseif _sFind(desc, "Speaking Demonic increasing casting time") then
                                this.values.playerDebuff["COT"] = _T + GetPlayerBuffTimeLeft(idx)
                            end
                        end
                    end
                end
                num = num + 1
            end
            if Xeon.cfg.item.noggenBuff_feather == 0 then
                this:CancleBuffByDescription("You feel light")
            end
            if Xeon.cfg.item.noggenBuff_small == 0 then
                this:CancleBuffByDescription("You feel smaller")
            end
            if Xeon.cfg.item.noggenBuff_breath == 0 then
                this:CancleBuffByDescription("You've stopped")
            end
            return
        end
    end
)

Xeon.library.buff.values = {
    playerDebuff = {},
    isLostControl = false
}

function Xeon.library.buff:IsBuffed(buff, unit)
    local tooltip = xeon_scan
    local textleft1 = getglobal(tooltip:GetName() .. "TextLeft1")

    tooltip:SetOwner(UIParent, "ANCHOR_NONE")
    tooltip:ClearLines()
    tooltip:SetTrackingSpell()
    local bName = textleft1:GetText()
    if bName and _sFind(bName, buff) then
        return bName, nil
    end

    for i = 1, 16 do
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:ClearLines()
        tooltip:SetUnitBuff(unit, i)
        bName = textleft1:GetText()
        if bName and _sFind(bName, buff) then
            return bName, i
        elseif bName == nil then
            break
        end
    end
end

function Xeon.library.buff:IsDebuffed(buff, unit)
    if not CheckInteractDistance(unit, 4) then
        return nil
    end
    local tooltip = xeon_scan
    local textleft1 = getglobal(tooltip:GetName() .. "TextLeft1")

    for i = 1, 16 do
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:ClearLines()
        tooltip:SetUnitDebuff(unit, i)
        bName = textleft1:GetText()
        if bName and _sFind(bName, buff) then
            return bName, i
        elseif bName == nil then
            break
        end
    end
    return nil
end

function Xeon.library.buff:SerchBuffDescription(txt, unit)
    local tooltip = xeon_scan
    local textleft2 = getglobal(tooltip:GetName() .. "TextLeft2")

    for i = 1, 16 do
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:ClearLines()
        tooltip:SetUnitBuff(unit, i)
        desc = textleft2:GetText()
        if desc and _sFind(desc, txt) then
            return desc, i
        elseif desc == nil then
            break
        end
    end
end

function Xeon.library.buff:SerchDebuffDescription(txt, unit)
    local tooltip = xeon_scan
    local textleft2 = getglobal(tooltip:GetName() .. "TextLeft2")

    for i = 1, 16 do
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:ClearLines()
        tooltip:SetUnitDebuff(unit, i)
        desc = textleft2:GetText()
        if desc and _sFind(desc, txt) then
            return desc, i
        elseif desc == nil then
            break
        end
    end
end

function Xeon.library.buff:SerchDispellAbleDebuff(unit)
    local uClass = UnitClass(unit)
    local inIns, insType = IsInInstance()
    local L = {}

    if Xeon.library.player.values.class == "Paladin" then
        -- common debuff
        if Xeon.library.util:IsSpellReady("Blessing of Freedom") then
            for k1, v1 in pairs(xeon_debuff_common["SLOW"]) do
                if self:IsDebuffed(k1, unit) then
                    for k2, v2 in pairs(xeon_debuff_common["SLOW"][k1][2]) do
                        if v2 == "all" or v2 == uClass or (v2 == "player" and UnitIsUnit(unit, "player")) then
                            L.unit = unit
                            L.dispellType = "SLOW"
                            L.priority = xeon_debuff_common["SLOW"][k1][1]
                            return L
                        end
                    end
                end
            end
        end

        for k1, v1 in pairs(xeon_debuff_common["MAGIC"]) do
            if self:IsDebuffed(k1, unit) then
                for k2, v2 in pairs(xeon_debuff_common["MAGIC"][k1][2]) do
                    if v2 == "all" or v2 == uClass or (v2 == "player" and UnitIsUnit(unit, "player")) then
                        L.unit = unit
                        L.dispellType = "MAGIC"
                        L.priority = xeon_debuff_common["MAGIC"][k1][1]
                        return L
                    end
                end
            end
        end

        for k1, v1 in pairs(xeon_debuff_common["POISON"]) do
            if self:IsDebuffed(k1, unit) then
                for k2, v2 in pairs(xeon_debuff_common["POISON"][k1][2]) do
                    if v2 == "all" or v2 == uClass or (v2 == "player" and UnitIsUnit(unit, "player")) then
                        L.unit = unit
                        L.dispellType = "POISON"
                        L.priority = xeon_debuff_common["POISON"][k1][1]
                        return L
                    end
                end
            end
        end

        if Xeon.library.util:IsSpellReady("Blessing of Protection") and Xeon.library.util:IsUnitMyGroup(unit) and not self:IsDebuffed("Forbearance", unit) then
            for k1, v1 in pairs(xeon_debuff_common["ETC"]) do
                if self:IsDebuffed(k1, unit) then
                    for k2, v2 in pairs(xeon_debuff_common["ETC"][k1][2]) do
                        if v2 == "all" or v2 == uClass or (v2 == "player" and UnitIsUnit(unit, "player")) then
                            L.unit = unit
                            L.dispellType = "ETC"
                            L.priority = xeon_debuff_common["ETC"][k1][1]
                            return L
                        end
                    end
                end
            end
        end

        -- pve debuff
        if inIns and (insType == "party" or insType == "raid") then
            for k1, v1 in pairs(xeon_debuff_pve) do
                if k1 == Xeon.library.player.values.zone then
                    for k2, v2 in pairs(xeon_debuff_pve[k1]["MAGIC"]) do
                        if self:IsDebuffed(k2, unit) then
                            for k3, v3 in pairs(xeon_debuff_pve[k1]["MAGIC"][k2][2]) do
                                if v3 == "all" or v3 == uClass or (v3 == "player" and UnitIsUnit(unit, "player")) then
                                    L.unit = unit
                                    L.dispellType = "MAGIC"
                                    L.priority = xeon_debuff_pve[k1]["MAGIC"][k2][k3]
                                    return L
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif Xeon.library.player.values.class == "Shaman" then
        -- common debuff

        for k1, v1 in pairs(xeon_debuff_common["POISON"]) do
            if self:IsDebuffed(k1, unit) then
                for k2, v2 in pairs(xeon_debuff_common["POISON"][k1][2]) do
                    if v2 == "all" or v2 == uClass or (v2 == "player" and UnitIsUnit(unit, "player")) then
                        L.unit = unit
                        L.dispellType = "POISON"
                        L.priority = xeon_debuff_common["POISON"][k1][1]
                        return L
                    end
                end
            end
        end

        -- pve debuff
        if inIns and (insType == "party" or insType == "raid") then
            for k1, v1 in pairs(xeon_debuff_pve) do
                if k1 == Xeon.library.player.values.zone then
                    for k2, v2 in pairs(xeon_debuff_pve[k1]["POISON"]) do
                        if self:IsDebuffed(k2, unit) then
                            for k3, v3 in pairs(xeon_debuff_pve[k1]["POISON"][k2][2]) do
                                if v3 == "all" or v3 == uClass or (v3 == "player" and UnitIsUnit(unit, "player")) then
                                    L.unit = unit
                                    L.dispellType = "POISON"
                                    L.priority = xeon_debuff_pve[k1]["POISON"][k2][k3]
                                    return L
                                end
                            end
                        end
                    end
                end
            end
        end
    elseif Xeon.library.player.values.class == "Druid" then
    end

    return nil
end

function Xeon.library.buff:SerchBuffTarget(unit)
    if not CheckInteractDistance(unit, 4) then
        return nil
    end
    local L = {}
    if Xeon.library.player.values.class == "Paladin" then
        if UnitIsUnit("player", unit) then
            return nil
        end
        if not self:IsBuffed("Strength of Earth", unit) and not self:IsBuffed("Grace of Air", unit) and not self:IsBuffed("Windfury Totem", unit) and not self:IsBuffed("Stoneskin", unit) then
            if
                not self:IsBuffed("Blessing of Kings", unit) and not self:IsBuffed("Blessing of Sacrifice", unit) and not self:IsBuffed("Blessing of Freedom", unit) and
                    not self:IsBuffed("Blessing of Protection", unit)
             then
                L.unit = unit
                L.buff = "Blessing of Kings"
            end
        end
        if Xeon.library.util:IsEnemyPlayer(unit .. "target") then
            if not self:IsBuffed("Blessing of Sacrifice", unit) and not self:IsBuffed("Blessing of Freedom", unit) and not self:IsBuffed("Blessing of Protection", unit) then
                table.insert(Xeon.class.paladin.values.secrificeList, unit)
            end
            if not (Xeon.library.enemy:IsEnemyBuffed("Divine Shield", UnitName(unit .. "target")) and Xeon.library.enemy:IsEnemyBuffed("Ice Block", UnitName(unit .. "target"))) then
                if Xeon.library.util:UnitHP(unit .. "target") <= 20 and CheckInteractDistance(unit .. "target", 4) then
                    table.insert(Xeon.class.paladin.values.hammerList, unit .. "target")
                elseif
                    CheckInteractDistance(unit .. "target", 3) and
                        ((Xeon.library.enemy:IsEnemyCasting(unit .. "target") and Xeon.library.util:UnitHP(unit) <= 70) or Xeon.library.util:UnitHP(unit) <= 50)
                 then
                    table.insert(Xeon.class.paladin.values.justiceList, unit .. "target")
                end
            end
        end
        if L.unit then
            return L
        else
            return nil
        end
    elseif Xeon.library.player.values.class == "Priest" then
    elseif Xeon.library.player.values.class == "Druid" then
    end

    return nil
end

function Xeon.library.buff:GetHealPowerBuffValue(unit)
    local tooltip = xeon_scan
    local textleft2 = getglobal(tooltip:GetName() .. "TextLeft2")
    local value = 0

    for i = 1, 16 do
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:ClearLines()
        tooltip:SetUnitBuff(unit, i)
        desc = textleft2:GetText()
        if desc then
            _, _, v = string.find(desc, "Healing done by magical spells is increased by up to (%d+).")
            if v then
                value = value + tonumber(v)
            end
            _, _, v = string.find(desc, "Increases damage and healing done by magical spells and effects by up to (%d+).")
            if v then
                value = value + tonumber(v)
            end
            _, _, v = string.find(desc, "Healing spells increased by up to (%d+).")
            if v then
                value = value + tonumber(v)
            end
        elseif desc == nil then
            break
        end
    end
    return value
end

function Xeon.library.buff:CancleBuffByDescription(txt)
    local tooltip = xeon_scan
    local textleft2 = getglobal(tooltip:GetName() .. "TextLeft2")
    local counter = 0
    while GetPlayerBuff(counter) >= 0 do
        local index, _ = GetPlayerBuff(counter)
        tooltip:SetOwner(UIParent, "ANCHOR_NONE")
        tooltip:ClearLines()
        tooltip:SetPlayerBuff(index)
        local desc = textleft2:GetText()
        if desc then
            if string.find(desc, txt) then
                CancelPlayerBuff(counter)
                return
            end
        end
        counter = counter + 1
    end
end

function Xeon.library.buff:Get_Paladin_Talent_Healing_Light()
    local _, _, _, _, rank = GetTalentInfo(1, 5)
    if rank == 1 then
        return 4
    elseif rank == 2 then
        return 8
    elseif rank == 3 then
        return 12
    end
    return 0
end

function Xeon.library.buff:IsWeaponEnchanted(buff, offHand)
    local slot = offHand and 17 or 16
    local hasItem = xeon_scan:SetInventoryItem("player", slot)
    if hasItem then        
        for line = 1, xeon_scan:NumLines() do
            local left = getglobal("xeon_scanTextLeft" .. line)
            if left:GetText() then
                if _sFind(left:GetText(), buff) then
                    return true
                end
            end
        end
        return false
    end
    return false
end
