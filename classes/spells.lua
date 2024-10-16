local Unlocker, awful, apex = ...

local base = apex.base

local player = awful.player
local Spell, Item = awful.Spell, awful.Item

awful.Populate({
    -- ITEMS --
    HealthStone = Item(5512),

    -- Racials --
    Shadowmeld = Spell(58984, { ignoreCasting = true, ignoreChanneling = true, ignoreGCD = true, ignoreMoving = false }),
}, base, getfenv(1))

HealthStone:Update(function(item)
    if not item:Usable() then return end
    if player.hp > 30 then return end

    return item:Use()
end)