local Unlocker, awful, apex = ...

if awful.player.class2 ~= "PRIEST" then return end

local priest = apex.priest.base

local player = awful.player

priest.DispelMagic:Callback("priority", function(spell, unit)
    if unit.purgeCount > 7 then return end

    for _, spellToSearch in ipairs(apex.purgeListHighPrio) do
        if unit.buff(spellToSearch) then
            if unit.buffUptime(spellToSearch) > .2 then
                return spell:Cast(unit)
            end
        end
    end
end)

priest.MassDispel:Callback("immunities", function(spell, unit)
    if unit.debuff("unstable affliction") then return end
    if unit.debuff("vampiric touch") then return end

    if unit.class2 == "MAGE" then
        if unit.buffUptime("ice block") < .2 then return end
        return spell:SmartAoE(unit)
    end

    if unit.class2 == "PALADIN" then
        if unit.buffUptime("divine shield") < .2 then return end
        return spell:SmartAoE(unit)
    end        
end)