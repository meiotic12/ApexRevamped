local Unlocker, awful, apex = ...

local player = awful.player

apex.DamageCastCheck = function(spell, target)
    if apex.castCheck[player.castID] then return false end
    if not target.exists then return false end
    if not target.enemy then return false end

    return true
end

apex.DelatedCast = function(spell, delay, target)
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