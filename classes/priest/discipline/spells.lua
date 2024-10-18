local Unlocker, awful, apex = ...

if (GetSpecialization() ~= 1 and awful.player.class2 == "PRIEST") or (awful.player.class2 ~= "PRIEST") then return end

local priest = apex.priest.base
local discipline = apex.priest.discipline

local player = awful.player
local Spell = awful.Spell

awful.Populate({
    DivineStar = Spell(110744, { damage = "magic" }),
    MindBender = Spell(123040, { damage = "magic" }),
    PainSuppression = Spell(33206, { beneficial = true, ignoreControl = true, ignoreGCD = true, ignoreCasting = true, ignoreChanneling = true }),
    Penance = Spell(47540, { damage = "magic", heal = true }),
    PowerWordBarrier = Spell(62618, { radius = 8, ignoreFacing = true }),
    PowerWordRadiance = Spell(194509, { heal = true }),
    PowerWordSolace = Spell(129250),
    PurgeTheWicked = Spell(204197, { damage = "magic" }),
    Rapture = Spell(47536, { beneficial = true }),
    Schism = Spell(214621),
    ShadowCovenant = Spell(314867),
    UltimatePenitence = Spell(421453),
    DarkArchangel = Spell(197871)
}, discipline, getfenv(1))

PainSuppression:Callback("lowHp", function(spell, unit)
    if unit.hp > 40 then return end
    if unit.buff(PowerWordBarrier.name) then return end
    if player.buff(Rapture.name) then return end
    if unit.buff(PainSuppression.name) then return end
    if player.used(PowerWordBarrier, .5) then return end
    if player.used(Rapture, .5) then return end
    if player.used(PainSuppression, .5) then return end

    if not apex.HealCastCheck(spell, unit) then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if total == 0 then return end

    return spell:Cast(unit)
end)

PainSuppression:Callback("cooldowns", function(spell, unit)
    if unit.hp > 60 then return end
    if unit.buff(PowerWordBarrier.name) then return end
    if player.buff(Rapture.name) then return end
    if unit.buff(PainSuppression.name) then return end
    if player.used(PowerWordBarrier, .5) then return end
    if player.used(Rapture, .5) then return end
    if player.used(PainSuppression, .5) then return end

    if not apex.HealCastCheck(spell, unit) then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if cooldowns == 0 then return end

    return spell:Cast(unit)
end)

Penance:Callback("heal", function(spell, unit)
    if unit.hp > 50 then return end
    if not apex.HealCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

Penance:Callback("damage", function(spell, unit)
    if not unit.debuff(discipline.PurgeTheWicked.name) then return end
    if not apex.PvPDamageCastCheck(spell, unit) then return end
    if not apex.PvPMagicCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

PowerWordBarrier:Callback("lowHp", function(spell, unit)
    if unit.hp > 45 then return end
    if unit.buff(PainSuppression.name) then return end
    if player.buff(Rapture.name) then return end
    if player.used(PainSuppression, .5) then return end
    if player.used(Rapture, .5) then return end

    if not apex.HealCastCheck(spell, unit) then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if total == 0 then return end

    return spell:SmartAoE(unit)
end)

PowerWordBarrier:Callback("cooldowns", function(spell, unit)
    if unit.buff(PainSuppression.name) then return end
    if player.buff(Rapture.name) then return end
    if player.used(PainSuppression, .5) then return end
    if player.used(Rapture, .5) then return end

    if not apex.HealCastCheck(spell, unit) then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if cooldowns < 1 then return end

    if unit.hp > (50 + (cooldowns * 15)) then return end

    return spell:SmartAoE(unit)
end)

PowerWordBarrier:Callback("doubleMelee", function(spell, unit)
    if unit.hp > 50 then return end
    if unit.buff(PainSuppression.name) then return end
    if player.buff(Rapture.name) then return end
    if player.used(PainSuppression, .5) then return end
    if player.used(Rapture, .5) then return end

    if not apex.HealCastCheck(spell, unit) then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if melee < 1 then return end

    return spell:SmartAoE(unit)
end)


PowerWordRadiance:Callback("heal", function(spell, unit)
    if player.lastCast == spell.id then return end
    if unit.hp > 50 then return end
    if not apex.HealCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

PurgeTheWicked:Callback("damage", function(spell, unit)
    if unit.debuffRemains(spell.name) > 2 then return end
    if not apex.PvPDamageCastCheck(spell, unit) then return end
    if not apex.PvPMagicCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

Rapture:Callback("cooldowns", function(spell, unit)
    if unit.hp > 80 then return end
    if unit.buff(PainSuppression.name) then return end
    if unit.buff(PowerWordBarrier.name) then return end
    if player.used(PainSuppression, .5) then return end
    if player.used(PowerWordBarrier, .5) then return end

    if not apex.HealCastCheck(spell, unit) then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if cooldowns == 0 then return end

    return spell:Cast(unit)
end)

Rapture:Callback("lowHp", function(spell, unit)
    if unit.hp > 50 then return end
    if unit.buff(PainSuppression.name) then return end
    if unit.buff(PowerWordBarrier.name) then return end
    if player.used(PainSuppression, .5) then return end
    if player.used(PowerWordBarrier, .5) then return end

    if not apex.HealCastCheck(spell, unit) then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if total == 0 then return end

    return spell:Cast(unit)
end)

UltimatePenitence:Callback("damage", function(spell, unit)
    if apex.sortedFriendlies[1] and apex.sortedFriendlies[1].hp < 60 then return end
    if unit.hp > 50 then return end
    if not apex.PvPDamageCastCheck(spell, unit) then return end
    if not apex.PvPMagicCastCheck(spell, unit) then return end

    local cds = false
    apex.sortedFriendlies.loop(function(unit)
        if unit.cds then cds = true end
    end)

    if not cds then return end

    return spell:Cast(unit)
end)