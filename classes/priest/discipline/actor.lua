local Unlocker, awful, apex = ...

if (GetSpecialization() ~= 1 and awful.player.class2 == "PRIEST") or (awful.player.class2 ~= "PRIEST") then return end

local target = awful.target

local base = apex.base
local priest = apex.priest.base
local discipline = apex.priest.discipline

discipline:Init(function()

    if not apex.settings.enable then return end
    if apex.actorCheck() then return end

    if player.channeling == discipline.UltimatePenitence.name then return end
    if player.casting == discipline.UltimatePenitence.name then return end
    if player.channeling == priest.MindControl.name then return end
    if player.casting == priest.MindControl.name then return end

    apex.holdGCD = false

    if priest.ShadowWordDeath("dodge") then return end
    if priest.Fade("fadeSpells") then return end
    if priest.Shadowmeld("fadeSpells") then return end
    if priest.Fade("swdSpells") then return end
    if priest.Shadowmeld("swdSpells") then return end

    if apex.holdGCD then return end

    if apex.sortedFriendlies then
        apex.sortedFriendlies.loop(function(unit)
            priest.VoidShift("lowHealthFriend", unit)
        end)
    end

    if player.casting then return end
    if player.channeling then return end

    if apex.sortedFriendlies and apex.sortedFriendlies[1] and apex.sortedFriendlies[1].hp > 30 then
        apex.totemStomp(PurgeTheWicked, priest.Smite)
    end

    if apex.sortedFriendlies and apex.sortedFriendlies[1]then
        if apex.sortedFriendlies[1].hp > 30 then
            apex.sortedFriendlies.loop(function(unit)
                priest.Purify("dispel", unit)
            end)
        end
        priest.PowerInfusion("smart")
    end

    if apex.sortedEnemies and apex.sortedFriendlies and apex.sortedFriendlies[1] then
        if apex.sortedFriendlies[1].hp > 30 then
            apex.sortedEnemies.loop(function(unit)
                priest.MassDispel("immunities", unit)
                priest.DispelMagic("priority", unit)
            end)
        end
    end

    priest.VoidShift("self")
    priest.DesperatePrayer("self")
    base.HealthStone()
    if apex.sortedFriendlies then
        apex.sortedFriendlies.loop(function(unit)
            discipline.Rapture("cooldowns", unit)
            discipline.Rapture("lowHp", unit)
            discipline.PowerWordBarrier("lowHp", unit)
            discipline.PowerWordBarrier("cooldowns", unit)
            discipline.Rapture("doubleMelee", unit)
            discipline.PainSuppression("lowHp", unit)
            discipline.PainSuppression("cooldowns", unit)
        end)
    end

    if apex.sortedEnemies and apex.sortedFriendlies and apex.sortedFriendlies[1] then
        if apex.sortedFriendlies[1].hp > 30 then
            priest.PsychicScream("enemyHealer")
        end
    end

    if apex.sortedFriendlies then
        apex.sortedFriendlies.loop(function(unit)
            priest.PremonitionOfPiety("lowHp", unit)
            priest.PremonitionOfPiety("maxCharges")
            priest.PremonitionOfInsight("powerWordShield")
            priest.PremonitionOfSolace("default", unit)
            priest.PremonitionOfClairvoyance("default", unit)
            priest.PowerWordLife("heal", unit)
            priest.PremonitionOfInsight("penance")
            discipline.Penance("heal", unit)
            discipline.PowerWordRadiance("heal", unit)
            priest.FlashHeal("surgeOfLight", unit)
            priest.PowerWordShield("rapture", unit)
            priest.PowerWordShield("heal", unit)
            priest.FlashHeal("fromDarknessComesLight", unit)
            priest.FlashHeal("filler", unit)
            priest.Renew("filler", unit)
        end)
    end

    if apex.sortedEnemies then
        apex.sortedEnemies.loop(function(unit)
            apex.eatSpellReflect(discipline.PurgeTheWicked, unit)
            discipline.UltimatePenitence("damage", unit)
            discipline.Penance("damage", unit)
            discipline.PurgeTheWicked("damage", unit)
            priest.ShadowFiend("mana", unit)
            priest.MindBlast("damage", unit)
            priest.ShadowWordDeath("snipe", unit)
            priest.Smite("damage", unit)
        end)
    end

    priest.PowerWordFortitude("buff")
    priest.InnerLight("buff")
end, .02)

