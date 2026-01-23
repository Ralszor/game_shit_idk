---@class HeroHud : Object
local HeroHud, super = class("HeroHud", Object)

function HeroHud:init(name, x, y, w, h, scale_x, scale_y)
    super.init(self, name, x, y, w, h, scale_x, scale_y)
    self.font = Assets.getFont("main", 16)
    self.reference = nil
    self.layer = WORLD_LAYERS["TOP"]
end

function HeroHud:draw()
    if not self.reference then return end
    super.draw(self)
    Draw.setColor(COLORS.black)
    Draw.rectangle("fill", 0,0,SCREEN_WIDTH, 32)
    Draw.setColor(COLORS.white)
    love.graphics.setFont(self.font)
    Draw.print("HP", 4, 16)
    Draw.setColor(1,1,1,0.25)
    Draw.rectangle("fill", 36, 16, 5*self.reference.max_health, 14)
    Draw.setColor(COLORS.white)
    Draw.rectangle("fill", 36, 16, 5*self.reference.health, 14)

    local lv = self.reference.level <= 3 and "LV"..self.reference.level or "MAX"
    Draw.print(lv, SCREEN_WIDTH/2-54, 16)
    Draw.setColor(1,1,1,0.25)
    Draw.rectangle("fill", 186, 16, 75, 14)

    local xp = (self.reference.exp / self.reference.exp_needed[self.reference.level+1]) * 75
    Draw.setColor(COLORS.white)
    Draw.rectangle("fill", 186, 16, self.reference.level <= 3 and xp or 75, 14)
    for i = 1, self.reference.level do
        Draw.draw(Assets.getTexture("ui/swordlv"), SCREEN_WIDTH-(20*i), 12, 0, 2, 2)
    end
end

return HeroHud