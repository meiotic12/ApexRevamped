local Unlocker, awful, apex = ...

local base = apex.base

local player, target = awful.player, awful.target
local Spell, Item = awful.Spell, awful.Item

awful.Populate({
    -- ITEMS --
    HealthStone = Item(5512),

    -- Trinkets --
    MadQueensMandate = Item(212454),

    -- Racials --
    Shadowmeld = Spell(58984, { ignoreCasting = true, ignoreChanneling = true, ignoreGCD = true, ignoreMoving = false }),
}, base, getfenv(1))

HealthStone:Update(function(item)
    if not item:Usable() then return end
    if player.hp > 30 then return end

    return item:Use()
end)

MadQueensMandate:Update(function(item)
    if not player.combat then return end
    if not item:Usable() then return end
    if target.hp > 50 then return end

    return item:Use()
end)