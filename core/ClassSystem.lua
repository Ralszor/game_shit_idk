---@class ClassSystem
---@field CLASS_MT metatable
local ClassSystem = {}
function isClass(maybe_a_class)
    return maybe_a_class.classname ~= nil
end

ClassSystem.CLASS_MT = {
    __call = function (class, ...)
        local t = {}
        setmetatable(t, class)
        if not t.init then
            error("Class "..class.classname.." has no init somehow")
        end
        t:init(...)
        return t
    end,
}

---@class Class
---@field private __includes_all table<Class,boolean> Set of classes this class 
ClassSystem.BASE_CLASS = {
    __includes_all = {}
}

ClassSystem.CLASS_INCLUDE_SKIP_FIELDS = {
    ["classname"] = true,
    ["__includes_all"] = true,
}

function ClassSystem.BASE_CLASS:init() end

---@internal
---@param class Class The class to check for inheritance
---@param subclass Class The class to check for inheritance
function ClassSystem.includes(class, subclass)
    return class.__includes_all[subclass]
end

---@generic T
---@param classname string
---@param include T?
---@param newclass table?
---@return table
---@return T
function ClassSystem.new(classname, include, newclass)
    newclass = newclass or {}
    include = include or ClassSystem.BASE_CLASS
    for key, value in pairs(include) do
        if newclass[key] == nil and not ClassSystem.CLASS_INCLUDE_SKIP_FIELDS[key] then
            newclass[key] = value
        end
    end
    newclass.classname = classname
    newclass.__index = newclass
    setmetatable(newclass, ClassSystem.CLASS_MT)
    return newclass, include
end

---@diagnostic disable-next-line: lowercase-global
class = ClassSystem.new

-- Kristal class function, for classes shared between client and server
function Class(include, classname)
    return ClassSystem.new(classname, include)
end

return ClassSystem
