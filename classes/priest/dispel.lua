local Unlocker, awful, apex = ...

if awful.player.class2 ~= "PRIEST" then return end

local priest = apex.priest.base

local player = awful.player

priest.Purify:Callback("dispel", function(spell, unit)
    if unit.debuff("unstable affliction") then return end
    if unit.debuff("vampiric touch") then return end

    for _, spellToSearch in ipairs(apex.dispelList) do
        if not unit.debuff(spellToSearch) then return end
        if unit.debuffUptime(spellToSearch) < .7 then return end

        return spell(unit)
    end
end)
