---@class Object : Class
---@field stage Stage
local Object, super = class("Object")

---@param x integer
---@param y integer
---@param w integer
---@param h integer
---@param scale_x integer
---@param scale_y integer
function Object:init(x, y, w, h, scale_x, scale_y)
    self.x = x or 0
    self.y = y or 0
    self.width = w or love.graphics.getWidth()
    self.height = h or love.graphics.getHeight()
    self.scale_x = scale_x or 1
    self.scale_y = scale_y or 1
    self.stage = nil
    self.layer = 0
    self.origin_x = 0
    self.origin_y = 0
end

---@param to_what integer
function Object:setLayer(to_what)
    self.layer = to_what
end
function Object:update()
    --Assets.dot()
end

function Object:draw()
    if self.sprite then
        Draw.drawFrame(self.sprite, self.current_frame or 1, self.x, self.y, math.rad(self.rotation), self.scale_x, self.scale_y, self.origin_x, self.origin_y)
        --Draw.drawSprite(self.sprite, self.sprite_frame)
    end
end

function Object:fullDraw() end

function Object:transform() end

---@param to_what Stage
function Object:onAdd(to_what) end

function Object:remove()
    self.stage:remove(self)
    self.stage = nil
end

return Object
