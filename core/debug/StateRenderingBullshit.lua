--fucking kill me
---@class StateRenderingBullshit

local StateRenderingBullshit = {}

function StateRenderingBullshit:update() end

local font = love.graphics.newFont("assets/fonts/main.ttf", 8)
function StateRenderingBullshit:draw()
    local state = TableUtils.getKey(StateManager.States, StateManager.CurrentState)
    love.graphics.setFont(font)
    Draw.print("Current State: "..state, 2, 2)
    Draw.print("fake fps: "..love.timer.getFPS(),2, 10)
end

return StateRenderingBullshit