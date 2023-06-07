hyper = {"alt"}
hs.hotkey.bind(hyper, ',', nil, function() hs.reload() end)
require("remap")

-- window management
local hk = require("hs.hotkey")
local wm = require("window-management")

hk.bind(hyper, 'q', wm.leftHalf)
hk.bind(hyper, 'w', wm.bottomHalf)
hk.bind(hyper, 'e', wm.topHalf)
hk.bind(hyper, 'r', wm.rightHalf)

hk.bind(hyper, 'f', wm.maximizeWindow)
hk.bind(hyper, 'a', wm.centerOnScreen)
hk.bind(hyper, 'b', wm.ToNextScreen)

-- move mouse between window
hk.bind(hyper, 'v', function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    hs.mouse.absolutePosition(center)
end)

-- -- windows switcher
-- windowFilter = hs.window.filter.new()
-- windowFilter:setCurrentSpace(true)
-- switcher = hs.window.switcher.new(windowFilter)
-- hs.window.switcher.ui.showSelectedThumbnail = false
-- hs.window.switcher.ui.showSelectedTitle = false
-- hk.bind("alt",'tab', function()switcher:next()end)
-- hk.bind('alt-shift','tab',function()switcher:previous()end)

-- clipboard tool
hs.loadSpoon("ClipboardTool")
spoon.ClipboardTool:bindHotkeys({toggle_clipboard = {hyper, "c"}})
spoon.ClipboardTool.show_in_menubar = false
spoon.ClipboardTool.show_copied_alert = false
spoon.ClipboardTool:start()

-- app shortcut
hs.hotkey.bind(hyper, "d", function() hs.application.launchOrFocus("Dictionary") end)
hs.hotkey.bind(hyper, "x", function() hs.application.launchOrFocus("Visual Studio Code") end)
hs.hotkey.bind(hyper, "s", function() hs.application.launchOrFocus("Microsoft Edge") end)
hs.hotkey.bind(hyper, "z", function() hs.application.launchOrFocus("Google Chrome") end)
hs.hotkey.bind(hyper, "l", function() hs.application.launchOrFocus("Lark") end)

hs.alert.show("Config loaded")
