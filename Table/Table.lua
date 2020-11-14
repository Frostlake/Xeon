--[[    
    delay : if it must wait swap while trinket buff up
    buff : trinket buff name    
    if it is passive trinket, must put different priority then another passive trinket !!
    ]]
xeon_trinket_swap_list = {
    ["Paladin"] = {
        ["Survive"] = {
            ["Insignia of the Alliance"] = {priority = 2, delay = true, passive = false, buff = "Insignia of the Alliance"},
            ["Petrified Scarab"] = {priority = 1, delay = false, passive = false, buff = "Mercurial Shield"},
            ["Loatheb's Reflection"] = {priority = 2, delay = true, passive = false, buff = "Loatheb's Reflection"},
            ["The Burrower's Shell"] = {priority = 2, delay = true, passive = false, buff = "The Burrower's Shell"}
        },
        ["Healing"] = {
            ["Eye of the Dead"] = {priority = 2, delay = true, passive = false, buff = "The Eye of the Dead"},
            ["Rejuvenating Gem"] = {priority = 3, delay = false, passive = true, buff = "Rejuvenating Gem"},
            ["Hibernation Crystal"] = {priority = 2, delay = true, passive = false, buff = "Healing of the Ages"},
            ["Scrolls of Blinding Light"] = {priority = 2, delay = true, passive = false, buff = "Blinding Light"},
            ["Zandalarian Hero Charm"] = {priority = 2, delay = true, passive = false, buff = "Unstable Power"},
            ["Scarab Brooch"] = {priority = 2, delay = true, passive = false, buff = "Persistent Shield"},
            ["Talisman of Ephemeral Power"] = {priority = 2, delay = true, passive = false, buff = "Ephemeral Power"}
        },
        ["Melee_DPS"] = {
            ["Blackhand's Breadth"] = {priority = 4, delay = false, passive = true, buff = "Blackhand's Breadth"},
            ["Drake Fang Talisman"] = {priority = 4, delay = false, passive = true, buff = "Drake Fang Talisman"}
        },
        ["Caster_DPS"] = {}
    },
    ["Warrior"] = {
        ["Survive"] = {
            ["Styleen's Impeding Scarab"] = {priority = 4, delay = false, passive = true, buff = "Styleen's Impeding Scarab"}
        },
        ["Healing"] = {},
        ["Melee_DPS"] = {
            ["Kiss of the Spider"] = {priority = 2, delay = true, passive = false, buff = "Kiss of the Spider"},
         -- ["Jom Gabbar"] = {priority = 3, delay = true, passive = false, buff = "Jom Gabbar"},
           -- ["Zandalarian Hero Medallion"] = {priority = 3, delay = true, passive = false, buff = "Restless Strength"},
            ["Drake Fang Talisman"] = {priority = 4, delay = false, passive = true, buff = "Drake Fang Talisman"}
        },
        ["Caster_DPS"] = {}
    },
    ["Shaman"] = {
        ["Healing"] = {
            ["Eye of the Dead"] = {priority = 2, delay = true, passive = false, buff = "The Eye of the Dead"},
            ["Rejuvenating Gem"] = {priority = 3, delay = false, passive = true, buff = "Rejuvenating Gem"},
            ["Hibernation Crystal"] = {priority = 2, delay = true, passive = false, buff = "Healing of the Ages"},
            ["Scrolls of Blinding Light"] = {priority = 2, delay = true, passive = false, buff = "Blinding Light"},
            ["Zandalarian Hero Charm"] = {priority = 2, delay = true, passive = false, buff = "Unstable Power"},
            ["Scarab Brooch"] = {priority = 2, delay = true, passive = false, buff = "Persistent Shield"},
            ["Talisman of Ephemeral Power"] = {priority = 2, delay = true, passive = false, buff = "Ephemeral Power"}
        },
        ["Melee_DPS"] = {
            ["Blackhand's Breadth"] = {priority = 4, delay = false, passive = true, buff = "Blackhand's Breadth"},
            ["Drake Fang Talisman"] = {priority = 4, delay = false, passive = true, buff = "Drake Fang Talisman"}
        },
        ["Caster_DPS"] = {
            ["The Restrained Essence of Sapphiron"] = {priority = 4, delay = true, passive = false, buff = "Essence of Sapphiron"},
            ["Barov Peasant Caller"] = {priority = 1, delay = false, passive = false, buff = "Barov Peasant Caller"}, 
            ["Defender of the Timbermaw"] = {priority = 1, delay = false, passive = false, buff = "Defender of the Timbermaw"},            
            ["Tidal Charm"] = {priority = 2, delay = false, passive = false, buff = "Tidal Charm"}, 
            ["Natural Alignment Crystal"] = {priority = 3, delay = true, passive = false, buff = "Nature Aligned"},  
            ["Zandalarian Hero Charm"] = {priority = 5, delay = true, passive = false, buff = "Unstable Power"},  
            ["Talisman of Ephemeral Power"] = {priority = 6, delay = true, passive = false, buff = "Ephemeral Power"}     
        },
        ["Survive"] = {
            ["Insignia of the Horde"] = {priority = 2, delay = true, passive = false, buff = "Insignia of the Horde"},
            ["Petrified Scarab"] = {priority = 1, delay = false, passive = false, buff = "Mercurial Shield"},
            ["Loatheb's Reflection"] = {priority = 4, delay = true, passive = false, buff = "Loatheb's Reflection"},
            ["The Burrower's Shell"] = {priority = 3, delay = true, passive = false, buff = "The Burrower's Shell"},
            ["Neltharion's Tear"] = {priority = 5, delay = false, passive = true, buff = "Neltharion's Tear"}
        }        
    },
    ["Priest"] = {},
    ["Rogue"] = {},
    ["Druid"] = {},
    ["Warlock"] = {},
    ["Mage"] = {}
}

-- [debuffname], {priority, class}
xeon_debuff_common = {
    ["MAGIC"] = {
        ["Fear"] = {"A", {"all"}},
        ["Freezing Trap"] = {"A", {"all"}},
        ["Mind Control"] = {"A", {"all"}},
        ["Polymorph"] = {"A", {"all"}},
        ["Seduction"] = {"A", {"all"}},
        ["Terror"] = {"A", {"all"}},
        ["Counterspell"] = {"A", {"all"}},
        ["Reckless Charge"] = {"A", {"all"}},
        ["Hammer of Justice"] = {"A", {"all"}},
        ["Shadow Word: Pain"] = {"C", {"all"}},
        ["Immolate"] = {"C", {"all"}},
        ["Corruption"] = {"C", {"all"}},
        ["Hunter's Mark"] = {"B", {"Rogue"}},
        ["Frost Nova"] = {"A", {"Warrior", "Rogue", "Hunter", "player"}},
        ["Frost Shock"] = {"A", {"Warrior", "Rogue", "player"}},
        ["Frostbolt"] = {"A", {"Warrior", "Rogue", "player"}},
        ["Cone of Cold"] = {"A", {"Warrior", "Rogue", "player"}},
        ["Shadow Word: Pain"] = {"C", {"all"}},
        ["Entangling Roots"] = {"A", {"Warrior", "Rogue", "Hunter", "player"}}
    },
    ["POISON"] = {
        ["Blind"] = {"A", {"all"}},
        ["Crippling Poison"] = {"B", {"all"}},
        ["Viper Sting"] = {"B", {"Paladin", "Druid", "Shaman", "Warlock", "Hunter", "Mage", "Priest"}}
    },
    ---
    ["SLOW"] = {
        ["Hamstring"] = {"A", {"all"}},
        ["Wing Clip"] = {"B", {"all"}},
        ["Frost Nova"] = {"A", {"Warrior", "Rogue", "Hunter", "player"}},
        ["Frostbolt"] = {"A", {"Warrior", "Rogue", "player"}},
        ["Cone of Cold"] = {"A", {"Warrior", "Rogue", "player"}},
        ["Entangling Roots"] = {"A", {"Warrior", "Rogue", "Hunter", "player"}}
    },
    ["ETC"] = {
        ["Sap"] = {"A", {"all"}}
    }
}

xeon_debuff_pve = {
    ["The Molten Core"] = {
        ["MAGIC"] = {
            ["Ignite Mana"] = {"A", {"Paradin", "Priest", "Warlock", "Shaman", "Hunter"}},
            ["Ancient Despair"] = {"A", {"all"}},
            ["Ancient Dread"] = {"A", {"all"}},
            ["Incite Flames"] = {"A", {"all"}},
            ["Cauterizing Flames"] = {"A", {"all"}},
            ["Withering Heat"] = {"A", {"all"}},
            ["Soul Burn"] = {"A", {"all"}}
        }
    }
}

xeon_healing_spell_data = {
    ["Paladin"] = {
        ["Flash of Light"] = {
            spell = {
                [1] = {basePower = (62 + 73) / 2, lvl = 20, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = (96 + 111) / 2, lvl = 26, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = (145 + 164) / 2, lvl = 34, basicCoefficient = 1.5 / 3.5},
                [4] = {basePower = (197 + 222) / 2, lvl = 42, basicCoefficient = 1.5 / 3.5},
                [5] = {basePower = (267 + 300) / 2, lvl = 50, basicCoefficient = 1.5 / 3.5},
                [6] = {basePower = (343 + 384) / 2, lvl = 58, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Holy Shock"] = {
            spell = {
                [1] = {basePower = (204 + 221) / 2, lvl = 40, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = (279 + 302) / 2, lvl = 48, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = (365 + 396) / 2, lvl = 56, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Holy Light"] = {
            spell = {
                [1] = {basePower = (39 + 48) / 2, lvl = 1, basicCoefficient = 2.5 / 3.5},
                [2] = {basePower = (76 + 91) / 2, lvl = 6, basicCoefficient = 2.5 / 3.5},
                [3] = {basePower = (159 + 188) / 2, lvl = 14, basicCoefficient = 2.5 / 3.5},
                [4] = {basePower = (310 + 357) / 2, lvl = 22, basicCoefficient = 2.5 / 3.5},
                [5] = {basePower = (491 + 554) / 2, lvl = 30, basicCoefficient = 2.5 / 3.5},
                [6] = {basePower = (698 + 781) / 2, lvl = 48, basicCoefficient = 2.5 / 3.5},
                [7] = {basePower = (945 + 1054) / 2, lvl = 46, basicCoefficient = 2.5 / 3.5},
                [8] = {basePower = (1246 + 1389) / 2, lvl = 54, basicCoefficient = 2.5 / 3.5},
                [9] = {basePower = (1590 + 1771) / 2, lvl = 60, basicCoefficient = 2.5 / 3.5}
            }
        }
    },
    ["Shaman"] = {
        ["Healing Wave"] = {
            spell = {
                [1] = {basePower = (34 + 45) / 2, lvl = 1, basicCoefficient = 1.5 / 3.5}, --1.5sec
                [2] = {basePower = (64 + 79) / 2, lvl = 6, basicCoefficient = 2 / 3.5}, --2sec
                [3] = {basePower = (129 + 156) / 2, lvl = 12, basicCoefficient = 2.5 / 3.5}, --2.5sec
                [4] = {basePower = (268 + 317) / 2, lvl = 18, basicCoefficient = 3 / 3.5}, --3sec
                [5] = {basePower = (376 + 441) / 2, lvl = 24, basicCoefficient = 3 / 3.5},
                [6] = {basePower = (536 + 623) / 2, lvl = 32, basicCoefficient = 3 / 3.5},
                [7] = {basePower = (740 + 855) / 2, lvl = 40, basicCoefficient = 3 / 3.5},
                [8] = {basePower = (1017 + 1168) / 2, lvl = 48, basicCoefficient = 3 / 3.5},
                [9] = {basePower = (1367 + 1562) / 2, lvl = 56, basicCoefficient = 3 / 3.5},
                [10] = {basePower = (1620 + 1851) / 2, lvl = 60, basicCoefficient = 3 / 3.5}
            }
        },
        ["Lesser Healing Wave"] = {
            spell = {
                [1] = {basePower = (162 + 187) / 2, lvl = 20, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = (247 + 282) / 2, lvl = 28, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = (337 + 382) / 2, lvl = 36, basicCoefficient = 1.5 / 3.5},
                [4] = {basePower = (458 + 515) / 2, lvl = 44, basicCoefficient = 1.5 / 3.5},
                [5] = {basePower = (631 + 706) / 2, lvl = 52, basicCoefficient = 1.5 / 3.5},
                [6] = {basePower = (832 + 929) / 2, lvl = 60, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Chain Heal"] = {
            spell = {
                [1] = {basePower = (320 + 369) / 2, lvl = 40, basicCoefficient = 2.5 / 3.5},
                [2] = {basePower = (405 + 466) / 2, lvl = 46, basicCoefficient = 2.5 / 3.5},
                [3] = {basePower = (551 + 630) / 2, lvl = 54, basicCoefficient = 2.5 / 3.5}
            }
        }
    },
    ["Priest"] = {
        ["Flash Heal"] = {
            spell = {
                [1] = {basePower = (193 + 238) / 2, lvl = 20, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = (238 + 315) / 2, lvl = 26, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = (327 + 394) / 2, lvl = 32, basicCoefficient = 1.5 / 3.5},
                [4] = {basePower = (400 + 479) / 2, lvl = 38, basicCoefficient = 1.5 / 3.5},
                [5] = {basePower = (518 + 617) / 2, lvl = 44, basicCoefficient = 1.5 / 3.5},
                [6] = {basePower = (644 + 765) / 2, lvl = 50, basicCoefficient = 1.5 / 3.5},
                [7] = {basePower = (812 + 959) / 2, lvl = 56, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Lesser Heal"] = {
            spell = {
                [1] = {basePower = (46 + 57) / 2, lvl = 1, basicCoefficient = 1.5 / 3.5}, --1.5sec
                [2] = {basePower = (71 + 86) / 2, lvl = 4, basicCoefficient = 2 / 3.5}, --2sec
                [3] = {basePower = (135 + 158) / 2, lvl = 10, basicCoefficient = 2.5 / 3.5}
            }
        },
        ["Renew"] = {
            spell = {
                [1] = {basePower = 45, lvl = 8, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = 100, lvl = 14, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = 175, lvl = 20, basicCoefficient = 1.5 / 3.5},
                [4] = {basePower = 245, lvl = 26, basicCoefficient = 1.5 / 3.5},
                [5] = {basePower = 315, lvl = 32, basicCoefficient = 1.5 / 3.5},
                [6] = {basePower = 400, lvl = 38, basicCoefficient = 1.5 / 3.5},
                [7] = {basePower = 510, lvl = 44, basicCoefficient = 1.5 / 3.5},
                [8] = {basePower = 650, lvl = 50, basicCoefficient = 1.5 / 3.5},
                [9] = {basePower = 810, lvl = 56, basicCoefficient = 1.5 / 3.5},
                [10] = {basePower = 970, lvl = 60, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Lightwell Renew"] = {
            spell = {
                [1] = {basePower = 160, lvl = 40, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = 233, lvl = 50, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = 320, lvl = 60, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Desperate Prayer"] = {
            spell = {
                [1] = {basePower = (134 + 171) / 2, lvl = 10, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = (263 + 326) / 2, lvl = 18, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = (447 + 544) / 2, lvl = 26, basicCoefficient = 1.5 / 3.5},
                [4] = {basePower = (588 + 709) / 2, lvl = 34, basicCoefficient = 1.5 / 3.5},
                [5] = {basePower = (834 + 995) / 2, lvl = 42, basicCoefficient = 1.5 / 3.5},
                [6] = {basePower = (1101 + 1306) / 2, lvl = 50, basicCoefficient = 1.5 / 3.5},
                [7] = {basePower = (1324 + 1563) / 2, lvl = 58, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Heal"] = {
            spell = {
                [1] = {basePower = (295 + 342) / 2, lvl = 16, basicCoefficient = 3 / 3.5},
                [2] = {basePower = (429 + 492) / 2, lvl = 22, basicCoefficient = 3 / 3.5},
                [3] = {basePower = (566 + 643) / 2, lvl = 28, basicCoefficient = 3 / 3.5},
                [4] = {basePower = (712 + 805) / 2, lvl = 34, basicCoefficient = 3 / 3.5}
            }
        },
        ["Prayer of Healing"] = {
            spell = {
                [1] = {basePower = (301 + 322) / 2, lvl = 30, basicCoefficient = 3 / 3.5},
                [2] = {basePower = (444 + 473) / 2, lvl = 40, basicCoefficient = 3 / 3.5},
                [3] = {basePower = (657 + 696) / 2, lvl = 50, basicCoefficient = 3 / 3.5},
                [4] = {basePower = (939 + 992) / 2, lvl = 60, basicCoefficient = 3 / 3.5},
                [5] = {basePower = (1041 + 1100) / 2, lvl = 60, basicCoefficient = 3 / 3.5}
            }
        },
        ["Greater Heal"] = {
            spell = {
                [1] = {basePower = (899 + 1014) / 2, lvl = 40, basicCoefficient = 3 / 3.5},
                [2] = {basePower = (1149 + 1290) / 2, lvl = 46, basicCoefficient = 3 / 3.5},
                [3] = {basePower = (1437 + 1610) / 2, lvl = 52, basicCoefficient = 3 / 3.5},
                [4] = {basePower = (1798 + 2007) / 2, lvl = 58, basicCoefficient = 3 / 3.5},
                [5] = {basePower = (1955 + 2195) / 2, lvl = 60, basicCoefficient = 3 / 3.5}
            }
        },
        ["Holy Nova"] = {
            spell = {
                [1] = {basePower = (52 + 61) / 2, lvl = 20, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = (86 + 99) / 2, lvl = 28, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = (121 + 140) / 2, lvl = 36, basicCoefficient = 1.5 / 3.5},
                [4] = {basePower = (161 + 188) / 2, lvl = 44, basicCoefficient = 1.5 / 3.5},
                [5] = {basePower = (235 + 272) / 2, lvl = 60, basicCoefficient = 1.5 / 3.5},
                [6] = {basePower = (302 + 351) / 2, lvl = 60, basicCoefficient = 1.5 / 3.5}
            }
        }
    },
    ["Druid"] = {
        ["Rejuvenation"] = {
            spell = {
                [1] = {basePower = 32, lvl = 4, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = 56, lvl = 10, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = 116, lvl = 16, basicCoefficient = 1.5 / 3.5},
                [4] = {basePower = 180, lvl = 22, basicCoefficient = 1.5 / 3.5},
                [5] = {basePower = 244, lvl = 28, basicCoefficient = 1.5 / 3.5},
                [6] = {basePower = 304, lvl = 34, basicCoefficient = 1.5 / 3.5},
                [7] = {basePower = 388, lvl = 40, basicCoefficient = 1.5 / 3.5},
                [8] = {basePower = 488, lvl = 46, basicCoefficient = 1.5 / 3.5},
                [9] = {basePower = 608, lvl = 52, basicCoefficient = 1.5 / 3.5},
                [10] = {basePower = 756, lvl = 58, basicCoefficient = 1.5 / 3.5},
                [11] = {basePower = 888, lvl = 60, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Tranquility"] = {
            spell = {
                [1] = {basePower = 94, lvl = 30, basicCoefficient = 1.5 / 3.5},
                [2] = {basePower = 138, lvl = 40, basicCoefficient = 1.5 / 3.5},
                [3] = {basePower = 205, lvl = 50, basicCoefficient = 1.5 / 3.5},
                [4] = {basePower = 294, lvl = 60, basicCoefficient = 1.5 / 3.5}
            }
        },
        ["Regrowth"] = {
            spell = {
                [1] = {basePower = (84 + 99) / 2, lvl = 12, basicCoefficient = 2 / 3.5},
                [2] = {basePower = (164 + 189) / 2, lvl = 18, basicCoefficient = 2 / 3.5},
                [3] = {basePower = (240 + 275) / 2, lvl = 24, basicCoefficient = 2 / 3.5},
                [4] = {basePower = (318 + 361) / 2, lvl = 30, basicCoefficient = 2 / 3.5},
                [5] = {basePower = (405 + 458) / 2, lvl = 36, basicCoefficient = 2 / 3.5},
                [6] = {basePower = (511 + 576) / 2, lvl = 42, basicCoefficient = 2 / 3.5},
                [7] = {basePower = (646 + 725) / 2, lvl = 48, basicCoefficient = 2 / 3.5},
                [8] = {basePower = (809 + 906) / 2, lvl = 54, basicCoefficient = 2 / 3.5},
                [9] = {basePower = (1003 + 1120) / 2, lvl = 60, basicCoefficient = 2 / 3.5}
            }
        },
        ["Healing Touch"] = {
            spell = {
                [1] = {basePower = (37 + 52) / 2, lvl = 1, basicCoefficient = 1.5 / 3.5}, --1.5sec
                [2] = {basePower = (88 + 113) / 2, lvl = 8, basicCoefficient = 2 / 3.5}, --2sec
                [3] = {basePower = (195 + 244) / 2, lvl = 14, basicCoefficient = 2.5 / 3.5}, --2.5sec
                [4] = {basePower = (363 + 446) / 2, lvl = 20, basicCoefficient = 3 / 3.5}, --3sec
                [5] = {basePower = (572 + 695) / 2, lvl = 26, basicCoefficient = 3.5 / 3.5}, --3.5sec
                [6] = {basePower = (742 + 895) / 2, lvl = 32, basicCoefficient = 3.5 / 3.5},
                [7] = {basePower = (936 + 1121) / 2, lvl = 38, basicCoefficient = 3.5 / 3.5},
                [8] = {basePower = (1199 + 1428) / 2, lvl = 44, basicCoefficient = 3.5 / 3.5},
                [9] = {basePower = (1516 + 1797) / 2, lvl = 50, basicCoefficient = 3.5 / 3.5},
                [10] = {basePower = (1890 + 2231) / 2, lvl = 56, basicCoefficient = 3.5 / 3.5},
                [11] = {basePower = (2267 + 2678) / 2, lvl = 60, basicCoefficient = 3.5 / 3.5}
            }
        }
    }
}

-- for heal or buff skill range check
xeon_range_check_spell_data = {
    ["Paladin"] = {
        ["30Y"] = "Cleanse",
        ["40Y"] = "Flash of Light"
    },
    ["Shaman"] = {
        ["30Y"] = "Purge",
        ["40Y"] = "Healing Wave"
    }

}

-- for heal or buff skill range check
xeon_attack_range_check_spell_data = {
    ["Paladin"] = {
        ["10Y"] = "Hammer of Justice"
    }
}

-- enemy spell data
__xeon_buff_data = {
    ["Demon Skin"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Demon Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Shadow Ward"] = {dura = 30, dispellType = "Magic", priority = "B", cooltime = 30}
}

-- for enemy casting info : castingBreak = make target lost currelt casting
__xeon_spell_data = {
    ["Fear"] = {castTime = 1.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Howl of Terror"] = {castTime = 2, priority = "A", cooltime = 40, castingBreak = true, channeled = false},
    ["Soul Fire"] = {castTime = 6, priority = "B", cooltime = 60, castingBreak = false, channeled = false},
    ["Shadow Bolt"] = {castTime = 3, priority = "B", cooltime = 0, castingBreak = false, channeled = false},
    ["Immolate"] = {castTime = 2, priority = "B", cooltime = 0, castingBreak = false, channeled = false},
    ["Drain Life"] = {castTime = 5, priority = "D", cooltime = 0, castingBreak = false, channeled = true}
}

xeon_buff_data = {
    --warlock
    ["Demon Skin"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Demon Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Shadow Ward"] = {dura = 30, dispellType = "Magic", priority = "C", cooltime = 30},
    ["Unending Breath"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Amplify Curse"] = {dura = 30, dispellType = "Magic", priority = "D", cooltime = 60 * 3},
    ["Detect Greater Invisibility"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Soulstone"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 30},
    ["Major Spellstone"] = {dura = 60, dispellType = "Magic", priority = "B", cooltime = 60 * 3},
    ["Soul Link"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Soul Link"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    --사용조건 완료후 소멸
    ["Sacrifice"] = {dura = 30, dispellType = "Magic", priority = "A", cooltime = 0},
    ["Fel Domination"] = {dura = 15, dispellType = "Magic", priority = "A", cooltime = 60 * 15},
    --druid
    ["Innervate"] = {dura = 20, dispellType = "Magic", priority = "B", cooltime = 60 * 6},
    ["Gift of the Wild"] = {dura = 60 * 60, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Mark of the Wild"] = {dura = 60 * 30, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Abolish Poison"] = {dura = 8, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Rejuvenation"] = {dura = 12, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Regrowth"] = {dura = 21, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Barkskin"] = {dura = 15, dispellType = "Magic", priority = "C", cooltime = 60},
    ["Thorns"] = {dura = 60 * 10, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Omen of Clarity"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Nature's Swiftness"] = {dura = 30, dispellType = "Magic", priority = "A", cooltime = 60 * 3},
    --사용조건 완료후 소멸
    ["Nature's Grasp"] = {dura = 45, dispellType = "Magic", priority = "D", cooltime = 60},
    --mage
    
    ["Arcane Brilliance"] = {dura = 60 * 60, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Arcane Intellect"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Amplify Magic"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Dampen Magic"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Mana Shield"] = {dura = 60, dispellType = "Magic", priority = "A", cooltime = 0},
    ["Ice Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "B", cooltime = 0},
    ["Frost Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "B", cooltime = 0},
    ["Fire Ward"] = {dura = 30, dispellType = "Magic", priority = "B", cooltime = 30},
    ["Frost Ward"] = {dura = 30, dispellType = "Magic", priority = "B", cooltime = 0},
    ["Ice Barrier"] = {dura = 30, dispellType = "Magic", priority = "A", cooltime = 0},
    ["Ice Block"] = {dura = 10, dispellType = "Magic", priority = "D", cooltime = 60 * 5},
    ["Combustion"] = {dura = 30, dispellType = "Magic", priority = "A", cooltime = 60 * 3},
    ["Slow Fall"] = {dura = 30, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Mage Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    --사용조건 완료후 소멸
    ["Arcane Power"] = {dura = 15, dispellType = "Magic", priority = "A", cooltime = 60 * 3},
    ["Presence of Mind"] = {dura = 30, dispellType = "Magic", priority = "A", cooltime = 60 * 3},
    --사용조건 완료후 소멸
    --hunter
    ["Rapid Fire"] = {dura = 15, dispellType = "Magic", priority = "B", cooltime = 60 * 5},
    --priest
    ["Prayer of Shadow Protection"] = {dura = 60 * 20, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Fear Ward"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 30},
    ["Power Word: Shield"] = {dura = 15, dispellType = "Magic", priority = "A", cooltime = 4},
    ["Mind Control"] = {dura = 60, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Renew"] = {dura = 15, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Prayer of Spirit"] = {dura = 60 * 60, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Shadow Protection"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Levitate"] = {dura = 60 * 2, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Fade"] = {dura = 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Shadowguard"] = {dura = 60 * 10, dispellType = "Magic", priority = "B", cooltime = 0},
    ["Prayer of Fortitude"] = {dura = 60 * 60, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Power Word: Fortitude"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Feedback"] = {dura = 15, dispellType = "Magic", priority = "B", cooltime = 60 * 3},
    ["Inner Fire"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Touch of Weakness"] = {dura = 60 * 2, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Elune's Grace"] = {dura = 15, dispellType = "Magic", priority = "D", cooltime = 60 * 5},
    ["Abolish Disease"] = {dura = 20, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Divine Spirit"] = {dura = 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Inner Focus"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 60 * 3},
    --사용조건 완료후 소멸
    ["Power Infusion"] = {dura = 15, dispellType = "Magic", priority = "D", cooltime = 60 * 3},
    --paladin
    ["Blessing of Protection"] = {dura = 6, dispellType = "Magic", priority = "A", cooltime = 60 * 5},
    ["Blessing of Sacrifice"] = {dura = 30, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Blessing of Might"] = {dura = 60 * 30, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Blessing of Salvation"] = {dura = 5, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Blessing of Light"] = {dura = 60 * 5, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Blessing of Wisdom"] = {dura = 60 * 5, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Blessing of Sanctuary"] = {dura = 60 * 5, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Blessing of Kings"] = {dura = 60 * 5, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Greater Blessing of Wisdom"] = {dura = 60 * 15, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Greater Blessing of Kings"] = {dura = 60 * 15, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Greater Blessing of Might"] = {dura = 60 * 15, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Greater Blessing of Sanctuary"] = {dura = 60 * 15, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Greater Blessing of Light"] = {dura = 60 * 15, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Greater Blessing of Salvation"] = {dura = 60 * 15, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Blessing of Freedom"] = {dura = 10, dispellType = "Magic", priority = "A", cooltime = 20},
    ["Seal of the Crusader"] = {dura = 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Seal of Justice"] = {dura = 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Seal of Command"] = {dura = 30, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Seal of Righteousness"] = {dura = 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Seal of Light"] = {dura = 30, dispellType = "Magic", priority = "C", cooltime = 0},
    ["Seal of Wisdom"] = {dura = 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Divine Shield"] = {dura = 12, dispellType = "Magic", priority = "D", cooltime = 60 * 5},
    ["Divine Favor"] = {dura = 30, dispellType = "Magic", priority = "C", cooltime = 60 * 2}, --사용조건 완료후 소멸
    ["Righteous Fury"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Holy Shield"] = {dura = 10, dispellType = "Magic", priority = "D", cooltime = 10},
    --shaman
    ["Ghost Wolf"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    --변신풀릴때까지 유지
    ["Water Walking"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Water Breathing"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Lightning Shield"] = {dura = 60 * 10, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Stormstrike"] = {dura = 12, dispellType = "Magic", priority = "D", cooltime = 20},
    ["Elemental Mastery"] = {dura = 30, dispellType = "Magic", priority = "D", cooltime = 60 * 3},
    ["Nature's Swiftness"] = {dura = 60 * 30, dispellType = "Magic", priority = "A", cooltime = 60 * 3},
   
  
    -- Item
    ["Frost Reflector"] = {dura = 5, dispellType = "Magic", priority = "C", cooltime = 60 * 5},
    ["Burrower's Shell"] = {dura = 20, dispellType = "Magic", priority = "B", cooltime = 60 * 2},
    ["Mercurial Shield"] = {dura = 60, dispellType = "Magic", priority = "C", cooltime = 60 * 3},
    ["Unstable Power"] = {dura = 60 * 2, dispellType = "Magic", priority = "C", cooltime = 60 * 3},
    ["Demon Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Demon Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Demon Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Demon Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Demon Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0},
    ["Demon Armor"] = {dura = 60 * 30, dispellType = "Magic", priority = "D", cooltime = 0}

}

xeon_spell_data = {
    --Warrior
    ["Howl of Terror"] = {castTime = 2, priority = "D", cooltime = 40, castingBreak = false, channeled = false},
    ["Pummel"] = {castTime = 0, priority = "D", cooltime = 10, castingBreak = false, channeled = false},
    ["Intercept"] = {castTime = 0, priority = "D", cooltime = 30, castingBreak = false, channeled = false},
    ["Intimidating Shout"] = {castTime = 0, priority = "D", cooltime = 60 * 3, castingBreak = false, channeled = false},
    ["Shield Bash"] = {castTime = 0, priority = "D", cooltime = 12, castingBreak = false, channeled = false},
    ["Concussion Blow"] = {castTime = 0, priority = "D", cooltime = 45, castingBreak = false, channeled = false},
    ["Charge"] = {castTime = 0, priority = "D", cooltime = 15, castingBreak = false, channeled = false},
    --Rogue
    ["Kidney Shot"] = {castTime = 0, priority = "D", cooltime = 20, castingBreak = false, channeled = false},
    ["Cheap Shot"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Blind"] = {castTime = 0, priority = "D", cooltime = 60 * 5, castingBreak = false, channeled = false},
    ["Kick"] = {castTime = 0, priority = "D", cooltime = 10, castingBreak = false, channeled = false},
    ["Gouge"] = {castTime = 0, priority = "D", cooltime = 10, castingBreak = false, channeled = false},
    ["Sap"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    --Hunter
    ["Freezing Trap"] = {castTime = 0, priority = "D", cooltime = 15, castingBreak = false, channeled = false},
    ["Concussive Shot"] = {castTime = 0, priority = "D", cooltime = 12, castingBreak = false, channeled = false},
    ["Scatter Shot"] = {castTime = 0, priority = "D", cooltime = 30, castingBreak = false, channeled = false},
    ["Wyvern Sting"] = {castTime = 0, priority = "D", cooltime = 60 * 2, castingBreak = false, channeled = false},
    ["Volley"] = {castTime = 0, priority = "D", cooltime = 60 * 2, castingBreak = false, channeled = false},
    --Paladin
    ["Hammer of Justice"] = {castTime = 0, priority = "D", cooltime = 60, castingBreak = false, channeled = false},
    ["Repentance"] = {castTime = 0, priority = "D", cooltime = 60, castingBreak = false, channeled = false},
    ["Cleanse"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Flash of Light"] = {castTime = 1.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Holy Light"] = {castTime = 2.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Consecration"] = {castTime = 0, priority = "D", cooltime = 8, castingBreak = false, channeled = false},
    ["Holy Shield"] = {castTime = 0, priority = "D", cooltime = 10, castingBreak = false, channeled = false},
    ["Divine Favor"] = {castTime = 0, priority = "D", cooltime = 60 * 2, castingBreak = false, channeled = false},
    --Druid
    ["Bash"] = {castTime = 0, priority = "D", cooltime = 60, castingBreak = false, channeled = false},
    ["Feral Charge"] = {castTime = 0, priority = "D", cooltime = 15, castingBreak = false, channeled = false},
    ["Innervate"] = {castTime = 0, priority = "D", cooltime = 60 * 6, castingBreak = false, channeled = false},
    ["Abolish Poison"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Faerie Fire"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Faerie Fire (Feral)"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Rejuvenation"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Regrowth"] = {castTime = 2, priority = "C", cooltime = 0, castingBreak = true, channeled = false},
    ["Healing Touch"] = {castTime = 3.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Omen of Clarity"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Barkskin"] = {castTime = 0, priority = "D", cooltime = 60, castingBreak = false, channeled = false},
    ["Thorns"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Frenzied Regeneration"] = {castTime = 0, priority = "D", cooltime = 60 * 3, castingBreak = false, channeled = false},
    ["Entangling Roots"] = {castTime = 1.5, priority = "C", cooltime = 0, castingBreak = true, channeled = false},
    ["Insect Swarm"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Hibernate"] = {castTime = 1.5, priority = "C", cooltime = 0, castingBreak = true, channeled = false},
    ["Tranquility"] = {castTime = 10, priority = "A", cooltime = 60 * 5, castingBreak = true, channeled = true},
    ["Hurricane"] = {castTime = 10, priority = "B", cooltime = 60, castingBreak = true, channeled = true},
    ["Moonfire"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Starfire"] = {castTime = 3.5, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Wrath"] = {castTime = 2, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    --Mage
    ["Counterspell"] = {castTime = 0, priority = "D", cooltime = 30, castingBreak = false, channeled = false},
    ["Polymorph"] = {castTime = 1.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Polymorph: Cow"] = {castTime = 1.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false}, --네파 법사스킬
    ["Impact"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false}, --화염주문시 발동
    ["Arcane Missiles"] = {castTime = 5, priority = "B", cooltime = 0, castingBreak = true, channeled = true},
    ["Evocation"] = {castTime = 8, priority = "A", cooltime = 60 * 8, castingBreak = true, channeled = true},
    ["Blizzard"] = {castTime = 8, priority = "B", cooltime = 0, castingBreak = true, channeled = true},
    ["Fireball"] = {castTime = 3.5, priority = "B", cooltime = 0, castingBreak = true, channeled = false}, --1레벨 1.5sec
    ["Frostbolt"] = {castTime = 3, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Scorch"] = {castTime = 1.5, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Detect Magic"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Frost Nova"] = {castTime = 0, priority = "D", cooltime = 25, castingBreak = false, channeled = false},
    ["Cone of Cold"] = {castTime = 0, priority = "D", cooltime = 10, castingBreak = false, channeled = false},
    ["Fire Blast"] = {castTime = 0, priority = "D", cooltime = 8, castingBreak = false, channeled = false},
    ["Flamestrike"] = {castTime = 3, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Pyroblast"] = {castTime = 6, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Remove Lesser Curse"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Ignite"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Ice Block"] = {castTime = 0, priority = "D", cooltime = 60 * 5, castingBreak = false, channeled = false},
    ["Presence of Mind"] = {castTime = 0, priority = "D", cooltime = 60 * 3, castingBreak = false, channeled = false},
    ["Cold Snap"] = {castTime = 0, priority = "D", cooltime = 60 * 10, castingBreak = false, channeled = false},
    --Priest
    ["Psychic Scream"] = {castTime = 0, priority = "D", cooltime = 30, castingBreak = false, channeled = false},
    ["Silence"] = {castTime = 0, priority = "D", cooltime = 45, castingBreak = false, channeled = false},
    ["Mind Control"] = {castTime = 3, priority = "A", cooltime = 0, castingBreak = true, channeled = false}, --정신지배
    ["Blackout"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false}, --채찍사용중 발동
    ["Mind Flay"] = {castTime = 3, priority = "B", cooltime = 0, castingBreak = true, channeled = true},
    ["Starshards"] = {castTime = 6, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Mind Vision"] = {castTime = 60, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Dispel Magic"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Flash Heal"] = {castTime = 1.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Greater Heal"] = {castTime = 3, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Lesser Heal"] = {castTime = 2.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Prayer of Healing"] = {castTime = 3, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Heal"] = {castTime = 3, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Renew"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Desperate Prayer"] = {castTime = 0, priority = "D", cooltime = 60 * 10, castingBreak = false, channeled = false},
    ["Holy Nova"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Lightwell"] = {castTime = 1.5, priority = "B", cooltime = 60 * 10, castingBreak = true, channeled = false},
    ["Holy Fire"] = {castTime = 3.5, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Mana Burn"] = {castTime = 3, priority = "C", cooltime = 0, castingBreak = true, channeled = false},
    ["Hex of Weakness"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Touch of Weakness"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Devouring Plague"] = {castTime = 0, priority = "D", cooltime = 60 * 3, castingBreak = false, channeled = false},
    ["Smite"] = {castTime = 2.5, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Shadow Word: Pain"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Mind Blast"] = {castTime = 1.5, priority = "B", cooltime = 8, castingBreak = true, channeled = false},
    ["Mind Soothe"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Shackle Undead"] = {castTime = 1.5, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Vampiric Embrace"] = {castTime = 0, priority = "D", cooltime = 10, castingBreak = false, channeled = false},
    ["Power Infusion"] = {castTime = 0, priority = "D", cooltime = 60 * 3, castingBreak = false, channeled = false},
    --Shaman
    ["Windfury Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Nature Resistance Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Grace of Air Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Tremor Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Poison Cleansing Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["trength of Earth Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Grounding Totem"] = {castTime = 0, priority = "D", cooltime = 15, castingBreak = false, channeled = false},
    ["Tranquil Air Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Mana Spring Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Healing Stream Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Fire Resistance Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Earthbind Totem"] = {castTime = 0, priority = "D", cooltime = 15, castingBreak = false, channeled = false},
    ["Fire Nova Totem"] = {castTime = 0, priority = "D", cooltime = 15, castingBreak = false, channeled = false},
    ["Windwall Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Searing Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Stoneskin Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Mana Tide Totem"] = {castTime = 0, priority = "D", cooltime = 60 * 5, castingBreak = false, channeled = false},
    ["Flametongue Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Magma Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Stoneclaw Totem"] = {castTime = 0, priority = "D", cooltime = 30, castingBreak = false, channeled = false},
    ["Disease Cleansing Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Frost Resistance Totem"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Ghost Wolf"] = {castTime = 3, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Chain Heal"] = {castTime = 2.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Lesser Healing"] = {castTime = 1.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Healing Wave"] = {castTime = 3, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Purge"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Reincarnation"] = {castTime = 0, priority = "D", cooltime = 60 * 60, castingBreak = false, channeled = false},
    ["Water Walking"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Earth Shock"] = {castTime = 0, priority = "D", cooltime = 6, castingBreak = false, channeled = false},
    ["Lightning Bolt"] = {castTime = 3, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Chain Lightning"] = {castTime = 2.5, priority = "A", cooltime = 6, castingBreak = true, channeled = false},
    ["Astral Recall"] = {castTime = 0, priority = "D", cooltime = 60 * 15, castingBreak = false, channeled = false},
    ["Far Sight"] = {castTime = 10, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Ancestral Spirit"] = {castTime = 10, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Water Breathing"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Cure Poison"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Cure Disease"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Lightning Shield"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Frost Shock"] = {castTime = 0, priority = "D", cooltime = 6, castingBreak = false, channeled = false},
    ["Stormstrike"] = {castTime = 0, priority = "D", cooltime = 20, castingBreak = false, channeled = false},
    ["Nature's Swiftness"] = {castTime = 0, priority = "D", cooltime = 60 * 3, castingBreak = false, channeled = false},
    ["Elemental Mastery"] = {castTime = 0, priority = "D", cooltime = 60 * 3, castingBreak = false, channeled = false},
    --Warlock
    ["itual of Doom"] = {castTime = 10, priority = "D", cooltime = 60 * 60, castingBreak = false, channeled = false},
    ["Ritual of Summoning"] = {castTime = 5, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Inferno"] = {castTime = 2, priority = "B", cooltime = 60 * 60, castingBreak = true, channeled = false},
    ["Summon Voidwalker"] = {castTime = 10, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Summon Succubus"] = {castTime = 10, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Summon Imp"] = {castTime = 10, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Summon Felhunter"] = {castTime = 10, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Summon Dreadsteed"] = {castTime = 3, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Summon Felsteed"] = {castTime = 3, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Eye of Kilrogg"] = {castTime = 5, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Shadow Bolt"] = {castTime = 3, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Death Coil"] = {castTime = 0, priority = "D", cooltime = 60 * 2, castingBreak = false, channeled = false},
    ["Curse of Doom"] = {castTime = 0, priority = "D", cooltime = 60, castingBreak = false, channeled = false},
    ["Curse of Shadow"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Curse of the Elements"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Curse of Recklessness"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Curse of Weakness"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Curse of Agony"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Searing Pain"] = {castTime = 1.5, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Corruption"] = {castTime = 2, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Soul Fire"] = {castTime = 6, priority = "A", cooltime = 60, castingBreak = true, channeled = false},
    ["Immolate"] = {castTime = 2, priority = "B", cooltime = 0, castingBreak = true, channeled = false},
    ["Drain Mana"] = {castTime = 5, priority = "C", cooltime = 0, castingBreak = true, channeled = true},
    ["Drain Soul"] = {castTime = 15, priority = "D", cooltime = 0, castingBreak = true, channeled = true},
    ["Drain Life"] = {castTime = 5, priority = "C", cooltime = 0, castingBreak = true, channeled = true},
    ["Fear"] = {castTime = 1.5, priority = "A", cooltime = 0, castingBreak = true, channeled = false},
    ["Shadow Ward"] = {castTime = 0, priority = "D", cooltime = 30, castingBreak = false, channeled = false},
    ["Hellfire"] = {castTime = 15, priority = "B", cooltime = 0, castingBreak = true, channeled = true},
    ["Life Tap"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Enslave Demon"] = {castTime = 3, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Rain of Fire"] = {castTime = 8, priority = "C", cooltime = 0, castingBreak = true, channeled = true},
    ["Howl of Terror"] = {castTime = 2, priority = "A", cooltime = 40, castingBreak = true, channeled = false},
    ["Create Firestone (Major)"] = {castTime = 3, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Create Spellstone"] = {castTime = 5, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Dark Pact"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Banish"] = {castTime = 1.5, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Siphon Life"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Create Healthstone (Major)"] = {castTime = 3, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Health Funnel"] = {castTime = 10, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Demonic Sacrifice"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Shadowburn"] = {castTime = 0, priority = "D", cooltime = 15, castingBreak = false, channeled = false},
    ["Soul Link"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Conflagrate"] = {castTime = 0, priority = "D", cooltime = 10, castingBreak = false, channeled = false},
    ["Curse of Exhaustion"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Fel Domination"] = {castTime = 0, priority = "A", cooltime = 60 * 15, castingBreak = false, channeled = false},
    ["Spell Lock"] = {castTime = 0, priority = "D", cooltime = 30, castingBreak = false, channeled = false},
    ["Seduction"] = {castTime = 1.5, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Devour Magic"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Consume Shadows"] = {castTime = 10, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Tainted Blood"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false},
    ["Sacrifice"] = {castTime = 0, priority = "D", cooltime = 0, castingBreak = false, channeled = false}
}

xeon_stance_date = {
    ["Warrior"] = {
        ["Charge"] = {"Battle Stance"},
        ["Hamstring"] = {"Battle Stance", "Berserker Stance"},
        ["Mocking Blow"] = {"Battle Stance"},
        ["Overpower"] = {"Battle Stance"},
        ["Rend"] = {"Battle Stance"},
        ["Retaliation"] = {"Battle Stance"},
        ["Thunder Clap"] = {"Battle Stance"},
        ["Intercept"] = {"Berserker Stance"},
        ["Pummel"] = {"Berserker Stance"},
        ["Recklessness"] = {"Berserker Stance"},
        ["Whirlwind"] = {"Berserker Stance"},
        ["Disarm"] = {"Defensive Stance"},
        ["Revenge"] = {"Defensive Stance"},
        ["Shield Bash"] = {"Battle Stance", "Defensive Stance"},
        ["Shield Block"] = {"Defensive Stance"},
        ["Shield Wall"] = {"Defensive Stance"},
        ["Taunt"] = {"Defensive Stance"},
        ["Berserker Rage"] = {"Berserker Stance"},
        ["Execute"] = {"Battle Stance", "Berserker Stance"},
        ["Sweeping Strikes"] = {"Battle Stance"}
    },
    ["Druid"] = {}
}
