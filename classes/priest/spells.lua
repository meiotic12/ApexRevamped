local Unlocker, awful, apex = ...

if awful.player.class2 ~= "PRIEST" then return end

local priest = apex.priest.base
local discipline = apex.priest.discipline

local player = awful.player
local Spell, Item = awful.Spell, awful.Item

awful.Populate({
    AngelicFeather = Spell(121536),
    DesperatePrayer = Spell(19236, { ignoreGCD = true, ignoreCasting = true, ignoreChanneling = true }),
    DispelMagic = Spell(5282, { effect = "magic" }),
    Fade = Spell(586, { ignoreGCD = true, ignoreCasting = true, ignoreChanneling = true }),
    FlashHeal = Spell(2061, { heal = true, targeted = true }),
    Halo = Spell(120517, { heal = true }),
    HolyNova = Spell(132157),
    InnerLight = Spell(355897),
    InnerShadow = Spell(355898),
    LeapOfFaith = Spell(73325, { beneficial = true }),
    Levitate = Spell(1706),
    MassDispel = Spell(32375, { radius = 13.5, ignoreFacing = true }),
    MindBlast = Spell(8092, { damage = "magic" }),
    MindControl = Spell(605, { cc = "charm", effect = "magic" }),
    MindGames = Spell(375901, { damage = "magic" }),
    PowerInfusion = Spell(10060, { beneficial = true }),
    PowerWordFortitude = Spell(21562),
    PowerWordLife = Spell(373481, { heal = true }),
    PowerWordShield = Spell(17, { beneficial = true }),
    PrayerOfMending = Spell(33076, { heal = true }),
    Premonition = Spell(428924, { ignoreCasting = true, ignoreGCD = true }),
    PremonitionOfInsight = Spell(428933, { ignoreCasting = true, ignoreGCD = true }),
    PremonitionOfPiety = Spell(428930, { ignoreCasting = true, ignoreGCD = true }),
    PremonitionOfSolace = Spell(428934, { ignoreCasting = true, ignoreGCD = true }),
    PremonitionOfClairvoyance = Spell(440725, { ignoreCasting = true, ignoreGCD = true }),
    PsychicScream = Spell(8122, { cc = "fear", effect = "magic", ignoreFacing = true, ignoreCasting = true }),
    Purify = Spell(527, { beneficial = true }),
    Renew = Spell(139, { heal = true }),
    ShadowWordDeath = Spell(32379, { ignoreCasting = true, ignoreChanneling = true }),
    ShadowWordPain = Spell(589, { damage = "magic", targeted = true }),
    ShadowFiend = Spell(34433, { damage = "magic" }),
    Smite = Spell(585, { damage = "magic", targeted = true }),
    VoidShift = Spell(108968, { beneficial = true, ignoreCasting = true, ignoreChanneling = true, ignoreGCD = true }),
    VoidTendrils = Spell(108920),

    -- ITEMS --
    HealthStone = Item(5512),

    -- Racials --
    Shadowmeld = Spell(58984, { ignoreCasting = true, ignoreChanneling = true, ignoreGCD = true, ignoreMoving = false }),
}, priest, getfenv(1))

DesperatePrayer:Callback("self", function(spell)
    if player.hp > 30 then return end

    local total, melee, ranged, cooldowns = player.v2attackers()
    if total == 0 then return end

    return spell:Cast()
end)

FlashHeal:Callback("surgeOfLight", function(spell, unit)
    if not player.buff(apex.buffId.surgeOfLight) then return end
    if not apex.HealCastCheck(spell, unit) then return end
    if player.hp > 90 then return end

    return spell:Cast(unit)
end)

FlashHeal:Callback("fromDarknessComesLight", function(spell, unit)
    if player.buffStacks(apex.buffId.fromDarknessComesLight) < 15 then return end
    if unit.hp > 70 then return end
    if not apex.HealCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

FlashHeal:Callback("filler", function(spell, unit)
    if unit.hp > 40 then return end
    if not apex.HealCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

InnerLight:Callback("buff", function(spell, delay)
    if player.buff(spell.name) then return end

    return apex.DelayedCast(spell, 1.5, spellTarget)
end)

MindBlast:Callback("damage", function(spell, unit)
    if not apex.PvPDamageCastCheck(spell, unit) then return end
    if not apex.PvPMagicCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

PowerWordFortitude:Callback("buff", function(spell, delay)
    if player.buff(spell.name) then return end
    
    return apex.DelayedCast(spell, 1.5, spellTarget)
end)

PowerWordLife:Callback("heal", function(spell, unit)
    if not apex.HealCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

PowerWordShield:Callback("rapture", function(spell, unit)
    if not player.buff(apex.buffId.rapture) then return end
    if unit.buff(spell.name) then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if total == 0 then return end

    if not apex.HealCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

PowerWordShield:Callback("heal", function(spell, unit)
    if unit.buff(spell.name) then return end
    if unit.hp > 80 then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if total == 0 then return end

    if not apex.HealCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

PremonitionOfInsight:Callback("penance", function(spell)
    if not player.combat then return end
    if discipline.Penance.cd > player.gcdRemains + .1 then return end

    return Premonition:Cast()
end)

PremonitionOfInsight:Callback("powerWordShield", function(spell)
    if not player.combat then return end
    if PowerWordShield.cd > player.gcdRemains + .1 then return end

    return Premonition:Cast()
end)

PremonitionOfPiety:Callback("lowHp", function(spell, unit)
    if not player.combat then return end
    if unit.hp > 60 then return end

    return Premonition:Cast()
end)

PremonitionOfPiety:Callback("maxCharges", function(spell)
    if not player.combat then return end
    if Premonition.charges < 2 then return end

    return Premonition:Cast()
end)

PremonitionOfSolace:Callback("default", function(spell, unit)
    if not player.combat then return end
    if unit.hp > 60 then return end

    return Premonition:Cast()
end)

PremonitionOfClairvoyance:Callback("default", function(spell, unit)
    if not player.combat then return end
    if unit.hp > 60 then return end

    return Premonition:Cast()
end)

Renew:Callback("filler", function(spell, unit)
    if awful.prep then return end
    if not awful.arena then return end
    if not player.moving then return end
    if unit.buff(spell.name) then return end
    if unit.buff(apex.buffId.atonement) then return end
    if not apex.HealCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

ShadowFiend:Callback("mana", function(spell, unit)
    if player.manaPct > 85 then return end

    return spell:Cast(unit)
end)

ShadowWordDeath:Callback("snipe", function(spell, unit)
    if unit.hp > 10 then return end
    if not apex.PvPDamageCastCheck(spell, unit) then return end
    if not apex.PvPMagicCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

Smite:Callback("damage", function(spell, unit)
    if not apex.PvPDamageCastCheck(spell, unit) then return end
    if not apex.PvPMagicCastCheck(spell, unit) then return end

    return spell:Cast(unit)
end)

VoidShift:Callback("lowHealthFriend", function(spell, unit)
    if unit.hp > 18 then return end

    local total, melee, ranged, cooldowns = unit.v2attackers()
    if total == 0 then return end

    if not apex.HealCastCheck(spell, unit) then return end

    awful.call("SpellStopCasting")
    awful.call("SpellStopCasting")
    SpellStopCasting()
    SpellStopCasting()

    return spell:Cast(unit)
end)

VoidShift:Callback("self", function(spell)
    if player.hp > 18 then return end

    local total, melee, ranged, cooldowns = player.v2attackers()
    if total == 0 then return end

    local sorted = awful.group.sort(function(a, b) return a.hp > b.hp end)

    sorted.loop(function(unit)
        if not apex.HealCastCheck(spell, unit) then return end

        awful.call("SpellStopCasting")
        awful.call("SpellStopCasting")
        SpellStopCasting()
        SpellStopCasting()

        return spell:Cast(unit)
    end)
end)