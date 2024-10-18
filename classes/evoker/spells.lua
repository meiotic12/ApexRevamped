local Unlocker, awful, apex = ...

if awful.player.class2 ~= "EVOKER" then return end

print("Evoker spells loaded")

local evoker = apex.evoker.base
local augmentation = apex.evoker.augmentation

local player, target, healer = awful.player, awful.target, awful.healer
local Spell, Item = awful.Spell, awful.Item

apex.empowerRelease = function(spell, stage)
    if apex.empoweredSpellId ~= spell.id then return end
    if apex.empoweredStage < stage then return end

    CastSpellByName(spell.name)
end

awful.Populate({

    AzureStrike = Spell(362969, { ignoreMoving = true, ignoreCasting = true }),
    BlessingOfTheBronze = Spell(364342),
    CauterizingFlame = Spell(374251, { ignoreCasting = true, beneficial = true }),
    EmeraldBlossom = Spell(355913, { beneficial = true, radius = 10, ignoreMoving = true, ignoreCasting = true }),
    Expunge = Spell(365585, { beneficial = true }),
    FireBreath = Spell(357208, { ignoreMoving = false }),
    Hover = Spell(358267, { ignoreMoving = true, ignoreCasting = true, ignoreGCD = true }),
    LivingFlame = Spell(361469, { ignoreMoving = function() if player.buff(358267) then return true else return false end end }),
    ObsidianScales = Spell(363916, { ignoreGCD = true}),
    OppressingRoar = Spell(373048),
    Quell = Spell(351338, { ignoreCasting = true, ignoreGCD = true }),
    RenewingFlame = Spell(374348),
    Rescue = Spell(370665, { beneficial = true }),
    SleepWalk = Spell(360806, { ignoreMoving = function() if player.buff(358267) then return true else return false end end }),
    SourceOfMagic = Spell(369459),
    TipTheScales = Spell(370553),
    VerdantEmbrace = Spell(360995, { beneficial = true, ignoreMoving = true, ignoreCasting = true }),

}, evoker, getfenv(1))

AzureStrike:Callback("default", function(spell)
    if not player.moving then return end
    if player.buff(358267) then return end -- HOVER
    if not apex.DamageCastCheck(spell, target) then return end
    return apex.PvECast(spell, target)
end)

BlessingOfTheBronze:Callback("buff", function(spell)
    if player.buff(spell.name) then return end

    return apex.DelayedCast(spell, 1.5, player)
end)

EmeraldBlossom:Callback("default", function(spell)
    awful.fgroup.loop(function(unit)
        if unit.dead then return end
        if unit.hp > 50 then return end

        return apex.PvECast(spell, unit)
    end)
end)

Expunge:Callback("default", function(spell)
    awful.fgroup.loop(function(unit)
        if unit.dead then return end
        for _, debuff in ipairs(unit.debuffs) do
            local name, dispeltype, id = debuff[1], debuff[4], debuff[10]
            if unit.debuffUptime(name) < .5 then return end
            if dispeltype == "Poison" then
                return apex.PvECast(spell, unit)
            end
        end
    end)
end)

FireBreath:Callback("default", function(spell)
    if player.moving then return end
    if not IsShiftKeyDown() then return end
    if player.buffRemains(augmentation.EbonMight.name) < 2 then return end
    if not apex.DamageCastCheck(spell, target) then return end
    return apex.PvECast(spell)
end)

FireBreath:Callback("TipTheScales", function(spell)
    if player.moving then return end
    if not IsShiftKeyDown() then return end
    if not player.buff(augmentation.EbonMight.name) then return end
    if not player.buff(TipTheScales.name) then return end
    if not apex.DamageCastCheck(spell, target) then return end

    return apex.PvECast(spell)
end)

Hover:Callback("default", function(spell)
    if not player.moving then return end
    if not player.buff(augmentation.EbonMight.name) then return end
    if player.buffRemains(augmentation.EbonMight.name) > 8 then return end
    if player.buff(spell.name) then return end

    return apex.PvECast(spell)
end)

LivingFlame:Callback("default", function(spell)
    if not apex.DamageCastCheck(spell, target) then return end
    return apex.PvECast(spell, target)
end)

Quell:Callback("kick", function(spell)
    if not player.combat then return end
    awful.enemies.loop(function(enemy)
        if not enemy.combat then return end
        if enemy.distance > spell.range then return end
        if not enemy.casting then return end
        if enemy.castInt then return end
        if enemy.castPct < (apex.pveKickDelay.now * 100) then return end

        return apex.PvECast(spell, enemy)
    end)
end)

Rescue:Callback("default", function(spell)
    if not player.combat then return end
    awful.group.loop(function(unit)
        if unit.dead then return end
        if unit.hp > 40 then return end
        if unit.los then return end
        if unit.distance > spell.range then return end

        local x, y, z = unit.position()
        if apex.PveAoE(spell, x,y,z) then
            return apex.PvECast(spell, unit)
        end
    end)
end)

SourceOfMagic:Callback("default", function(spell)
    if not healer then return end
    if healer.buff(spell.name) then return end

    return apex.DelayedCast(spell, 1.5, healer)
end)

TipTheScales:Callback("default", function(spell)
    if not IsShiftKeyDown() then return end
    if not player.buff(augmentation.EbonMight.name) then return end
    if FireBreath.cd - player.gcdRemains > .1 then return end
    if not player.combat then return end
    return apex.PvECast(spell)
end)

VerdantEmbrace:Callback("default", function(spell)
    awful.fgroup.loop(function(unit)
        if unit.dead then return end
        if unit.hp > 30 then return end

        return apex.PvECast(spell, unit)
    end)
end)