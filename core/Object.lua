---@class Object : Class
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
    self.width = w or love.graphics:getWidth()
    self.height = h or love.graphics:getHeight()
    self.scale_x = scale_x or 1
    self.scale_y = scale_y or 1
    self.stage = nil
end

function Object:update()
    --Assets.dot()
end

function Object:draw() end

function Object:fullDraw() end

function Object:transform() end

---@param to_what Stage
function Object:onAdd(to_what) end

function Object:remove()
    self.stage = nil
end

return Object