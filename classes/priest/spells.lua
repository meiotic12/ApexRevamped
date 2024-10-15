local Unlocker, awful, apex = ...

if awful.player.class2 ~= "PRIEST" then return end

local priest = apex.priest.base

local player = awful.player
local Spell, Item = awful.Spell, awful.Item

awful.Populate({
    AngelicFeather = Spell(121536),
    DesperatePrayer = Spell(19236),
    DispelMagic = Spell(5282),
    Fade = Spell(586, { ignoreGCD = true, ignoreCasting = true, ignoreChanneling = true }),
    FlashHeal = Spell(2061, { heal = true, targeted = true }),
    Halo = Spell(120517, { heal = true }),
    HolyNova = Spell(132157),
    LeapOfFaith = Spell(73325),
    Levitate = Spell(1706),
    MassDispel = Spell(32375, { radius = 13.5, ignoreFacing = true }),
    MindBlast = Spell(8092, { damage = "magic" }),
    MindControl = Spell(605),
    MindGames = Spell(375901, { damage = "magic" }),
    PowerInfusion = Spell(10060, { beneficial = true }),
    PowerWordFortitude = Spell(21562),
    PowerWordLife = Spell(373481, { heal = true }),
    PowerWordShield = Spell(17, { beneficial = true }),
    PrayerOfMending = Spell(33076, { heal = true }),
    PsychicScream = Spell(8122, { ignoreFacing = true, ignoreCasting = true, ignoreChanneling = true }),
    Renew = Spell(139, { heal = true }),
    ShadowWordDeath = Spell(32379, { ignoreCasting = true, ignoreChanneling = true }),
    ShadowWordPain = Spell(589, { damage = "magic", targeted = true }),
    ShadowFiend = Spell(34433, { damage = "magic" }),
    Smite = Spell(585, { damage = "magic", targeted = true }),
    VoidShift = Spell(108968, { beneficial = true, ignoreCasting = true, ignoreChanneling = true }),
    VoidTendrils = Spell(108920),
    Purify = Spell(527, { beneficial = true }),

    -- ITEMS --
    HealthStone = Item(5512),

    -- Racials --
    Shadowmeld = Spell(58984, { ignoreCasting = true, ignoreChanneling = true, ignoreGCD = true, ignoreMoving = false }),
}, priest, getfenv(1))

PowerWordFortitude:Callback("default", function(spell, delay)
    if player.buff(spell.name) then return end
    
    return apex.DelayedCast(spell, 1.5, spellTarget)
end)