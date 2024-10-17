local Unlocker, awful, apex = ...

local player, enemyHealer = awful.player, awful.enemyHealer

apex.TremorCheck = function()
    awful.totems.loop(function(totem)
        if totem.friend then return end
        if totem.id == 5913 or totem.id == 5925 then
            return true
        else
            return false
        end
    end)
end

apex.eatSpellReflect = function(spell, unit)
    if not unit.buff(apex.buffId.spellReflect) then return end

    return spell:Cast(unit)
end

local healerLockouts = {
    ["DRUID"] = "nature",
    ["PRIEST"] = "holy",
    ["PALADIN"] = "holy",
    ["SHAMAN"] = "nature",
    ["MONK"] = "nature",
    ["EVOKER"] = "nature"
}

apex.CheckHealerLocked = function()
    if not awful.arena then return end
    if not enemyHealer.exists then return end

    if healerLockouts[enemyHealer.class2] then
        local lockoutSchool = healerLockouts[enemyHealer.class2]

        if enemyHealer.lockouts[lockoutSchool] then
            return true
        else
            return false
        end
    else
        return false
    end
end