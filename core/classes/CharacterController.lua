---@class CharacterController : Class
local CharacterController, super = class("CharacterController")

function CharacterController:isKeyPressed(key)
    return Input.keyPressed(key)
end

function CharacterController:isKeyDown(key)
    return Input.isKeyDown(key)
end

return CharacterController