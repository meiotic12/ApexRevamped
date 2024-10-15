local Unlocker, awful, apex = ...

apex.gui, apex.settings, apex.cmd = awful.UI:New("Apex", {
	cmd = {"Apex"},
	title = "|cFF6eff86Apex Rotations                                    ",
	show = true, -- show on load by default
	width = 300,
	height = 300,
	scale = 1,
	colors = {
		-- color of our ui title in the top left
		title = yellow,
		-- primary is the primary text color
		primary = white,
		-- accent controls colors of elements and some element text in the UI. it should contrast nicely with the background.
		accent = yellow,
		background = dark,
	}
})

apex.gui:Tab("General")

apex.gui.tabs["General"]:Checkbox({
    text = "Spell Notifications",
    var = "spellToasts",
    tooltip = "Will provide a toast notification when a spell is casted.",
    default = true
})

local StatusFrame = apex.gui:StatusFrame({
    colors = {
        background = { 0, 0, 0, 0 },
        enabled = { 30, 240, 255, 1 },
    },
    maxWidth = 500,
    padding = 7,
})

StatusFrame:Button({
    spellID = 453080,
    var = "enable",
    default = true,
    size = 30,
    text = function()
        if apex.settings.enable then
            return "ON"
        else
            return "OFF"
        end
    end
})
