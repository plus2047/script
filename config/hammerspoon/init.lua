-- reload config
hs.alert.show("Config loaded")

local wm = require("window-management")
local ws = require("window-switcher")
local hk = require("hs.hotkey")

hyper = {"alt", "ctrl", "shift", "command"}

-- window management
local function windowBind(hyper, keyFuncTable)
  for key,fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end
hk.bind(hyper, ';', ws.windowFuzzySearch)
windowBind(hyper, {
  f = wm.maximizeWindow,    
  o = wm.centerOnScreen,    
  q = wm.leftHalf,       
  r = wm.rightHalf,     
  e = wm.topHalf,          
  w = wm.bottomHalf,
  b = wm.ToNextScreen
})

-- move mouse
hk.bind(hyper, 'v', function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
 
    hs.mouse.setAbsolutePosition(center)
end)

