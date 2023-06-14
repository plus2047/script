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

hk.bind(hyper, 'a', wm.centerOnScreen)
hk.bind(hyper, 's', wm.ToNextScreen)
hk.bind(hyper, 'f', wm.maximizeWindow)
-- move mouse between window
hk.bind(hyper, 'd', function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
    hs.mouse.absolutePosition(center)
end)

-- app shortcut
hs.hotkey.bind(hyper, "z", function() hs.application.launchOrFocus("Google Chrome") end)
hs.hotkey.bind(hyper, "x", function() hs.application.launchOrFocus("Visual Studio Code") end)
hs.hotkey.bind(hyper, "b", function() hs.application.launchOrFocus("Microsoft Edge") end)
hs.hotkey.bind(hyper, "v", function() hs.application.launchOrFocus("Dictionary") end)
hs.hotkey.bind(hyper, "l", function() hs.application.launchOrFocus("Lark") end)
hs.hotkey.bind(hyper, "t", function() hs.application.launchOrFocus("Microsoft To Do") end)

-- Raycast to replace spotlight
-- Alt+C for clipboard history
-- Contexts for windows switcher

-- -- windows switcher
-- windowFilter = hs.window.filter.new()
-- windowFilter:setCurrentSpace(true)
-- switcher = hs.window.switcher.new(windowFilter)
-- hs.window.switcher.ui.showSelectedThumbnail = false
-- hs.window.switcher.ui.showSelectedTitle = false
-- hk.bind("alt",'tab', function()switcher:next()end)
-- hk.bind('alt-shift','tab',function()switcher:previous()end)

-- -- clipboard tool
-- hs.loadSpoon("ClipboardTool")
-- spoon.ClipboardTool:bindHotkeys({toggle_clipboard = {hyper, "c"}})
-- spoon.ClipboardTool.show_in_menubar = false
-- spoon.ClipboardTool.show_copied_alert = false
-- spoon.ClipboardTool:start()

hs.alert.show("Config loaded")
