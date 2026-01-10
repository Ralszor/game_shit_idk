---@class World : Object
local World, super = class("World", Object)

function World:init(x, y, w, h, scale_x, scale_y)
    super.init(self, x, y, w, h, scale_x, scale_y)
    self.stage = Stage()
    print("World Init'd!")
end

function World:update()
    super.update(self)
    
    --self.stage:update()
end

function World:draw()
    super.draw(self)

    --self.stage:draw()
end

return World