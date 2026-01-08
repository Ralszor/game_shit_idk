---@class LoadState
local LoadState = {}

local g = 0
local a = Assets.getTexture("no")

function LoadState:enter()

end

function LoadState:update()
    g = g+1
    if g == 200 then
        StateManager.setState("MENUING")
        g = 0
    end
end

function LoadState:draw()
    love.graphics.clear(0.3,0.3,0.3, 1)
    Draw.draw(a, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, math.rad(g/2),0.5, 0.5, a:getWidth()/2, a:getHeight()/2)
end

return LoadState