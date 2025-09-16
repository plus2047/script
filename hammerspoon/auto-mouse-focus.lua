-- ========================================
-- AUTO MOUSE FOCUS MODULE
-- ========================================
-- Automatically moves mouse to center of newly focused windows
-- when the mouse is not within the window bounds

local module = {}

-- Configuration
local config = {
    enabled = true,
    -- Delay before moving mouse (in seconds) to avoid conflicts with rapid window switching
    delay = 0.1,
    -- Minimum window size to trigger mouse movement (to avoid tiny windows)
    minWindowWidth = 100,
    minWindowHeight = 100,
    -- Debug mode - set to true to see alerts when mouse is moved
    debug = false
}

-- Global variables
local windowFilter = nil
local moveTimer = nil

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

-- Check if mouse is within window bounds
local function isMouseInWindow(window)
    if not window then return false end
    
    local mousePos = hs.mouse.absolutePosition()
    local windowFrame = window:frame()
    
    return mousePos.x >= windowFrame.x and 
           mousePos.x <= windowFrame.x + windowFrame.w and
           mousePos.y >= windowFrame.y and 
           mousePos.y <= windowFrame.y + windowFrame.h
end

-- Move mouse to center of window
local function moveMouseToWindowCenter(window)
    if not window then return end
    
    local windowFrame = window:frame()
    
    -- Check minimum window size
    if windowFrame.w < config.minWindowWidth or windowFrame.h < config.minWindowHeight then
        if config.debug then
            hs.alert.show("Window too small, skipping mouse move")
        end
        return
    end
    
    -- Calculate center point
    local centerPoint = hs.geometry.rectMidPoint(windowFrame)
    
    -- Move mouse to center
    hs.mouse.absolutePosition(centerPoint)
    
    if config.debug then
        hs.alert.show("Mouse moved to window center")
    end
end

-- ========================================
-- MAIN FUNCTIONALITY
-- ========================================

-- Handle window focus events
local function onWindowFocused(window, appName, event)
    if not config.enabled then return end
    if not window then return end
    
    -- Cancel any pending mouse movement
    if moveTimer then
        moveTimer:stop()
        moveTimer = nil
    end
    
    -- Check if mouse is already in the window
    if isMouseInWindow(window) then
        if config.debug then
            hs.alert.show("Mouse already in window")
        end
        return
    end
    
    -- Schedule mouse movement with a small delay
    moveTimer = hs.timer.doAfter(config.delay, function()
        -- Double-check that the window is still focused
        local currentWindow = hs.window.focusedWindow()
        if currentWindow and currentWindow:id() == window:id() then
            moveMouseToWindowCenter(window)
        end
        moveTimer = nil
    end)
end

-- ========================================
-- MODULE INTERFACE
-- ========================================

-- Start the auto mouse focus feature
function module.start()
    if windowFilter then
        module.stop()
    end
    
    -- Create window filter for all windows
    windowFilter = hs.window.filter.new()
    
    -- Subscribe to window focused events
    windowFilter:subscribe(hs.window.filter.windowFocused, onWindowFocused)
    
    if config.debug then
        hs.alert.show("Auto mouse focus started")
    end
end

-- Stop the auto mouse focus feature
function module.stop()
    if windowFilter then
        windowFilter:unsubscribe()
        windowFilter = nil
    end
    
    if moveTimer then
        moveTimer:stop()
        moveTimer = nil
    end
    
    if config.debug then
        hs.alert.show("Auto mouse focus stopped")
    end
end

-- Enable/disable the feature
function module.toggle()
    config.enabled = not config.enabled
    
    local status = config.enabled and "enabled" or "disabled"
    hs.alert.show("Auto mouse focus " .. status)
end

-- Configure the module
function module.configure(newConfig)
    for key, value in pairs(newConfig) do
        if config[key] ~= nil then
            config[key] = value
        end
    end
end

-- Get current configuration
function module.getConfig()
    return config
end

-- Check if feature is enabled
function module.isEnabled()
    return config.enabled
end

-- ========================================
-- INITIALIZATION
-- ========================================

-- Auto-start the feature when module is loaded
module.start()

return module
