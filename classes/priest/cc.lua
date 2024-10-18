local Unlocker, awful, apex = ...

if awful.player.class2 ~= "PRIEST" then return end

local priest = apex.priest.base

local player, enemyHealer = awful.player, awful.enemyHealer

priest.PsychicScream:Callback("enemyHealer", function(spell)
    if not enemyHealer then return end
    if enemyHealer.fearDR < .5 then return end
    if enemyHealer.distance > 8 then return end
    if enemyHealer.bccr > player.gcdRemains + awful.buffer then return end
    if enemyHealer.ccr > player.gcdRemains + awful.buffer then return end

    if enemyHealer.used(priest.Fade.id, 1) then return end
    if enemyHealer.used(priest.ShadowWordDeath.id, 1) then return end

    awful.call("SpellStopCasting")
    SpellStopCasting()

    return spell:Cast()
end)
