local Unlocker, awful, apex = ...

if (GetSpecialization() ~= 3 and awful.player.class2 == "EVOKER") or (awful.player.class2 ~= "EVOKER") then return end

local evoker = apex.evoker.base
local augmentation = apex.evoker.augmentation

local player = awful.player

augmentation:Init(function()

    if not apex.settings.enable then return end
    if apex.actorCheck() then return end

    -- Buffs --
    evoker.SourceOfMagic("default")
    evoker.BlessingOfTheBronze("buff")
    -- End Buffs --

    evoker.Rescue("default")
    evoker.VerdantEmbrace("default")
    evoker.EmeraldBlossom("default")

    evoker.Quell("kick")
    evoker.Expunge("default")

    augmentation.BlisteringScales("default")
    augmentation.Prescience("default")
    -- augmentation.Prescience("tank")

    if not target then return end
    if target.dead then return end
    if target.friendly then return end

    apex.empowerRelease(evoker.FireBreath, 1)
    apex.empowerRelease(augmentation.Upheaval, augmentation.UpheavalStage)
    
    augmentation.BreathOfEons("default")
    augmentation.EbonMight("default")
    evoker.TipTheScales("default")
    evoker.FireBreath("TipTheScales")
    augmentation.Upheaval("default")
    evoker.FireBreath("default")
    -- evoker.Hover("default")
    augmentation.Eruption("default")
    evoker.LivingFlame("default")
    evoker.AzureStrike("default")

end, .10)