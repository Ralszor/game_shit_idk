---@class Hero : Character
local Hero, super = class("Hero", Character)
local CharacterController = require("core.classes.CharacterController")

function Hero:init(name, x, y, w, h, scale_x, scale_y)
    super.init(self, name, x, y, w, h, scale_x, scale_y)
    self.controller = CharacterController()
end

function Hero:update()
    super.update(self)
    if self.controller then
        self:handleMovement()
    end
end

function Hero:handleMovement()
    local dx, dy = 0, 0
    local speed = 2

    if self.controller:isKeyDown("left") then dx = dx - 1 end
    if self.controller:isKeyDown("right") then dx = dx + 1 end
    if self.controller:isKeyDown("up") then dy = dy - 1 end
    if self.controller:isKeyDown("down") then dy = dy + 1 end

    -- move (normalize diagonal so diagonal speed isn't faster)
    if dx ~= 0 or dy ~= 0 then
        -- normalize diagonal
        if dx ~= 0 and dy ~= 0 then
            local inv = 1 / math.sqrt(2)
            dx = dx * inv
            dy = dy * inv
        end
        self.x = self.x + dx * speed
        self.y = self.y + dy * speed
        self.isMoving = true
    else
        self.isMoving = false
    end

    -- pick animation name based on direction (8-way)
    local anim = nil
    if dx == 0 and dy > 0 then
        anim = "walk/down"
    elseif dx == 0 and dy < 0 then
        anim = "walk/up"
    elseif dx > 0 and dy == 0 then
        anim = "walk/right"
    elseif dx < 0 and dy == 0 then
        anim = "walk/left"
    elseif dx > 0 and dy > 0 then
        -- prefer diagonal anim if you've added them, otherwise fallback
        anim = self.animations["walk/down_right"] and "walk/down_right" or "walk/right"
    elseif dx < 0 and dy > 0 then
        anim = self.animations["walk/down_left"] and "walk/down_left" or "walk/left"
    elseif dx > 0 and dy < 0 then
        anim = self.animations["walk/up_right"] and "walk/up_right" or "walk/right"
    elseif dx < 0 and dy < 0 then
        anim = self.animations["walk/up_left"] and "walk/up_left" or "walk/left"
    end

    -- set animation once (if any)
    if anim then
        self:setAnimation(anim)
    end
end

return Hero