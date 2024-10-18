local Unlocker, awful, apex = ...

local player = awful.player

-- General
apex.holdGCD = false
apex.lastUpdate = awful.time
apex.sortedEnemies = nil
apex.sortedFriendlies = nil

-- Combat
apex.kickDelay = awful.delay(0.20, 0.80)
apex.pveKickDelay = awful.delay(0.50, 0.88)

-- Casting
apex.castCheck = {}
apex.delayedCacheList = {}

-- Buff IDs
apex.buffId = {}
apex.buffId.surgeOfLight = 114255
apex.buffId.rapture = 47536
apex.buffId.fromDarknessComesLight = 390617
apex.buffId.atonement = 194384
apex.buffId.searingGlare = 410201
apex.buffId.ultimatePenitence = 421453
apex.buffId.spiritOfRedemption = 215769
apex.buffId.groundingTotem = 8178
apex.buffId.netherWard = 212295
apex.buffId.berserkerRage = 18499
apex.buffId.lichborne = 49039
apex.buffId.antiMagicShell = 48707
apex.buffId.spellReflect = 23920

-- Dispel List
apex.dispelList = {
    'Imprison',
    'Searing Glare',
    'Fel Eruption',
    'Incapacitate',
    'Freezing Trap',
    'Polymorph',
    'Frost Nova',
    'Ring of Frost',
    'Intimidating Shout',
    'Hammer of Justice',
    'Blinding Light',
    'Turn Evil',
    'Repentance',
    'Song of Chi-Ji',
    'Paralysis',
    'Mind Control',
    'Vampiric Touch',
    'Silence',
    'Mindgames',
    'Psychic Scream',
    'Psychic Horror',
    'Lightning Lasso',
    'Hex',
    'Seduction',
    'Fear',
    'Howl of Terror',
    'Seduction',
    'Soul Rot', 
    'Mortal Coil',
    'Asphyxiate',
    'Blinding Sleet',
    'Landslide',
    'Sleep Walk',
    'Chrono Loop',
    'Hibernate',
    'High Winds',
    'Frost Bomb',
}

apex.purgeListHighPrio = {
    'Thorns',
    'Natures Swiftness',
    'Innervate',
    'Soul of the Forest',
    'Power Infusion',
    'Netherward',
    'Blessing of Protection',
    'Blessing of Sanctuary',
    'Heroism',
    'Bloodlust',
    'Combustion',
    'Ice Form',
    'Alter Time',
    378464, -- Nullifying Shroud
}

apex.actorCheck = function()
    if player.mounted then return true end
    if UnitInVehicle("player") then return true end
    if player.dead then return true end
    if player.buff(1131) then return true end -- Eating
    if player.buff(1137) then return true end -- Drinking

    return false
end