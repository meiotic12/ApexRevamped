local Unlocker, awful, apex = ...

if (GetSpecialization() ~= 3 and awful.player.class2 == "EVOKER") or (awful.player.class2 ~= "EVOKER") then return end

local evoker = apex.evoker.base
local augmentation = apex.evoker.augmentation

local player, target, tank, healer = awful.player, awful.target, awful.tank, awful.healer
local Spell, Item = awful.Spell, awful.Item

awful.Populate({

    BlisteringScales = Spell(360827, { beneficial = true }),
    BreathOfEons = Spell(403631),
    EbonMight = Spell(395152, { ignoreMoving = function() if player.buff(358267) then return true else return false end end }),
    Eruption = Spell(395160, { ignoreMoving = function() if player.buff(358267) then return true else return false end end }),
    Prescience = Spell(409311, { beneficial = true }),
    Upheaval = Spell(396286, { ignoreMoving = false }),

}, augmentation, getfenv(1))

BlisteringScales:Callback("default", function(spell)
    if not tank then return end
    if not tank.combat then return end
    if tank.buffStacks(spell.name) > 2 then return end

    return apex.PvECast(spell, tank)
end)

BreathOfEons:Callback("default", function(spell)
    if not IsAltKeyDown() then return end

    if target.distance <= 15 then
        -- Calculate a point 15 yards in front of the player
        local x, y, z = player.position()
        local playerFacing = player.rotation
        local distance = 20
    
        local projectedX = x + distance * math.cos(playerFacing)
        local projectedY = y + distance * math.sin(playerFacing)
        local _, _, z = target.position()
        local projectedPoint = { x = projectedX, y = projectedY,  z = z}
    
        -- Use the projected point for AoE cast
        return apex.PveAoE(spell, projectedX, projectedY, z)
    end

    local x, y, z = target.position()
    apex.PveAoE(spell, x,y,z)
end)

EbonMight:Callback("default", function(spell)
    if not player.combat then return end
    if target.ttd < 7 then return end
    if player.buffRemains(spell.name) > 4 then return end

    return apex.PvECast(spell)
end)

Eruption:Callback("default", function(spell)
    if not player.buff(EbonMight.name) then return end
    if not apex.DamageCastCheck(spell, target) then return end

    return apex.PvECast(spell, target)
end)

Prescience:Callback("default", function(spell)
    local enemiesAround = awful.enemies.around(player, 100)
    if enemiesAround == 0 then return end

    awful.group.loop(function(unit)
        if unit.isTank then return end
        if unit.isHealer then return end
        if unit.dead then return end
        if unit.buffRemains(spell.name) > 3 then return end

        return apex.PvECast(spell, unit)
    end)
end)

Prescience:Callback("tank", function(spell)
    if not player.combat then return end

    local count = 0
    local lowest = 100
    awful.group.loop(function(unit)
        if unit.isTank then return end
        if unit.isHealer then return end
        if unit.dead then return end
        if unit.buff(spell.name) then
            count = count + 1
            if unit.buffRemains(spell.name) < lowest then
                lowest = unit.buffRemains(spell.name)
            end
        end
    end)

    if count >= 2 and spell.charges == 2 then 
        return apex.PvECast(spell, tank)
    end

    if count >= 2 and spell.nextChargeCD < lowest then 
        return apex.PvECast(spell, tank)
    end
end)

augmentation.UpheavalStage = 1
Upheaval:Callback("default", function(spell)
    if player.moving then return end
    if player.buff(evoker.TipTheScales.name) then return end
    if player.buffRemains(augmentation.EbonMight.name) < 2 then return end
    if not apex.DamageCastCheck(spell, target) then return end

    local around1 = awful.enemies.around(target, 3)
    local around2 = awful.enemies.around(target, 6)
    local around3 = awful.enemies.around(target, 9)

    if around3 > around2 then
        augmentation.UpheavalStage = 3
    elseif around2 > around1 then
        augmentation.UpheavalStage = 2
    else
        augmentation.UpheavalStage = 1
    end

    return apex.PvECast(spell, target)
end)