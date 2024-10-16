local Unlocker, awful, apex = ...

if awful.player.class2 ~= "PRIEST" then return end

local priest = apex.priest.base

local player = awful.player

apex.piClasses = {
    "PALADIN",
    "WARLOCK",
    "DRUID",
    "MAGE",
    "EVOKER",
    "DEATHKNIGHT",
    "WARRIOR",
    "HUNTER",
    "DEMONHUNTER",
    "MONK",
    "ROGUE",
    "PRIEST",
}

priest.PowerInfusion:Callback("smart", function(spell)
    if not apex.sortedFriendlies then return end

    local currentClassIndex = 100
    local piTarget = nil

    apex.sortedFriendlies.loop(function(unit)
        for key, value in ipairs(apex.piClasses) do
            if value == unit.class2 then
                if key < currentClassIndex then
                    currentClassIndex = key
                    piTarget = unit
                end
            end
        end
    end)

    if not piTarget then return end
    if not piTarget.cds then return end

    return spell:Cast(piTarget)
end)