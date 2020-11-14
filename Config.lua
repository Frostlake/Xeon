Xeon.cfg = {
    common = {
        -- [debug_combat_msg] 0 : off // 1 : on - debug massage on or off
        debug_combat_msg = 0,
        -- [debug_heal_msg] 0 : off // 1 : on - debug massage on or off
        debug_heal_msg = 0,
        -- [debug_class_msg] 0 : off // 1 : on - debug massage on or off
        debug_class_msg = 0,
        -- [debug_enemy_msg] 0 : off // 1 : on - debug massage on or off
        debug_enemy_msg = 0
    },
    item = {
        useNoggen = 1,
        noggenBuff_feather = 1,
        noggenBuff_small = 1,
        noggenBuff_breath = 0,
        useRumseyRum = 1
    },
    heal = {
        -- [targetHealWeight] 0 to 100 : add healing priority by the specified percentage of numbers (default : 40)
        targetHealWeight = 20,
        -- [groupHealingMode] 1 : mana saving mode // 2 : weight rate is increases in proportion to the loss HP // 3 : always over healing by groupHealingOverHealRate option (default : 2)
        groupHealingMode = 2,
        -- [groupHealingOverHealRate] 0 to 100 : over healing specified rate while group healing.(default : 20)
        groupHealingOverHealRate = 20,
        --[stopCastingRate] 0 to - : if your target is healed over x%, you will immediately stop healing the target (even during casting)  (default : 150)
        stopCastingRate = 150
    },
    buff = {
        -- [dispellDebuff] 0 : off // 1 : battle ground only // 3 : always (default : 1)
        dispellDebuff = 3,
        -- [dispellDebuffHP_rate] 0 to 100 : dispell only when the injured's HP is above the specified rate (default : 50)
        dispellDebuffHP_rate = 50,
        -- [groupBuff] 0 : off // 1 : battle ground only // 3 : always (default : 1)
        groupBuff = 3,
        -- [groupBuffHP_rate] 0 to 100 : group buff only when the injured's HP is above the specified rate (default : 90)
        groupBuffHP_rate = 90
    },
    combat = {
        
    },
    paladin = {
        -- [secrificeBuff] 0 : off // 1 : battle ground only // 3 : always (default : 1)
        secrificeBuff = 1,
        -- [secrificeNum] how many people to buff Blessing of Sacrifice (default : 2)
        secrificeNum = 2,
        -- [targetHeal_flashOfLight_lvl] 1 to 6(max lvl) : what level of flash of light used to target over healing mode
        targetHeal_flashOfLight_lvl = 3,
        -- [lossHP_point_flashOfLight] If the amount loss HP is less than X, use flash of light. (default : 2500)
        lossHP_point_flashOfLight = 2500,
        -- [hammerOfWarthHP_rate] 0 to 100 : attack enemy with Hammer of warth, only when the injured's HP is above the specified rate (default : 50)
        hammerOfWarthHP_rate = 60,
        -- [meleeDps_rate] 0 to 100 : If the injured's HP is higher then X and player have enemy player target, Xeon attack target. (default : 70)
        meleeDps_rate = 70,
        -- [useHammerOfWarth] 0 : off // 1 : enemy player only(include auto targeting) // 2 : target only (default : 2)
        useHammerOfWarth = 1
    },
    shaman = {
        lossHP_point_lesserHealingWave =  2000
    }
}
