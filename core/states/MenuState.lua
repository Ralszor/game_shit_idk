---@class MenuState
local MenuState = {}

MenuState.opts = {
    { name = "START", callback = function() StateManager.setState("GAMEING") end },
    { name = "LOAD", callback = function() StateManager.setState("GAMEING") end },
    { name = "FUCK OFF", callback = function() love.event.quit() end },
}

function MenuState:enter()
    Assets.playSound("splat")
    local menuMusic = love.audio.newSource("assets/music/menu.mp3", "stream")
    menuMusic:play()
    menuMusic:setLooping(true)
    menuMusic:setVolume(0.5)
    self.selected = 1
end

function MenuState:draw()
    love.graphics.clear(0.3,0.3,0.3,1)
    Draw.setColor(1,1,1,1)
    love.graphics.setFont(Assets.getFont("main", 16))
    for k, opt in ipairs(MenuState.opts) do
        if k == self.selected then
            Draw.setColor(1,1,0,1)
        end
        Draw.print(opt.name, 30, 100 + (20*k-1))
        Draw.setColor(1,1,1,1)
    end
end

function MenuState:update() end

function MenuState:keypressed(key)
    if key == "up" then
        self.selected = MathUtils.clamp(self.selected - 1, 1, #MenuState.opts)
        Assets.playSound("ui_tick")
    elseif key == "down" then
        self.selected = MathUtils.clamp(self.selected + 1, 1, #MenuState.opts)
        Assets.playSound("ui_tick")
    elseif key == "z" then
        Assets.playSound("ui_conf")
        MenuState.opts[self.selected].callback()
    end
    print(self.selected)
end

return MenuState