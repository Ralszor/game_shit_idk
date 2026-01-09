---@class Input
local Input = {}
Input.pressed = {}

function Input.keyPressed(key)
    return Input.pressed[key]
end

function Input.isKeyDown(key)
    return love.keyboard.isDown(key)
end

return Input