---@class Stage : Class
local Stage = class("Stage")

function Stage:init()
    self.objects = {}
    self.objects_to_remove = {}
    self.should_sort = false
    --print("Stage is up cuh")
end

---@param what Object
function Stage:add(what)
    
    table.insert(self.objects, what)
    what.stage = self
    what:onAdd(self)
    self.should_sort = true
    return what
end

---@generic T
---@param what T
---@return T
function Stage:get(what)
    for _, this in ipairs(self.objects) do
        if getmetatable(this) == what then
            return this
        end
    end
    error("Couldnt get this ("..what.classname.."). Check if it exists, maybe?")
end
function Stage:update()
    for _,obj in ipairs(self.objects) do
        obj:update()
    end
    if self.should_sort then
        table.sort(self.objects, function(a, b)
            return a.layer < b.layer
        end)
        self.should_sort = false
    end
end

function Stage:draw()
    for _, obj in ipairs(self.objects) do
        obj:draw()
    end
end

function Stage:remove(what)
    if what then
        TableUtils.removeValue(self.objects, what)
    end
end
return Stage