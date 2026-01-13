---@class GameState
local GameState = {}

local IntroObject = require("data.IntroObject")

function GameState:enter()
    self.stage = Stage()
    self.player = Hero("kris", SCREEN_WIDTH/2, (SCREEN_HEIGHT/2) + 40)
    self.stage:add(self.player)
    self.stage:add(IntroObject())
    for _, i in ipairs(self.stage.objects) do
        print(i.classname.." Layer is "..i.layer)
    end
    self.tileLayers = {}
end

function GameState:draw()
    Draw.draw(Assets.getTexture("testmod"), 0,0, 0, 1, 1)
    love.graphics.push()
    love.graphics.scale(2)
    for _, layer in ipairs(self.tileLayers) do
        layer:draw()
    end
    love.graphics.pop()
    love.graphics.rectangle("fill", 0, 0, SCREEN_WIDTH, 32)
    self.stage:draw()
end

function GameState:update()
    self.stage:update()
end

return GameState
