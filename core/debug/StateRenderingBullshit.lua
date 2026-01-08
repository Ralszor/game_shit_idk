--fucking kill me
---@class StateRenderingBullshit

local StateRenderingBullshit = {}

function StateRenderingBullshit:update() end

function StateRenderingBullshit:draw()
    local state = TableUtils.getKey(StateManager.States, StateManager.CurrentState)
    love.graphics.setFont(Assets.getFont("main", 8))
    Draw.print("Current State: "..state, 2, 2)
    --Draw.print("FPS: "..love.timer.getFPS(),2, 10)
end

return StateRenderingBullshit