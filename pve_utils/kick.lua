local Unlocker, awful, apex = ...

apex.PveKicks = {
    "Resonant Barrage",
    "Horrifying Shrill",
    "Poison Bolt",
    "Silken Restraint",
    "Venom Volley",
    "Silk Binding",
    "Twist Thoughts",
    "Grimweave Blast",
    "Mending Web",
    "Ensnaring Shadow",
    "Abyssal Howl",
    "Silken Shell",
    "Tormenting Beam",
    "Arcing Void",
    "Howling Fear",
    "Censoring Gear",
    "Piercing Wail",
    "Restoring Metals",
    "Harvest Essence",
    "Nourish The Forest",
    "Bramblethorn Coat",
    "Patty Cake",
    "Stimulate Resistance",
    "Stimulate Regeneration",
    "Parasitic Pacification",
    "Consumption",
    "Drain Fluids",
    "Bonemend",
    "Rasping Scream",
    "Repair Flesh",
    "Drain Fluids",
    "Goresplatter",
    "Watertight Shell",
    "Bolstering Shout",
    "Stinky Vomit",
    "Choking Waters",
    "Mass Tremor",
    "Sear Mind"
}

apex.PveKick = function(spell, unit)
    if not unit.casting then return end
    if unit.castPct < (apex.pveKickDelay.now * 100) then return end

    for _, spellName in ipairs(apex.PveKicks) do
        if unit.casting == spellName then
            return apex.PvECast(spell, unit)
        end
    end
end