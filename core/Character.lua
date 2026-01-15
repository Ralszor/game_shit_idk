---@class Character : Object
local Character, super = class("Character", Object)

local function normalize_assets_path(p)
    if not p then return "" end
    p = p:gsub("\\", "/")
    p = p:gsub("^/+", "")
    p = p:gsub("^assets/sprites/", "")
    p = p:gsub("^sprites/", "")
    return p
end

function Character:init(name, x, y, w, h)
    super.init(self, x, y, w, h, 2, 2)
    self.origin_x = 0.5
    self.origin_y = 1
    
    self.name = name or "kris"
    -- set this to the loader-relative base path for the char (relative to assets/sprites)
    self.path = normalize_assets_path("sprites/chars/"..self.name)
    
    -- Hitbox is relative to top-left of sprite
    -- Override this in subclasses or after init to set a custom hitbox
    self.hitbox = {}
    
    self.rotation = 0
    self.isMoving = false
    self.layer = WORLD_LAYERS.PLAYER
    
    -- bump collision properties
    self.collider = nil -- will be set when added to bump world
    
    -- animation timing config
    self.anim_speed = 8/30 -- seconds per frame
    
    local base = normalize_assets_path(self.path)
    self.animations = {
        ["walk/up"]    = Assets.getFramesOrTexture(base .. "/walk/up"),
        ["walk/down"]  = Assets.getFramesOrTexture(base .. "/walk/down"),
        ["walk/left"]  = Assets.getFramesOrTexture(base .. "/walk/left"),
        ["walk/right"] = Assets.getFramesOrTexture(base .. "/walk/right"),
        -- add any other animations here
    }
    
    -- current animation state
    self.current_anim = "walk/down"
    self.sprite = self.animations[self.current_anim] or {}
    self.current_frame = 1
    self.animtimer = 0
end

function Character:setAnimation(name)
    if self.current_anim == name then
        return
    end
    local frames = self.animations[name]
    if not frames then
        print("setAnimation: animation not found:", name)
        return
    end
    -- switching animations: keep timer so it doesn't stutter when changing direction,
    -- but if you want it to restart every switch, uncomment the next line:
    -- self.animtimer = 0
    self.current_anim = name
    self.sprite = frames
    self.current_frame = 1
end

function Character:update(dt)
    super.update(self)
    
    -- remember previous moving state so we only reset timers on transitions
    local prevMoving = self._wasMoving or false
    local nowMoving = self.isMoving
    
    -- transition: started moving -> reset animtimer so walk starts fresh
    if nowMoving and not prevMoving then
        self.animtimer = 0
        -- optionally do not reset current_frame so walking continues where it left off
        -- self.current_frame = 1
    end
    
    -- transition: stopped moving -> snap to first frame and reset timer
    if not nowMoving and prevMoving then
        self.animtimer = 0
        self.current_frame = 1
    end
    
    -- animate while moving
    if nowMoving and self.sprite and #self.sprite > 1 then
        self.animtimer = self.animtimer + (dt or (1/60))
        local speed = self.anim_speed or 0.12
        local frame_index = math.floor(self.animtimer / speed) % #self.sprite + 1
        if frame_index ~= self.current_frame then
            self.current_frame = frame_index
        end
    end
    
    -- store moving state for next update
    self._wasMoving = nowMoving
end

function Character:getWidth() return self.width * self.scale_x end
function Character:getHeight() return self.height * self.scale_y end

function Character:getHitbox()
    if self.hitbox and #self.hitbox > 0 then
        local x, y, w, h = unpack(self.hitbox)
        return x or 0, y or 0, w or self:getWidth(), h or self:getHeight()
    else
        return 0, 0, self:getWidth(), self:getHeight()
    end
end

function Character:onAdd(stage)
    Assets.playSound("sparkle_gem")
    
    -- add to bump world if it exists
    if StateManager.CurrentState.world then
        local hx, hy, hw, hh = self:getHitbox()
        self.collider = StateManager.CurrentState.world:add(self, self.x + hx, self.y + hy, hw, hh)
    end
end

function Character:draw()
    super.draw(self)
    
    love.graphics.setColor(0, 1, 0, 0.5)
    local hx, hy, hw, hh = self:getHitbox()
    local offsetX = -self:getWidth() * self.origin_x
    local offsetY = -self:getHeight() * self.origin_y
    love.graphics.rectangle("fill", self.x + offsetX + hx, self.y + offsetY + hy, hw, hh)
    love.graphics.setColor(1, 1, 1, 1)
end

return Character