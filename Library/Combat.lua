Xeon.library.combat = CreateFrame("Frame", nil, UIParent)
Xeon.library.combat:RegisterEvent("ADDON_LOADED")

Xeon.library.combat:SetScript(
	"OnEvent",
	function(...)
		if event == "ADDON_LOADED" then
			this:UnregisterEvent("ADDON_LOADED")
			-- Register Events
			this:RegisterEvent("UI_ERROR_MESSAGE")
			this:RegisterEvent("SPELLCAST_START")
			this:RegisterEvent("SPELLCAST_STOP")
			this:RegisterEvent("SPELLCAST_FAILED")
			this:RegisterEvent("SPELLCAST_INTERRUPTED")
			this:RegisterEvent("CHAT_MSG_SPELL_FAILED_LOCALPLAYER")
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS")
			this:RegisterEvent("CHAT_MSG_SPELL_SELF_BUFF")
			this:RegisterEvent("CHAT_MSG_SPELL_SELF_DAMAGE")
			this:RegisterEvent("CHAT_MSG_COMBAT_SELF_HITS")
			this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF")
			this:RegisterEvent("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE")
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS")
			this:RegisterEvent("UNIT_AURASTATE")
			this:RegisterEvent("CHAT_MSG_SPELL_PARTY_BUFF")			
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS")
			this:RegisterEvent("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS")
			this:RegisterEvent("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE")
			this:RegisterEvent("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS")
			this:RegisterEvent("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS")
			return
		elseif event == "SPELLCAST_START" then
			Xeon.library.util:DebugMsg_combat("SPELLCAST_START : " .. arg1)
			Xeon.library.player.values.isCasting = true
			return
		elseif event == "SPELLCAST_STOP" then
			Xeon.library.util:DebugMsg_combat("SPELLCAST_STOP : " .. _txt(arg1))
			Xeon.library.player.values.isCasting = false
			return
		elseif event == "SPELLCAST_FAILED" then
			Xeon.library.util:DebugMsg_combat("SPELLCAST_FAILED : " .. _txt(arg1))
			Xeon.library.player.values.isCasting = false
			return
		elseif event == "SPELLCAST_INTERRUPTED" then
			Xeon.library.util:DebugMsg_combat("SPELLCAST_INTERRUPTED : " .. _txt(arg1))
			Xeon.library.player.values.isCasting = false
			return
		elseif event == "CHAT_MSG_SPELL_FAILED_LOCALPLAYER" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_FAILED_LOCALPLAYER : " .. arg1)
			if Xeon.library.player.values.isActivity == true and string.find(arg1, "You fail to cast " .. Xeon.library.player.values.activatedSpell) then
				Xeon.library.player.values.isActivity = false
				Xeon.library.player.values.globalcooldownTime = Xeon.library.player.values.globalcooldownTime - 1
			end
			if Xeon.library.player.values.isHealActivity == true and string.find(arg1, "You fail to cast " .. Xeon.library.player.values.activatedHealSpell) then
				Xeon.library.player.values.isHealActivity = false
			end
			return
		elseif event == "CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_PERIODIC_SELF_BUFFS : " .. arg1)
			if Xeon.library.player.values.isActivity == true and string.find(arg1, "You gain " .. Xeon.library.player.values.activatedSpell) then
				Xeon.library.player.values.isActivity = false
			end
			return
		elseif event == "CHAT_MSG_SPELL_SELF_BUFF" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_SELF_BUFF : " .. arg1)
			if Xeon.library.player.values.isActivity == true and string.find(arg1, "Your " .. Xeon.library.player.values.activatedSpell) then
				Xeon.library.player.values.isActivity = false
			elseif Xeon.library.player.values.isActivity == true and string.find(arg1, "You cast " .. Xeon.library.player.values.activatedSpell) then
				Xeon.library.player.values.isActivity = false
			end
			if Xeon.library.player.values.isHealActivity == true and string.find(arg1, "Your " .. Xeon.library.player.values.activatedHealSpell) then
				Xeon.library.player.values.isHealActivity = false
				--Xeon.library.player.values.healInactive = true				
				Xeon.library.player.values.healInactiveTime = GetTime() 
			end
			return
		elseif event == "CHAT_MSG_SPELL_SELF_DAMAGE" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_SELF_DAMAGE : " .. arg1)
		elseif event == "CHAT_MSG_COMBAT_SELF_HITS" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_COMBAT_SELF_HITS : " .. arg1)
			return
		elseif event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_FRIENDLYPLAYER_BUFF : " .. arg1)
			return
		elseif event == "CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_FRIENDLYPLAYER_DAMAGE : " .. arg1)
			return
		elseif event == "CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_PERIODIC_FRIENDLYPLAYER_BUFFS : " .. arg1)
			return
		elseif event == "UNIT_AURASTATE" then
			Xeon.library.util:DebugMsg_combat("UNIT_AURASTATE : " .. arg1)
			return
		elseif event == "CHAT_MSG_SPELL_PARTY_BUFF" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_PARTY_BUFF : " .. arg1)
			return
		elseif event == "CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_PERIODIC_CREATURE_BUFFS : " .. arg1)
			if Xeon.library.player.values.isActivity == true and string.find(arg1, Xeon.library.player.values.activatedTargetName .. " gains " .. Xeon.library.player.values.activatedSpell) then
				Xeon.library.player.values.isActivity = false
			end
			return
		elseif event == "CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_PERIODIC_PARTY_BUFFS : " .. arg1)
			if Xeon.library.player.values.isActivity == true and string.find(arg1, Xeon.library.player.values.activatedTargetName .. " gains " .. Xeon.library.player.values.activatedSpell) then
				Xeon.library.player.values.isActivity = false
			end
			return
		elseif event == "CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_SPELL_HOSTILEPLAYER_DAMAGE : " .. arg1)
			for name, spell in string.gfind(arg1, "(.+) 's (.+) you for") do
				this.values.underAttack_pvp_caster.name = name
				this.values.underAttack_pvp_caster.spell = spell
				this.values.underAttack_pvp_caster.timeInfo = GetTime()
			end
			for name, spell in string.gfind(arg1, "(.+) begins to cast (.+).") do
				this.values.underAttack_pvp_caster.name = name
				this.values.underAttack_pvp_caster.spell = spell
				this.values.underAttack_pvp_caster.timeInfo = GetTime()
				---
			end

			return
		elseif event == "CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_COMBAT_HOSTILEPLAYER_HITS : " .. arg1)
			for name, _ in string.gfind(arg1, "(.+) (.+) you for") do
				this.values.underAttack_pvp_melee.name = name
				this.values.underAttack_pvp_melee.timeInfo = GetTime()
			end
			return
		elseif event == "CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS" then
			Xeon.library.util:DebugMsg_combat("CHAT_MSG_COMBAT_CREATURE_VS_SELF_HITS : " .. arg1)
			for name in string.gfind(arg1, "[^%s]+") do
				this.values.underAttack_pve_melee.name = name
				this.values.underAttack_pve_melee.timeInfo = GetTime()
			end
			return
		end
	end
)

Xeon.library.combat:SetScript(
	"OnUpdate",
	function(...)
		if GetTime() - this.values.updateTime >= 0.2 then
			this.values.updateTime = GetTime()

		-- rotation

		-- CastSpellByName("Devotion Aura")  86
		-- Xeon.library.util:ChatCommand("/run CastSpell(86, BOOKTYPE_SPELL)")
		-- UseAction(13)
		end
	end
)

Xeon.library.combat.values = {
	updateTime = GetTime(),
	underAttack_pvp_caster = {},
	underAttack_pvp_melee = {},
	underAttack_pve_melee = {},
	currentEnemyCastingRank = "D"
}

function Xeon.library.combat:isUnderAttack(flag)
	local _T = GetTime()
	if flag == "MELEE" then
		if self.values.underAttack_pvp_melee.timeInfo and _T - self.values.underAttack_pvp_melee.timeInfo <= 4 then
			return self.values.underAttack_pvp_melee.name
		elseif self.values.underAttack_pve_melee.timeInfo and _T - self.values.underAttack_pve_melee.timeInfo <= 4 then
			return self.values.underAttack_pve_melee.name
		end
	elseif flag == "CASTER" then
		if self.values.underAttack_pvp_caster.timeInfo and _T - self.values.underAttack_pvp_caster.timeInfo <= 4 then
			return self.values.underAttack_pvp_caster.name
		end
	end
	return false
end

function Xeon.library.combat:CastHeal(unit, spell, loss, rank)
	local maxRank = Xeon.library.util:GetMaxSpellRank(spell)
	if Xeon.cfg.heal.groupHealingMode == 1 then
		-- let it be for mana saving :P
	elseif Xeon.cfg.heal.groupHealingMode == 2 then
		loss = loss + ((loss * ((100 - Xeon.library.util:UnitHP(unit)) * 0.01)) * 0.5)
	elseif Xeon.cfg.heal.groupHealingMode == 3 then
		loss = loss + (loss * (Xeon.cfg.heal.groupHealingOverHealRate * 0.01))
	end
	if Xeon.library.buff:IsDebuffed("Mortal Strike", unit) then
		loss = loss * 2
	end

	local paladinRelic = 0
	local paladinBOL = 0
	if spell == "Flash of Light" and Xeon.library.item:IsEquiped(GetInventorySlotInfo("RangedSlot"), "Libram of Light") then
		paladinRelic = 83
	end
	if spell == "Flash of Light" and Xeon.library.buff:IsBuffed("Blessing of Light", unit) then
		paladinBOL = 115
	elseif spell == "Holy Light" and Xeon.library.buff:IsBuffed("Blessing of Light", unit) then
		paladinBOL = 400
	end
	for i = 1, maxRank do
		local healAmount = Xeon.library.heal:GetHealAmount(spell, i) + paladinRelic + paladinBOL

		if healAmount > loss or i == maxRank then
			if i ~= 1 and healAmount > loss then
				i = i - 1
			end
			if rank then
				i = rank
			end
			Xeon.library.heal.values.healCurrentAmount = Xeon.library.heal:GetHealAmount(spell, i) + paladinRelic + paladinBOL
			if UnitName(unit) == Xeon.library.player.values.target then
				self:UpdateHealActivity(spell, unit)
				self:UpdateActivity(spell, unit)
				CastSpellByName(spell .. "(Rank " .. i .. ")", 0)
				return
			elseif UnitIsUnit(unit, "player") then
				self:UpdateHealActivity(spell, unit)
				self:UpdateActivity(spell, unit)
				CastSpellByName(spell .. "(Rank " .. i .. ")", 1)
				return
			else
				self:UpdateHealActivity(spell, unit)
				self:UpdateActivity(spell, unit)
				TargetUnit(unit)

				if not Xeon.library.heal:HealRangeCheck("40Y") then
					Xeon.library.heal.values.bannedTime = GetTime()
					Xeon.library.heal.values.bannedList[Xeon.library.player.values.activatedTargetName] = Xeon.library.heal.values.bannedTime + 3					
					self:CancelHealActivity()
					self:CancelActivity()
					TargetLastTarget()
					return
				end
				CastSpellByName(spell .. "(Rank " .. i .. ")", 0)
				TargetLastTarget()
				return
			end
		end
	end
end

function Xeon.library.combat:CastSpell(spell, unit, flag)
	if flag == "NONE_TARGET" then
		self:UpdateActivity(spell, unit)
		CastSpellByName(spell, 1)
		return
	elseif UnitName(unit) == Xeon.library.player.values.target then
		self:UpdateActivity(spell, unit)
		CastSpellByName(spell, 0)
		return
	elseif UnitIsUnit(unit, "player") then
		self:UpdateActivity(spell, unit)
		CastSpellByName(spell, 1)
		return
	else
		self:UpdateActivity(spell, unit)
		TargetUnit(unit)
		if not Xeon.library.heal:HealRangeCheck("30Y") then
			Xeon.library.heal.values.bannedTime = GetTime()
			Xeon.library.heal.values.bannedList[Xeon.library.player.values.activatedTargetName] = Xeon.library.heal.values.bannedTime + 3
			self:CancelActivity()
			TargetLastTarget()
			return
		end
		CastSpellByName(spell, 0)
		TargetLastTarget()
		return
	end
end

function Xeon.library.combat:StanceCast(spell, unit, flag)
	if xeon_stance_date[Xeon.library.player.values.class][spell] then
		for k, v in pairs(xeon_stance_date[Xeon.library.player.values.class][spell]) do
			if Xeon.class.warrior.values.stance == v then
				self:CastSpell(spell, unit, flag)
				return
			end
		end
		--if GetTime() - Xeon.library.player.values.stanceCooldownTime >= 1.5

		if Xeon.library.util:IsSpellReady(xeon_stance_date[Xeon.library.player.values.class][spell][1]) then
			self:CastSpell(xeon_stance_date[Xeon.library.player.values.class][spell][1], unit, "NONE_TARGET")
			return
		else
			return
		end
	else
		--_print("[Zeon]: Can't find spell info in the spell data table !!")
		self:CastSpell(spell, unit, flag)
	end
end

function Xeon.library.combat:UpdateActivity(spell, unit)
	Xeon.library.player.values.isActivity = true
	Xeon.library.player.values.activatedSpell = spell
	Xeon.library.player.values.activatedTargetName = UnitName(unit)
	if _sFind(spell, "stance") then
		Xeon.library.player.values.stanceCooldownTime = GetTime()
	else
		Xeon.library.player.values.globalcooldownTime = GetTime()
	end
	--	_print("Active : " .. spell .. " - " .. UnitName(unit))
end

function Xeon.library.combat:CancelActivity(spell, unit)
	Xeon.library.player.values.isActivity = false
	Xeon.library.player.values.activatedSpell = nil
	Xeon.library.player.values.activatedTargetName = nil
	Xeon.library.player.values.globalcooldownTime = GetTime()
	Xeon.library.player.values.stanceCooldownTime = GetTime()
end

function Xeon.library.combat:UpdateHealActivity(spell, unit)
	Xeon.library.player.values.isHealActivity = true
	Xeon.library.player.values.activatedHealSpell = spell
	Xeon.library.player.values.activatedHealTargetName = UnitName(unit)
end

function Xeon.library.combat:CancelHealActivity(spell, unit)
	Xeon.library.player.values.isHealActivity = false
	Xeon.library.player.values.activatedHealSpell = nil
	Xeon.library.player.values.activatedHealTargetName = nil
end
