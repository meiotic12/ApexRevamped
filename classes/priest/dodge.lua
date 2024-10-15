local Unlocker, awful, apex = ...

if awful.player.class2 ~= "PRIEST" then return end

local priest = apex.priest.base

local player = awful.player

priest.Fade:Callback("fadeSpells", function(spell)
    if apex.holdGCD then return end

    awful.enemies.loop(function(unit)
        if apex.holdGCD then return end
        if not unit.casting then return end
        
        if not apex.fadeSpellsToDodge[unit.casting] then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > awful.latency + awful.buffer then return end

        return spell:Cast()
    end)
end)

priest.Fade:Callback("swdSpells", function(spell)
    if apex.holdGCD then return end
    if player.used(priest.ShadowWordDeath, .5) then return end

    awful.enemies.loop(function(unit)
        if (priest.ShadowWordDeath.cd - player.gcdRemains) < unit.castRemains then return end

        if not apex.swdSpellsToDodge[unit.casting] then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > awful.latency + awful.buffer then return end

        return spell:Cast()
    end)
end)

base.Shadowmeld:Callback("fadeSpells", function(spell)
    if apex.holdGCD then return end
    if player.used(priest.Fade, .5) then return end

    awful.enemies.loop(function(unit)
        if (priest.Fade.cd - player.gcdRemains) < unit.castRemains then return end

        if not apex.fadeSpellsToDodge[unit.casting] then return end
        if not unit.casting then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > awful.latency + awful.buffer then return end

        awful.call("SpellStopCasting")
        SpellStopCasting()
        awful.controlMovement(.2)

        return spell:Cast()
    end)
end)

base.Shadowmeld:Callback("swdSpells", function(spell)
    if apex.holdGCD then return end
    if player.used(priest.Fade, .5) then return end
    if player.used(priest.ShadowWordDeath, .5) then return end

    awful.enemies.loop(function(unit)
        if (priest.Fade.cd - player.gcdRemains) < unit.castRemains then return end
        if (priest.ShadowWordDeath.cd - player.gcdRemains) < unit.castRemains then return end

        if not apex.swdSpellsToDodge[unit.casting] then return end
        if not unit.casting then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > awful.latency + awful.buffer then return end

        awful.call("SpellStopCasting")
        SpellStopCasting()
        awful.controlMovement(.2)

        return spell:Cast()
    end)
end)

priest.ShadowWordDeath:Callback("holdGCD", function(spell)
    apex.holdGCD = false

    awful.enemies.loop(function(unit)
        if not apex.swdSpellsToDodge[unit.casting] then return end
        if not unit.castTarget.isUnit(player) then return end
        if not unit.los then return end
        if unit.castRemains > awful.gcd + awful.buffer then return end

        awful.call("SpellStopCasting")
        awful.call("SpellStopCasting")
        SpellStopCasting()
        SpellStopCasting()

        apex.holdGCD = true
    end)
end)

priest.ShadowWordDeath:Callback("swdSpells", function(spell)
    if not apex.holdGCD then return end

    awful.enemies.loop(function(unit)
        if unit.bcc then return end

        return spell:Cast(unit)
    end)
end)