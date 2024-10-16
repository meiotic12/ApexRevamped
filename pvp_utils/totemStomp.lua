local Unlocker, awful, apex = ...

apex.totemList = {
    5925, -- Grounding
    53006, -- Spirit link
    105451, -- Counterstrike
    179867, -- Static Field
    119052, -- War Banner
    5913, -- tremor totem
    51485, -- earthgrab totem
    105427, -- skyfury totem
    101398, -- Psyfiend
    107100, -- observer
    179193, -- fel obelisk
    61245, -- capacitor totem  --192058
}

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