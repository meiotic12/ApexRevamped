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

    priest.ShadowWordDeath("dodge")
    priest.Fade("fadeSpells")
    priest.Fade("swdSpells")
    priest.Shadowmeld("fadeSpells")
    priest.Shadowmeld("swdSpells")

    if apex.holdGCD then return end

    if apex.sortedFriendlies and apex.sortedFriendlies[1] and apex.sortedFriendlies[1].hp > 30 then
        apex.totemStomp(PurgeTheWicked, priest.Smite)
    end

    if apex.sortedFriendlies and apex.sortedFriendlies[1]then
        if apex.sortedFriendlies[1].hp > 30 then
            apex.sortedFriendlies.loop(function(unit)
                priest.Purify("dispel", unit)
            end)
            priest.PowerInfusion("smart")
        end
    end

    if apex.sortedEnemies and apex.sortedFriendlies and apex.sortedFriendlies[1] then
        if apex.sortedFriendlies[1].hp > 30 then
            apex.sortedEnemies.loop(function(unit)
                priest.MassDispel("immunities", unit)
            end)
        end
    end

    priest.VoidShift("self")
    priest.DesperatePrayer("self")
    base.HealthStone()
    if apex.sortedFriendlies then
        apex.sortedFriendlies.loop(function(unit)
            priest.VoidShift("lowHealthFriend", unit)
            discipline.Rapture("cooldowns", unit)
            discipline.Rapture("lowHp", unit)
            discipline.PowerWordBarrier("lowHp", unit)
            discipline.PowerWordBarrier("cooldowns", unit)
            discipline.Rapture("doubleMelee", unit)
            discipline.PainSuppression("lowHp", unit)
            discipline.PainSuppression("cooldowns", unit)
        end)
    end

    if apex.sortedFriendlies then
        apex.sortedFriendlies.loop(function(unit)
            priest.PowerWordLife("heal", unit)
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
end, .10)

