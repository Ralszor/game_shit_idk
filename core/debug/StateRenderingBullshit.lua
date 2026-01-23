--fucking kill me
---@class StateRenderingBullshit

local StateRenderingBullshit = {}

function StateRenderingBullshit:update() end

local font = love.graphics.newFont("assets/fonts/main.ttf", 8)
function StateRenderingBullshit:draw()
    local state = TableUtils.getKey(StateManager.States, StateManager.CurrentState)
    love.graphics.setFont(font)
    Draw.print("Current State: "..state, 2, SCREEN_HEIGHT - 20)
    Draw.print("fake fps: "..love.timer.getFPS(),2, SCREEN_HEIGHT - 12)

    if Input.isKeyDown("f6") then
        love.graphics.setColor(1, 0, 0, 0.5)
        local items = StateManager.CurrentState.world:getItems()
        for _, item in ipairs(items) do
            local x, y, w, h = StateManager.CurrentState.world:getRect(item)
            love.graphics.rectangle("line", x, y, w, h)
        end
        love.graphics.setColor(1, 1, 1, 1)
    elseif Input.isKeyDown("lctrl" or "rctrl") and Input.isKeyDown("r") then
        love.event.quit("restart")
    end
end


return StateRenderingBullshit