-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

-- remap function for all keyboard
local function remap(mods, key, pressFn)
	hs.hotkey.bind(mods, key, pressFn, nil, pressFn)	
end

local function pressFn(mods, key)
    if key == nil then
        key = mods
        mods = {}
    end
    return function() hs.eventtap.keyStroke(mods, key, 100) end
end

-- remap function based on keyboard type
-- you must call the :start method of returned object,
-- and you must save the return of :start method into a global variable
local function keyboardTypeRemap(mods, targetKeyCode, targetKeyboardType, fn)
    return hs.eventtap.new({hs.eventtap.event.types.keyDown}, function(event)
        local keyboardTypeKey = hs.eventtap.event.properties.keyboardEventKeyboardType
        local eventKeyboardType = event:getProperty(keyboardTypeKey)
        local eventKeyCode = event:getKeyCode()
        local flags = event:getFlags()
        
        -- Check if this is the key and keyboard we're targeting
        if eventKeyCode == targetKeyCode and eventKeyboardType == targetKeyboardType then
            -- Check modifiers
            if (mods == nil and flags:containExactly({})) or 
               (mods ~= nil and flags:containExactly(mods)) then
                fn()
                return true -- Consume the event
            end
        end
        return false
    end)
end

-- ========================================
-- STANDARD ARROW KEY REMAPPINGS (ALL KEYBOARDS)
-- ========================================

-- Alt + hjkl = Arrow keys
remap({'alt'}, 'h', pressFn('left'))
remap({'alt'}, 'j', pressFn('down'))
remap({'alt'}, 'k', pressFn('up'))
remap({'alt'}, 'l', pressFn('right'))

-- Alt + Shift + hjkl = Arrow keys with selection
remap({'alt', 'shift'}, 'h', pressFn({'shift'}, 'left'))
remap({'alt', 'shift'}, 'j', pressFn({'shift'}, 'down'))
remap({'alt', 'shift'}, 'k', pressFn({'shift'}, 'up'))
remap({'alt', 'shift'}, 'l', pressFn({'shift'}, 'right'))

-- Alt + Cmd + hjkl = Word-level navigation
remap({'alt', 'cmd'}, 'h', pressFn({'cmd'}, 'left'))
remap({'alt', 'cmd'}, 'j', pressFn({'cmd'}, 'down'))
remap({'alt', 'cmd'}, 'k', pressFn({'cmd'}, 'up'))
remap({'alt', 'cmd'}, 'l', pressFn({'cmd'}, 'right'))

-- Alt + Ctrl + hjkl = Option + arrows
remap({'alt', 'ctrl'}, 'h', pressFn({'alt'}, 'left'))
remap({'alt', 'ctrl'}, 'j', pressFn({'alt'}, 'down'))
remap({'alt', 'ctrl'}, 'k', pressFn({'alt'}, 'up'))
remap({'alt', 'ctrl'}, 'l', pressFn({'alt'}, 'right'))

-- ========================================
-- BUILT-IN KEYBOARD MAPPINGS (Type 91)
-- ========================================

local BUILTIN_KEYBOARD_TYPE = 91
local EXTERNAL_KEYBOARD_TYPE = 46
local BACKTICK_KEY_CODE = 50
local ESCAPE_KEY_CODE = 53

builtInMaps = {
    keyboardTypeRemap(nil, BACKTICK_KEY_CODE, BUILTIN_KEYBOARD_TYPE, 
    function() hs.eventtap.keyStroke({}, "escape", 100) end):start(),

    keyboardTypeRemap({"alt"}, BACKTICK_KEY_CODE, BUILTIN_KEYBOARD_TYPE, 
    function() hs.eventtap.keyStrokes("`") end):start()
}

-- ========================================
-- EXTERNAL KEYBOARD MAPPINGS (Type 46)
-- ========================================

externalMaps = {
    keyboardTypeRemap(nil, ESCAPE_KEY_CODE, EXTERNAL_KEYBOARD_TYPE, 
    function() hs.eventtap.keyStroke({}, "escape", 100) end):start(),

    keyboardTypeRemap({"alt"}, ESCAPE_KEY_CODE, EXTERNAL_KEYBOARD_TYPE, 
    function() hs.eventtap.keyStrokes("`") end):start(),

    keyboardTypeRemap({"ctrl"}, ESCAPE_KEY_CODE, EXTERNAL_KEYBOARD_TYPE, 
    function() hs.eventtap.keyStroke({"ctrl"}, "`", 100) end):start(),

    keyboardTypeRemap({"cmd"}, ESCAPE_KEY_CODE, EXTERNAL_KEYBOARD_TYPE, 
    function() hs.eventtap.keyStroke({"cmd"}, "`", 100) end):start(),

    keyboardTypeRemap({"shift"}, ESCAPE_KEY_CODE, EXTERNAL_KEYBOARD_TYPE, 
    function() hs.eventtap.keyStrokes("~") end):start(),

    keyboardTypeRemap({"alt", "shift"}, ESCAPE_KEY_CODE, EXTERNAL_KEYBOARD_TYPE, 
    function() hs.eventtap.keyStroke({"shift"}, "escape", 100) end):start(),

    keyboardTypeRemap(nil, BACKTICK_KEY_CODE, EXTERNAL_KEYBOARD_TYPE,
    function() hs.eventtap.keyStroke({"alt"}, "delete", 100) end):start()
}

-- ========================================
-- LEFT SHIFT TO CAPS LOCK (ALL KEYBOARDS)
-- ========================================


-- Function to handle left shift pressed alone -> caps lock
local function leftShiftToCapsLock()
    local shiftPressed = false
    local shiftPressTime = 0
    local otherKeyPressed = false

    return hs.eventtap.new({
        hs.eventtap.event.types.keyDown,
        hs.eventtap.event.types.keyUp,
        hs.eventtap.event.types.flagsChanged
    }, function(event)
        local eventType = event:getType()

        -- Check if left shift flag changed using raw flags
        local rawFlags = event:rawFlags()
        local leftShiftFlag = hs.eventtap.event.rawFlagMasks.deviceLeftShift
        local leftShiftPressed = (rawFlags & leftShiftFlag) ~= 0

        if eventType == hs.eventtap.event.types.flagsChanged then
            if leftShiftPressed and not shiftPressed then
                -- Left shift pressed down
                shiftPressed = true
                shiftPressTime = hs.timer.absoluteTime()
                otherKeyPressed = false
            elseif not leftShiftPressed and shiftPressed then
                -- Left shift released
                local pressDuration = (hs.timer.absoluteTime() - shiftPressTime)
                if not otherKeyPressed and pressDuration < 0.5 * 1E9 then
                    hs.eventtap.event.newSystemKeyEvent("CAPS_LOCK", true):post()
                    hs.eventtap.event.newSystemKeyEvent("CAPS_LOCK", false):post()
                end
                shiftPressed = false
                otherKeyPressed = false
            end
        elseif (
            eventType == hs.eventtap.event.types.keyDown or 
            eventType == hs.eventtap.event.types.keyUp
        ) then
            if shiftPressed and leftShiftPressed then
                otherKeyPressed = true
            end
        end

        return false -- Don't consume the event, let it pass through
    end)
end

-- Start the left shift to caps lock eventtap
leftShiftToCapsLockTap = leftShiftToCapsLock():start()
