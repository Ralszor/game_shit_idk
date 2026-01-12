---@class GameState
local GameState = {}

local IntroObject = require("data.IntroObject")
function GameState:enter()
    self.stage = Stage()
    self.stage:add(Hero("kris", SCREEN_WIDTH/2, SCREEN_HEIGHT/2))
    self.stage:add(IntroObject())
    for _, i in ipairs(self.stage.objects) do
        print(i.classname.." Layer is "..i.layer)
    end
end

function GameState:draw()
    Draw.draw(Assets.getTexture("testmod"), 0,0, 0, 1, 1)
    self.stage:draw()
end

function GameState:update()
    self.stage:update()
end

return GameState