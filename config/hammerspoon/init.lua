-- reload config
hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "n", function()
  hs.reload()
end)
hs.alert.show("Config loaded")

local wm = require('window-management')
local hk = require "hs.hotkey"

-- window management
local function windowBind(hyper, keyFuncTable)
  for key,fn in pairs(keyFuncTable) do
    hk.bind(hyper, key, fn)
  end
end
windowBind({"alt", "ctrl", "shift", "command"}, {
  f = wm.maximizeWindow,    
  o = wm.centerOnScreen,    
  h = wm.leftHalf,       
  l = wm.rightHalf,     
  k = wm.topHalf,          
  j = wm.bottomHalf      
})
