local Unlocker, awful, apex = ...

if awful.player.class2 ~= "PRIEST" then return end

local priest = apex.priest.base

local player = awful.player

priest.Fade:Callback("fadeSpells", function(spell)
    awful.enemies.loop(function(unit)
        if not unit.casting then return end
        
        if not apex.fadeSpellsToDodge[unit.casting] then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > .4 + awful.buffer then return end

        return spell:Cast()
    end)
end)

priest.Fade:Callback("swdSpells", function(spell)
    if apex.holdGCD then return end
    if player.used(priest.ShadowWordDeath, 1) then return end
    if priest.ShadowWordDeath.cd < player.gcdRemains + .1 then return end
    if player.lastCast == priest.ShadowWordDeath.id then return end

    awful.enemies.loop(function(unit)
        if not unit.casting then return end
        if priest.ShadowWordDeath.cd < unit.castRemains then return end

        if not apex.swdSpellsToDodge[unit.casting] then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > .4 + awful.buffer then return end

        return spell:Cast()
    end)
end)

priest.Shadowmeld:Callback("fadeSpells", function(spell)
    if priest.Fade.cd == 0 then return end
    if player.used(priest.Fade, .5) then return end
    if player.lastCast == priest.Fade.id then return end

    awful.enemies.loop(function(unit)
        if not unit.casting then return end
        if priest.Fade.cd < unit.castRemains then return end

        if not apex.fadeSpellsToDodge[unit.casting] then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > .4 + awful.buffer then return end

        awful.call("SpellStopCasting")
        SpellStopCasting()
        awful.controlMovement(.2)

        return spell:Cast()
    end)
end)

priest.Shadowmeld:Callback("swdSpells", function(spell)
    if apex.holdGCD then return end
    if priest.Fade.cd == 0 then return end
    if priest.ShadowWordDeath.cd < player.gcdRemains + .1 then return end
    if player.used(priest.Fade, 1) then return end
    if player.used(priest.ShadowWordDeath, 1) then return end
    if player.lastCast == priest.Fade.id then return end
    if player.lastCast == priest.ShadowWordDeath.id then return end

    awful.enemies.loop(function(unit)
        if not unit.casting then return end
        if priest.Fade.cd < unit.castRemains then return end
        if priest.ShadowWordDeath.cd < unit.castRemains then return end

        if not apex.swdSpellsToDodge[unit.casting] then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > .4 + awful.buffer then return end

        awful.call("SpellStopCasting")
        SpellStopCasting()
        awful.controlMovement(.2)

        return spell:Cast()
    end)
end)

priest.ShadowWordDeath:Callback("dodge", function(spell)
    apex.holdGCD = false

    local castingUnit = nil

    awful.enemies.loop(function(unit)
        if not apex.swdSpellsToDodge[unit.casting] then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > awful.gcd + awful.buffer then return end

        castingUnit = unit
        apex.holdGCD = true
    end)

    if not apex.holdGCD then return end
    if not castingUnit then return end

    awful.enemies.loop(function(unit)
        if unit.bcc then return end
        if castingUnit.castRemains > .4 + awful.buffer then return end

        awful.call("SpellStopCasting")
        awful.call("SpellStopCasting")
        SpellStopCasting()
        SpellStopCasting()

        return spell:Cast(unit)
    end)
end)