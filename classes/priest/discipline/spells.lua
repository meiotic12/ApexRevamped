local Unlocker, awful, apex = ...

if (GetSpecialization() ~= 1 and awful.player.class2 == "PRIEST") or (awful.player.class2 ~= "PRIEST") then return end

local priest = apex.priest.base
local discipline = apex.priest.discipline

local player = awful.player
local Spell = awful.Spell

awful.Populate({
    divineStar = Spell(110744, { damage = "magic" }),
    mindBender = Spell(123040, { damage = "magic" }),
    painSuppression = Spell(33206, { beneficial = true, ignoreControl = true }),
    penance = Spell(47540, { damage = "magic", heal = true }),
    powerWordBarrier = Spell(62618, { radius = 8, ignoreFacing = true }),
    powerWordRadiance = Spell(194509, { heal = true }),
    powerWordSolace = Spell(129250),
    purgeTheWicked = Spell(204197, { damage = "magic" }),
    rapture = Spell(47536),
    schism = Spell(214621),
    shadowCovenant = Spell(314867),
    ultimatePenitence = Spell(421453),
    innerLight = Spell(355897),
    innerShadow = Spell(355898),
    darkArchangel = Spell(197871)
}, disc, getfenv(1))