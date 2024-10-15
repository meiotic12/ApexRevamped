local Unlocker, awful, apex = ...

local player = awful.player

apex.empoweredStage = 0

awful.onUpdate(function()
    local stage = 0
    local name, _, _, startTimeMS, _, _, _, spellID, _, numStages = UnitChannelInfo(player.pointer)
    if name then
        local startTime = startTimeMS
        local currentTime = GetTime() * 1000
        local stageDuration = 0
        for i = 1, numStages do
            local currentStageDuration = GetUnitEmpowerStageDuration(player.pointer, i - 1)
            stageDuration = stageDuration + currentStageDuration
            if startTime + stageDuration > currentTime then
                break
            end
            stage = i
        end
    end

    apex.empoweredSpellId = spellID
    apex.empoweredStage = stage
end)

apex.castCheck = {}
awful.onUpdate(function()
    if player.casting then 
        apex.castCheck[player.castID] = awful.time
    end

    for _, time in pairs(apex.castCheck) do
        if awful.time - time > awful.latency then
            apex.castCheck[player.castID] = nil
        end
    end
end)