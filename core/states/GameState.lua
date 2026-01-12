---@class GameState
local GameState = {}

local IntroObject = require("data.IntroObject")
ldtk = require("core.lib.ldtk")
function GameState:enter()
    self.stage = Stage()
    self.player = Hero
    self.stage:add(self.player("kris", SCREEN_WIDTH/2, SCREEN_HEIGHT/2))
    self.stage:add(IntroObject())
    for _, i in ipairs(self.stage.objects) do
        print(i.classname.." Layer is "..i.layer)
    end
    self.tileLayers = {}
    ldtk:load("data/maps/test_map.ldtk", 1)
end

function GameState:draw()
    Draw.draw(Assets.getTexture("testmod"), 0,0, 0, 1, 1)
    for _, layer in ipairs(self.tileLayers) do
        layer:draw()
    end
    self.stage:draw()
end

function ldtk.onLayer(layer, level) 
    table.insert(GameState.tileLayers,1, layer)
end
function GameState:update()
    self.stage:update()
end

return GameState