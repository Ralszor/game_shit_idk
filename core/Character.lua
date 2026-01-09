---@class Character : Object
local Character, super = class("Character", Object)

local CharacterController = require("core.classes.CharacterController")
--local Actor = require("core.classes.ActorSystem")

function Character:init(sprite, x, y, w, h, scale_x, scale_y)
    super.init(self, x, y, w, h, scale_x, scale_y)
    self.name = nil
    self.path = "sprites/chars/empty"
    self.hitbox = {}
    --self.actor = Actor()
    self.controller = CharacterController()
    self.rotation = 0
    self.isMoving = false
    self.animations = {
        ["walk/up"] = Assets.getFrames("walk/up"),
        ["walk/down"] = Assets.getFrames("walk/down"),
        ["walk/left"] = Assets.getFrames("walk/left"),
        ["walk/right"] = Assets.getFrames("walk/right"),
    }
    self.animtimer = 0
    print(self.animations["walk/down"])
    self.sprite = self.animations["walk/down"][1] or Assets.getTexture("no_tiny")
end

function Character:update()
    super.update(self)
    if self.controller then
        self:handleMovement()
    end
end

function Character:getWidth() return self.width end

function Character:getHeight() return self.height end

function Character:getHitbox()
    if self.hitbox then
        local x, y, w, h = unpack(self.hitbox)
        return x or 0, y or 0, w or self:getWidth(), h or self:getHeight()
    else
        return 0, 0, self:getWidth(), self:getHeight()
    end
end

function Character:handleMovement()
    self.isMoving = false
    if self.controller:isKeyDown("down") then
        self.y = self.y + 4
        self.isMoving = true
    end
    if self.controller:isKeyDown("up") then
        self.y = self.y - 4
        self.isMoving = true
    end
    if self.controller:isKeyDown("left") then
        self.x = self.x - 4
        self.isMoving = true
    end
    if self.controller:isKeyDown("right") then
        self.x = self.x + 4
        self.isMoving = true
    end
    if self.controller:isKeyDown("r") then
        self.rotation = self.rotation + 1
        self.isMoving = true
    end
    
end

function Character:onAdd(stage)
    Assets.playSound("sparkle_gem")
end

function Character:draw()
    super.draw(self)
    Draw.draw(self.sprite, self.x, self.y, math.rad(self.rotation), self.scale_x, self.scale_y)
end

return Character