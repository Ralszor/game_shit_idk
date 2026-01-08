---@class Stage : Class
local Stage = class("Stage")

function Stage:init()
    self.objects = {}
    self.objects_to_remove = {}
    print("Stage is up cuh")
end

---@param what Object
function Stage:add(what)
    table.insert(self.objects, what)
    what.stage = self
    what:onAdd(self)
end

function Stage:update()
    for _,obj in ipairs(self.objects) do
        obj:update()
    end
end

function Stage:draw()
    for _, obj in ipairs(self.objects) do
        obj:draw()
    end
end

return Stage