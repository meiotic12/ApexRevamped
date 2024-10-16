local Unlocker, awful, apex = ...

local player = awful.player

apex.DamageCastCheck = function(spell, unit)
    if apex.castCheck[player.castID] then return false end
    if not unit.exists then return false end
    if not unit.enemy then return false end

    return true
end

apex.PvPDamageCastCheck = function(spell, unit)
    -- if not unit.isPlayer then return end
    if not apex.DamageCastCheck(spell, unit) then return false end
    if unit.bcc then return false end
    if unit.immune then return false end

    return true
end

apex.PvPMagicCastCheck = function(spell, unit)
    if unit.immuneMagic then return false end
    if unit.buff(212295) then return false end
    if unit.buff(7121) then return false end

    return true
end

apex.HealCastCheck = function(spell, unit)
    if apex.castCheck[player.castID] then return false end
    if not unit.exists then return false end
    if not unit.friend then return false end
    if unit.dead then return false end
    if unit.immuneHealing then return false end

    return true
end

apex.DelayedCast = function(spell, delay, target)
    if apex.delayedCacheList[spell.name] then
        if GetTime() > apex.delayedCacheList[spell.name].timeToCast
        and spell:Castable(target) then
            local result = spell:Cast(target)
            if result then
                apex.delayedCacheList[spell.name] = nil
                return true
            end
        end
    else
        apex.delayedCacheList[spell.name] = {
            timeToCast = GetTime() + delay
        }
    end
end

apex.PveAoE = function(spell,x,y,z)
    local wasLooking = IsMouselooking()

    if wasLooking then
        MouselookStop()
    end

    CastSpellByName(spell.name, {x,y,z})
    Click(x,y,z)

    if wasLooking then
        MouselookStart()
    end

    return true
end