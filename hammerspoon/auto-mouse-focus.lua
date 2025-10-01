-- ========================================
-- AUTO MOUSE FOCUS MODULE
-- ========================================
-- Automatically moves mouse to center of newly focused windows
-- when the mouse is not within the window bounds

local module = {}

-- Configuration
local config = {
    enabled = true,
    delay = 0.2,  -- Delay before moving mouse (in seconds)
    minWindowWidth = 100,
    minWindowHeight = 100
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
        return
    end

    -- Move mouse to center
    hs.mouse.absolutePosition(hs.geometry.rectMidPoint(windowFrame))
end

-- ========================================
-- MAIN FUNCTIONALITY
-- ========================================

-- Handle window focus/created events
local function onWindowFocused(window, appName, event)
    if not config.enabled then return end
    if not window then return end

    -- Cancel any pending mouse movement
    if moveTimer then
        moveTimer:stop()
        moveTimer = nil
    end

    -- Get a fresh window object to avoid stale references
    local freshWindow = hs.window.focusedWindow()
    if not freshWindow then return end

    -- Check if mouse is already in the window
    if isMouseInWindow(freshWindow) then return end

    local windowId = window:id()

    -- Schedule mouse movement with a small delay
    moveTimer = hs.timer.doAfter(config.delay, function()
        local currentWindow = hs.window.focusedWindow()
        if currentWindow and currentWindow:id() == windowId then
            moveMouseToWindowCenter(currentWindow)
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

    windowFilter = hs.window.filter.new()
    windowFilter:subscribe(hs.window.filter.windowCreated, onWindowFocused)
    windowFilter:subscribe(hs.window.filter.windowFocused, onWindowFocused)
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
end

-- Toggle the feature
function module.toggle()
    config.enabled = not config.enabled
    hs.alert.show("Auto mouse focus " .. (config.enabled and "enabled" or "disabled"))
end

-- Auto-start the feature when module is loaded
module.start()

return module
