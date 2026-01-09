---@class Character : Object
local Character, super = class("Character", Object)

local CharacterController = require("core.classes.CharacterController")

local function normalize_assets_path(p)
    if not p then return "" end
    -- Accept paths like "assets/sprites/...", "sprites/...", or already "chars/..."
    p = p:gsub("\\", "/")
    p = p:gsub("^/+", "")
    p = p:gsub("^assets/sprites/", "")
    p = p:gsub("^sprites/", "")
    return p
end

local function frames_or_texture(path)
    -- Try frames first (returns table of images), otherwise wrap a single texture into a table.
    local frames = Assets.getFrames(path)
    if frames and #frames > 0 then
        return frames
    end
    local ok, tex = pcall(Assets.getTexture, path)
    if ok and tex then
        return { tex }
    end
    return nil
end

function Character:init(sprite, x, y, w, h, scale_x, scale_y)
    super.init(self, x, y, w, h, scale_x, scale_y)
    self.name = nil
    -- Prefer the loader-relative path (relative to assets/sprites). Accept older "sprites/..." too.
    self.path = normalize_assets_path("sprites/chars/empty")
    self.hitbox = {}
    self.controller = CharacterController()
    self.rotation = 0
    self.isMoving = false

    -- Build animation paths from self.path so you don't need to hardcode the full keys.
    -- Example: if self.path == "chars/empty", the full frames key becomes "chars/empty/walk/down"
    local base = normalize_assets_path(self.path)

    self.animations = {
        ["walk/up"]    = frames_or_texture(base .. "/walk/up"),
        ["walk/down"]  = frames_or_texture(base .. "/walk/down"),
        ["walk/left"]  = frames_or_texture(base .. "/walk/left"),
        ["walk/right"] = frames_or_texture(base .. "/walk/right"),
    }

    -- current animation state
    self.current_anim = "walk/down"
    self.current_frames = self.animations[self.current_anim] or {}
    self.current_frame = 1
    self.animtimer = 0

    -- safe assignment: if frames missing, fall back to placeholder
    self.sprite = (self.current_frames[1] ~= nil) and self.current_frames[1] or (pcall(Assets.getTexture, "no_tiny") and Assets.getTexture("no_tiny"))
end

function Character:setAnimation(name)
    local frames = self.animations[name]
    if not frames then
        print("setAnimation: animation not found:", name)
        return
    end
    self.current_anim = name
    self.current_frames = frames
    self.current_frame = 1
    self.animtimer = 0
end

function Character:update(dt)
    super.update(self)
    if self.controller then
        self:handleMovement()
    end

    -- update animation timer and pick frame (example timing)
    if self.current_frames and #self.current_frames > 0 then
        -- advance timer (you may want to tweak speed)
        self.animtimer = self.animtimer + (dt or 1/60)
        local speed = 0.12 -- seconds per frame
        local frame_index = math.floor(self.animtimer / speed) % #self.current_frames + 1
        self.current_frame = frame_index
        self.sprite = self.current_frames[self.current_frame] or self.sprite
    else
        -- fallback if frames unavailable
        local ok, tex = pcall(Assets.getTexture, "no_tiny")
        if ok and tex then self.sprite = tex end
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
        self:setAnimation("walk/down")
    end
    if self.controller:isKeyDown("up") then
        self.y = self.y - 4
        self.isMoving = true
        self:setAnimation("walk/up")
    end
    if self.controller:isKeyDown("left") then
        self.x = self.x - 4
        self.isMoving = true
        self:setAnimation("walk/left")
    end
    if self.controller:isKeyDown("right") then
        self.x = self.x + 4
        self.isMoving = true
        self:setAnimation("walk/right")
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