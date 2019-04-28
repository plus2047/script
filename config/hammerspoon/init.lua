-- reload config
hs.alert.show("Config loaded")

local wm = require('window-management')
local hk = require("hs.hotkey")

hyper = {"alt", "ctrl", "shift", "command"}

-- window management
local function windowBind(hyper, keyFuncTable)
  for key,fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end
windowBind(hyper, {
  f = wm.maximizeWindow,    
  o = wm.centerOnScreen,    
  q = wm.leftHalf,       
  r = wm.rightHalf,     
  e = wm.topHalf,          
  w = wm.bottomHalf      
})

-- move mouse
hk.bind(hyper, 'v', function()
    local screen = hs.mouse.getCurrentScreen()
    local nextScreen = screen:next()
    local rect = nextScreen:fullFrame()
    local center = hs.geometry.rectMidPoint(rect)
 
    hs.mouse.setAbsolutePosition(center)
end)
