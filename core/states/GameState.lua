---@class GameState
local GameState = {}

local IntroObject = require("data.IntroObject")
function GameState:enter()
    self.stage = Stage()
    self.stage:add(IntroObject())
end

function GameState:draw()
    self.stage:draw()
end

function GameState:update()
    self.stage:update()
end

return GameState