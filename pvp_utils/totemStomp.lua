local Unlocker, awful, apex = ...

apex.totemStomp = function(smallSpell, bigSpell)
    awful.units.loop(function(unit)
        if unit.friendly 
        or unit.uptime < .5 then return end

        if apex.totemList[unit.id] then
            local canCastSmall = smallSpell:Castable(unit)
            local canCastBig = bigSpell:Castable(unit)

            if unit.health < 7000 and canCastSmall then
                return smallSpell:Cast(unit)
            elseif canCastBig then
                return bigSpell:Cast(unit)
            end
        end
    end)
end