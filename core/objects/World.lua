---@class World : Object
local World, super = class("World", Object)

function World:init(x, y, w, h, scale_x, scale_y)
    super.init(self, x, y, w, h, scale_x, scale_y)
    print("World Init'd!")
    self.layer = 0
    self.player = nil
    --self.map = Map()
end

function World:onAdd()
    self.player = self.stage:get(Hero)
    --self.stage:add(self.map)
end

function World:update()
    super.update(self)
    
end

function World:draw()
    super.draw(self)
    love.graphics.clear(0,0,0,1)
    if self.player then
        self.player:draw()
    end
end

return World