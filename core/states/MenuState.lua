---@class MenuState
local MenuState = {}

MenuState.opts = {
    "START", "LOAD", "FUCK OFF"
}
function MenuState:enter()
    Assets.playSound("splat")
    local menuMusic = love.audio.newSource("assets/music/menu.mp3", "stream")
    menuMusic:play()
    menuMusic:setLooping(true)
    menuMusic:setVolume(0.5)
end

function MenuState:draw()
    love.graphics.clear(0.3,0.3,0.3,1)
    Draw.setColor(1,1,1,1)
    love.graphics.setFont(Assets.getFont("main", 16))
    for k, opt in ipairs(MenuState.opts) do
        Draw.print(opt, 30, 100 + (20*k-1))
    end
end

return MenuState