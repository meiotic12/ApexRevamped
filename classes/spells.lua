local Unlocker, awful, apex = ...

local base = apex.base

local Spell, Item = awful.Spell, awful.Item

awful.Populate({
    -- ITEMS --
    HealthStone = Item(5512),

    -- Racials --
    Shadowmeld = Spell(58984, { ignoreCasting = true, ignoreChanneling = true, ignoreGCD = true, ignoreMoving = false }),
}, base, getfenv(1))