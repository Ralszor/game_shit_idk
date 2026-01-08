---@class Fuck : Object
local Fuck, super = class("Fuck", Object)

function Fuck:init()
    super.init(self)
end

function Fuck:update()
    super.update(self)
end

function Fuck:draw()
    super.draw(self)
    Draw.draw(Assets.getTexture("no"), SCREEN_HEIGHT/2, SCREEN_WIDTH/2)
end

return Fuck