local Unlocker, awful, apex = ...

local player = awful.player

apex.DamageCastCheck = function(spell, unit)
    if apex.castCheck[player.castID] then return false end
    if not unit.exists then return false end
    if not unit.enemy then return false end

    return true
end

apex.PvPDamageCastCheck = function(spell, unit)
    if not apex.DamageCastCheck(spell, unit) then return false end
    if unit.bccRemains > spell.castTime + awful.buffer then return false end
    if unit.immune then return false end

    return true
end

apex.PvPMagicCastCheck = function(spell, unit)
    if player.debuff(apex.buffId.searingGlare) then return false end

    if unit.immuneMagic then return false end

    if unit.buff(215769) then return false end -- Spirit of Redemption
    if unit.buff(421453) then return false end
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

apex.PvECast = function(spell, unit)
    if unit then
        if not spell.inRange(unit) then return false end

        return spell:Cast(unit, { ignoreRange = true })
    end

    return spell:Cast(unit)
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