---@class HeroHud : Object
local HeroHud, super = class("HeroHud", Object)

function HeroHud:init(name, x, y, w, h, scale_x, scale_y)
    super.init(self, name, x, y, w, h, scale_x, scale_y)
    self.font = Assets.getFont("main", 16)
    self.reference = nil
end

function HeroHud:draw()
    if not self.reference then return end
    super.draw(self)
    love.graphics.setFont(self.font)
    Draw.print("HP", 8, 8)
    Draw.setColor(1,1,1,0.25)
    Draw.rectangle("fill", 48, 8, 10*self.reference.max_health, 16)
    Draw.setColor(COLORS.white)
    Draw.rectangle("fill", 48, 8, 10*self.reference.health, 16)

    Draw.print("LV"..self.reference.level, SCREEN_WIDTH/2, 8)
end

return HeroHud