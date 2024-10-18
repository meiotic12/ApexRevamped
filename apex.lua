local Unlocker, awful, apex = ...

print("Apex loaded")

awful.DevMode = true
awful.enabled = true
awful.ttd_enabled = true

apex.base = {}

apex.evoker = {}
apex.evoker.base = {}
apex.evoker.augmentation = awful.Actor:New({ spec = 3, class = "evoker" })

apex.priest = {}
apex.priest.base = {}
apex.priest.discipline = awful.Actor:New({ spec = 1, class = "priest" })

awful.apex = apex