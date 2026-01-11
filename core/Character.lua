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

function Character:init(name, x, y, w, h, scale_x, scale_y)
    super.init(self, x, y, w, h, scale_x, scale_y)
    self.name = name or "kris"
    -- set this to the loader-relative base path for the char (relative to assets/sprites)
    self.path = normalize_assets_path("sprites/chars/"..self.name)
    self.hitbox = {}
    self.rotation = 0
    self.isMoving = false
    self.layer = 1

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
    self.current_frames = self.animations[self.current_anim] or {}
    self.current_frame = 1
    self.animtimer = 0

    -- safe assignment: if frames missing, fall back to placeholder
    local ok, fallback = pcall(Assets.getTexture, "no_tiny")
    self.sprite = (self.current_frames[1] ~= nil) and self.current_frames[1] or (ok and fallback)
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
    self.current_frames = frames
    self.current_frame = 1
    -- update sprite to the first frame immediately
    self.sprite = self.current_frames[self.current_frame] or self.sprite
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
        if self.current_frames and #self.current_frames > 0 then
            self.sprite = self.current_frames[1] or self.sprite
        end
    end

    -- animate while moving
    if nowMoving and self.current_frames and #self.current_frames > 1 then
        self.animtimer = self.animtimer + (dt or (1/60))
        local speed = self.anim_speed or 0.12
        local frame_index = math.floor(self.animtimer / speed) % #self.current_frames + 1
        if frame_index ~= self.current_frame then
            self.current_frame = frame_index
            self.sprite = self.current_frames[self.current_frame] or self.sprite
        end
    end

    -- ensure fallback sprite when there are no frames
    if (not self.current_frames or #self.current_frames == 0) then
        local ok, tex = pcall(Assets.getTexture, "no_tiny")
        if ok and tex then self.sprite = tex end
    end

    -- store moving state for next update
    self._wasMoving = nowMoving
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

function Character:onAdd(stage)
    Assets.playSound("sparkle_gem")
end

function Character:draw()
    super.draw(self)
    Draw.draw(self.sprite, self.x, self.y, math.rad(self.rotation), self.scale_x, self.scale_y, 0.5, 1)
end

return Character