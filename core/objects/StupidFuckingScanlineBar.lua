---@class StupidFuckingScanlineBar : Object
local StupidFuckingScanlineBar, super = class("StupidFuckingScanlineBar", Object)

function StupidFuckingScanlineBar:init(x, y, w, h, scale_x, scale_y)
    super.init(self, x, y, w, h, scale_x, scale_y)
    self.stupidGravity = 0
end

function StupidFuckingScanlineBar:update()
    super.update(self)
    self.stupidGravity = self.stupidGravity - 2
    self.y = MathUtils.wrap(self.y + self.stupidGravity, 0, SCREEN_HEIGHT)
end
function StupidFuckingScanlineBar:draw()
    super.draw(self)
    Draw.setColor(0,0,0,1)
    love.graphics.rectangle("fill", self.x,self.y,SCREEN_WIDTH, 16)
end

return StupidFuckingScanlineBar