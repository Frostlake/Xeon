Xeon.library.player = CreateFrame("Frame", nil, UIParent)
Xeon.library.player:RegisterEvent("ADDON_LOADED")

Xeon.library.player.values = {
    class = UnitClass("player"),
    zone = GetZoneText(),
    updateTime = GetTime(),
    isMoving = false,
    posX = 0,
    posY = 0,
    isActivity = false,
    activatedSpell = nil,
    activatedTargetName = nil,
    healInactive = false,
    healInactiveTime = GetTime(),
    isHealActivity = false,
    activatedHealSpell = nil,
    activatedHealTargetName = nil,
    isCasting = false,
    globalcooldownTime = GetTime(),
    stanceCooldownTime = GetTime(),
    noggenTime = GetTime(),
    target = nil,
    healingPower = 0,
    healingBuff = 0,
    spellPower = 0
}

Xeon.library.player:SetScript(
    "OnEvent",
    function(...)
        if event == "ADDON_LOADED" then
            this:UnregisterEvent("ADDON_LOADED")

            -- Register Events
            this:RegisterEvent("PLAYER_ENTERING_WORLD")
            this:RegisterEvent("UNIT_INVENTORY_CHANGED")
            this:RegisterEvent("CHARACTER_POINTS_CHANGED")
            this:RegisterEvent("PLAYER_AURAS_CHANGED")
            this:RegisterEvent("MINIMAP_ZONE_CHANGED")
            return
        elseif event == "PLAYER_ENTERING_WORLD" then
            this.values.healingPower = Xeon.library.item:GearHealPowerScan("player")
            this.values.healingBuff = Xeon.library.buff:GetHealPowerBuffValue("player")
            this.values.spellPower = Xeon.library.item:GearSpellPowerScan("player")
            return
        elseif event == "PLAYER_AURAS_CHANGED" then
            this.values.healingBuff = Xeon.library.buff:GetHealPowerBuffValue("player")
            return
        elseif event == "UNIT_INVENTORY_CHANGED" then
            this.values.healingPower = Xeon.library.item:GearHealPowerScan("player")
            this.values.spellPower = Xeon.library.item:GearSpellPowerScan("player")
            return
        elseif event == "MINIMAP_ZONE_CHANGED" then
            this.values.zone = GetZoneText()
            return
        end
    end
)

Xeon.library.player:SetScript(
    "OnUpdate",
    function(...)
        if GetTime() - this.values.updateTime >= 0.2 then
            this.values.updateTime = GetTime()

            -- update player map positon
            local posX, posY = GetPlayerMapPosition("player")           

            if this.values.posX == posX and this.values.posY == posY then
                this.values.isMoving = false
            else
                this.values.isMoving = true
            end
            this.values.posX = posX
            this.values.posY = posY

            if posX == 0 then
                SetMapToCurrentZone()
            end

            -- update delay for isHealActivity
            --[[ if this.values.healInactive == true then
                if GetTime() - this.values.healInactiveTime >= 5 then
                    this.values.isHealActivity = false
                    this.values.healInactive = false
                end
            end ]]
           -- _query(this.values.isHealActivity)
            return
        end
    end
)
