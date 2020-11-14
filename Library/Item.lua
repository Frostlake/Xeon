Xeon.library.item = CreateFrame("Frame", nil, UIParent)
Xeon.library.item:RegisterEvent("ADDON_LOADED")

Xeon.library.item:SetScript(
	"OnEvent",
	function(...)
		if event == "ADDON_LOADED" then
			this:UnregisterEvent("ADDON_LOADED")
			-- Register Events
			--this:RegisterEvent("BAG_UPDATE_COOLDOWN")
			return
		elseif event == "BAG_UPDATE_COOLDOWN" then
			--_print("BAG_UPDATE_COOLDOWN : ".._txt(arg1))
			return
		end
	end
)

Xeon.library.item:SetScript(
	"OnUpdate",
	function(...)
		if GetTime() - this.values.updateTime >= 1 then
			this.values.updateTime = GetTime()

			--	 this:TrinketSwap()
			return
		end
	end
)

Xeon.library.item.values = {
	updateTime = GetTime()
}

function Xeon.library.item:TrinketSwap(slot, flag)
	-- ## slots ##
	-- 13, 14

	-- ## flags ##
	-- Survive
	-- Healing
	-- Melee_DPS
	-- Caster_DPS

	local function _MakeTrinketList(flag)
		local L = {}
		local bagslots = nil
		local iName = nil
		local cool = 0
		for bag = 0, NUM_BAG_FRAMES do
			bagslots = GetContainerNumSlots(bag)
			if bagslots and bagslots > 0 then
				for slot = 1, bagslots do
					link = GetContainerItemLink(bag, slot)
					if link and GetContainerItemCooldown(bag, slot) == 0 then
						local _, _, name = string.find(link, "^.*%[(.*)%].*$")
						if xeon_trinket_swap_list[Xeon.library.player.values.class][flag][name] then
							L[name] = xeon_trinket_swap_list[Xeon.library.player.values.class][flag][name].priority
						--_print("A : " .. name)
						end
					else
						local hasItem = xeon_scan:SetBagItem(bag, slot)
						if hasItem then
							for line = 1, xeon_scan:NumLines() do
								local left = getglobal("xeon_scanTextLeft" .. line)
								if left:GetText() then
									if line == 1 then
										iName = left:GetText()
									end
									if xeon_trinket_swap_list[Xeon.library.player.values.class][flag][iName] then
										if left:GetText() == "Cooldown remaining: 2 min" then
											--_print("nameXX : " .. iName)
											break
										end

										_, _, cd = string.find(left:GetText(), "Cooldown remaining: (%d+) sec")
										if cd then
											cool = tonumber(cd)
											if cool ~= 0 and cool < 30 then
												L[iName] = xeon_trinket_swap_list[Xeon.library.player.values.class][flag][iName].priority
											--	_print("B : " .. iName)
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		return L
	end

	if not UnitAffectingCombat("player") and not UnitIsDeadOrGhost("player") then
		local cool = 0
		local swap = false
		local info = {}
		local hasItem = xeon_scan:SetInventoryItem("player", slot)
		if hasItem then
			for line = 1, xeon_scan:NumLines() do
				local left = getglobal("xeon_scanTextLeft" .. line)
				if left:GetText() then
					if line == 1 then
						info.iName = left:GetText()

						info.isInSwapList = xeon_trinket_swap_list[Xeon.library.player.values.class][flag][info.iName] and true or false
						if info.isInSwapList then
							info.isPassive = xeon_trinket_swap_list[Xeon.library.player.values.class][flag][info.iName].passive and true or false
							info.delay = xeon_trinket_swap_list[Xeon.library.player.values.class][flag][info.iName].delay and true or false
							info.priority = xeon_trinket_swap_list[Xeon.library.player.values.class][flag][info.iName].priority
							info.buff = xeon_trinket_swap_list[Xeon.library.player.values.class][flag][info.iName].buff
						end
					end
					_, _, cd = string.find(left:GetText(), "Cooldown remaining: (%d+) min")
					if cd then
						cool = 60
					end
					_, _, cd = string.find(left:GetText(), "Cooldown remaining: (%d+) sec")
					if cd then
						cool = tonumber(cd)
					end
				end
			end
		else
			swap = true
		end

		if info.isInSwapList then
			if cool > 30 then
				if (not Xeon.library.buff:IsBuffed(info.buff, "player")) then
					swap = true
				elseif not info.delay then
					swap = true
				end
			end
		else
			swap = true
		end

		local L = _MakeTrinketList(flag)
		local _name
		local _priority = 99
		for k, v in pairs(L) do
			if v < _priority then
				_name = k
				_priority = v
			end
		end
		if _name then
			if swap then
				self:Equip(slot, _name)
			elseif info.isInSwapList and info.isPassive then
				if info.priority > _priority then
					self:Equip(slot, _name)
				end
			end
		end
	end
end

function Xeon.library.item:Equip(slotId, itemName)
	if self:IsEquiped(slotId, itemName) then
		return false
	else
		local link = nil
		local bagslots = nil
		for bag = 0, NUM_BAG_FRAMES do
			bagslots = GetContainerNumSlots(bag)
			if bagslots and bagslots > 0 then
				for slot = 1, bagslots do
					link = GetContainerItemLink(bag, slot)
					if link and string.find(link, itemName) then
						PickupContainerItem(bag, slot)
						EquipCursorItem(slotId)
						return true
					end
				end
			end
		end
	end
	return false
end

function Xeon.library.item:GearHealPowerScan(unit)
	local healPower = 0
	local healPower_Set_Bonus = {}
	local MAX_INVENTORY_SLOTS = 19
	for slot = 0, MAX_INVENTORY_SLOTS do
		local hasItem = xeon_scan:SetInventoryItem(unit, slot)
		if hasItem then
			local SET_NAME
			for line = 1, xeon_scan:NumLines() do
				local left = getglobal("xeon_scanTextLeft" .. line)
				if left:GetText() then
					local _, _, value = string.find(left:GetText(), "Equip: Increases healing done by spells and effects by up to (%d+).")
					if value then
						healPower = healPower + tonumber(value)
					end
					_, _, value = string.find(left:GetText(), "Healing Spells %+(%d+)")
					if value then
						healPower = healPower + tonumber(value)
					end
					_, _, value = string.find(left:GetText(), "^%+(%d+) Healing Spells")
					if value then
						healPower = healPower + tonumber(value)
					end
					_, _, value = string.find(left:GetText(), "(.+) %(%d/%d%)")
					if value then
						SET_NAME = value
					end
					_, _, value = string.find(left:GetText(), "^Set: Increases healing done by spells and effects by up to (%d+)%.")
					if value and SET_NAME and not tContains(healPower_Set_Bonus, SET_NAME) then
						tinsert(healPower_Set_Bonus, SET_NAME)
						healPower = healPower + tonumber(value)
					end
				end
			end
		end
	end
	return healPower
end

function Xeon.library.item:GearSpellPowerScan(unit)
	local spellPower = 0
	local MAX_INVENTORY_SLOTS = 19
	local SpellPower_Set_Bonus = {}
	for slot = 0, MAX_INVENTORY_SLOTS do
		local hasItem = xeon_scan:SetInventoryItem(unit, slot)
		if hasItem then
			local SET_NAME
			for line = 1, xeon_scan:NumLines() do
				local left = getglobal("xeon_scanTextLeft" .. line)
				if left:GetText() then
					local _, _, value = strfind(left:GetText(), "Equip: Increases damage and healing done by magical spells and effects by up to (%d+).")
					if value then
						spellPower = spellPower + tonumber(value)
					end
					_, _, value = strfind(left:GetText(), "Spell Damage %+(%d+)")
					if value then
						spellPower = spellPower + tonumber(value)
					end
					_, _, value = strfind(left:GetText(), "^%+(%d+) Spell Damage and Healing")
					if value then
						spellPower = spellPower + tonumber(value)
					end
					_, _, value = strfind(left:GetText(), "^%+(%d+) Damage and Healing Spells")
					if value then
						spellPower = spellPower + tonumber(value)
					end
					_, _, value = strfind(left:GetText(), "(.+) %(%d/%d%)")
					if value then
						SET_NAME = value
					end
					_, _, value = strfind(left:GetText(), "^Set: Increases damage and healing done by magical spells and effects by up to (%d+)%.")
					if value and SET_NAME and not SpellPower_Set_Bonus and not tContains(SpellPower_Set_Bonus, SET_NAME) then
						tinsert(SpellPower_Set_Bonus, SET_NAME)
						spellPower = spellPower + tonumber(value)
					end
				end
			end
		end
	end
	return spellPower
end



function Xeon.library.item:IsEquiped(slotId, itemName)
	local link = GetInventoryItemLink("player", slotId)
	if link then
		local _, _, name = string.find(link, "^.*%[(.*)%].*$")
		if string.find(name, itemName) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Xeon.library.item:UseBagItem(item)
	local link = nil
	local bagslots = nil
	for bag = 0, NUM_BAG_FRAMES do
		bagslots = GetContainerNumSlots(bag)
		if bagslots and bagslots > 0 then
			for slot = 1, bagslots do
				link = GetContainerItemLink(bag, slot)
				if link and string.find(link, item) and GetContainerItemCooldown(bag, slot) == 0 then
					UseContainerItem(bag, slot)
					return true
				end
			end
		end
	end
	return false
end

function Xeon.library.item:UseEquippedItem(item)
	for i = 1, 18 do
		local link = GetInventoryItemLink("player", i)
		if link then
			local _, _, name = string.find(link, "^.*%[(.*)%].*$")
			if string.find(name, item) then
				if GetInventoryItemCooldown("player", i) == 0 then
					UseInventoryItem(i)
					return true
				end
			end
		end
	end
	return false
end

function Xeon.library.item:UseNoggen()
	local function GetFeatherTime()
		for i = 0, 30 do
			local temp = GetPlayerBuffTexture(i)
			if temp and strfind(temp, "FeatherFall") then
				return GetPlayerBuffTimeLeft(i)
			end
		end
		return 0
	end

	if Xeon.cfg.item.useNoggen == 1 then
		local tName = UnitName("target")
		if not tName or (tName and UnitIsEnemy("target", "player") and not CheckInteractDistance("target", 3)) then
			if (not Xeon.library.buff:SerchBuffDescription("feel smaller", "player") or not Xeon.library.buff:SerchBuffDescription("feel light", "player")) or GetFeatherTime() <= 30 then
				if not Xeon.library.buff:SerchBuffDescription("Magical resistances increased by 100", "player") then
					if not Xeon.library.buff:SerchBuffDescription("Increases speed by (.+)%%", "player") then
						if self:UseBagItem("Noggenfogger Elixir") then
							Xeon.library.player.values.noggenTime = GetTime() + 3
							return
						end
					end
				end
			end
		end
	end
	if Xeon.cfg.item.useRumseyRum == 1 and not Xeon.library.player.values.isCasting then
		if
			(not Xeon.library.buff:IsBuffed("Rumsey Rum", "player")) and (not Xeon.library.buff:IsBuffed("Graccu", "player")) and (not UnitAffectingCombat("player")) and
				(not Xeon.library.player.values.isCasting)
		 then
			if self:UseBagItem("Rumsey Rum") then
				return
			end
		end
	end
end
