---@class TestState
local TestState = {}

function TestState:enter()
    love.audio.stop()
    self.timer = Timer()
    self.stage = Stage()
    self.world = World()
    self.timer:after(1, function()
        --Assets.playSound("splat")
        self.stage:add(Hero("susie"))
        self.stage:add(self.world)
    end)
end

function TestState:draw()
    love.graphics.clear(0.1,0.1,0.1)
    Draw.setColor(0, 1, 0, 1)
    Draw.setLineWidth(1)
    Draw.rectangle("line", 10, 10, SCREEN_WIDTH-10, SCREEN_HEIGHT-20)
    Draw.setLineWidth(1)
    love.graphics.setFont(Assets.getFont("main", 16))
    Draw.setColor(0, 1, 0, 1)
    Draw.print("What if i\nset my canvas\nto 4\n\n\n\nloser", 20, 15)
    Draw.setColor(1,1,1,1)
    self.stage:draw()
end

function TestState:update()
    self.timer:update()
    self.stage:update()
end

return TestState