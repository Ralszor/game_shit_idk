---@class Hero : Character
local Hero, super = class("Hero", Character)
local CharacterController = require("core.classes.CharacterController")

function Hero:init(name, x, y, w, h, scale_x, scale_y)
    super.init(self, name, x, y, w, h, scale_x, scale_y)
    self.controller = CharacterController()
    self.hitbox = {-16,-32, 32, 32}
    self.level = 1
    self.max_health = 12
    self.exp = 0
    self.exp_needed = {
        [1] = 0,
        [2] = 4,
        [3] = 15,
        [4] = 14,
        [5] = 99999
    }
    self.health = 3
end

function Hero:update()
    super.update(self)
    if self.controller then
        self:handleMovement()
    end
end

function Hero:draw()
    super.draw(self)
end

function Hero:addExp(howMuch)
    self.exp = self.exp + howMuch
    if self.exp >= (self.exp_needed[self.level+1] or math.huge) then
        self:levelUp()
    end
end

function Hero:levelUp()
    self.level = MathUtils.clamp(self.level+1, 1, 4)
    self.exp = 0
    Assets.playSound("board_ominous")
end

function Hero:handleMovement()
    local dx, dy = 0, 0
    local speed = 4

    if self.controller:isKeyPressed("q") then
        self:addExp(1)
        Assets.playSound("ui_tick")
    end

    if self.controller:isKeyDown("left") then dx = dx - 1 end
    if self.controller:isKeyDown("right") then dx = dx + 1 end
    if self.controller:isKeyDown("up") then dy = dy - 1 end
    if self.controller:isKeyDown("down") then dy = dy + 1 end

    -- move with collision detection
    if dx ~= 0 or dy ~= 0 then
        local targetX = self.x + dx * speed
        local targetY = self.y + dy * speed
        
        -- Use bump collision if world and collider exist
        if StateManager.CurrentState.world and self.collider then
            local hx, hy, hw, hh = self:getHitbox()
            local actualX, actualY, cols, len = StateManager.CurrentState.world:move(
                self.collider, 
                targetX + hx, 
                targetY + hy
            )
            -- Update position based on collision result (subtract hitbox offset)
            self.x = actualX - hx
            self.y = actualY - hy
            
        else
            -- Fallback to no collision
            self.x = targetX
            self.y = targetY
        end
        
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