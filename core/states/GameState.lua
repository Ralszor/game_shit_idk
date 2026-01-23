---@class GameState
local GameState = {}

local IntroObject = require("data.IntroObject")
local sti = require("core.lib.sti")
local bump = require("core.lib.bump")
local HeroHud = require("data.HeroHud")

function GameState:enter()
    self.stage = Stage()
    
    self.music = Music()

    self.tileLayers = {}
    -- Load map with bump plugin enabled
    --self.map = nil
    self:loadMap("testmap/x0001-y0001", {"bump"}, 0, 32)
    
    -- Create bump world
    self.world = bump.newWorld(32)
    
    -- Scale factor for the map
    local mapScale = 2
    
    -- Use STI's bump_init to add all collidable tiles/objects from the map
    
    self.map:bump_init(self.world)
    if self.map.layers["collision"] then
        self.map.layers["collision"].visible = false
    end
    if self.map.layers["markers"] then
        self.map.layers["markers"].visible = false
    end
    
    -- Scale all collision objects to match the map's draw scale
    local items = self.world:getItems()
    for _, item in ipairs(items) do
        local x, y, w, h = self.world:getRect(item)
        self.world:update(item, x, y, w, h)
    end
    
    -- Find spawn point in the map
    local spawnX, spawnY = SCREEN_WIDTH/2, (SCREEN_HEIGHT/2) + 40 -- default
    for _, layer in ipairs(self.map.layers) do
        if layer.type == "objectgroup" then
            for _, obj in ipairs(layer.objects) do
                if obj.name == "spawn" then
                    spawnX = obj.x
                    spawnY = obj.y
                    -- If it's a rectangle object, add the height to get bottom position
                    if obj.height and obj.height > 0 then
                        spawnY = spawnY + (obj.height)
                    end
                    break
                end
                print(obj.name)
            end
        end
    end
    
    self.player = Hero("kris", spawnX, spawnY)
    self.stage:add(self.player)
    self.stage:add(IntroObject())
    for _, i in ipairs(self.stage.objects) do
        print(i.classname.." Layer is "..i.layer)
    end
    self.stage:add(HeroHud())
    HeroHud.reference = self.player
    self.tileLayers = {}
end

function GameState:draw()
    --Draw.draw(Assets.getTexture("testmod"), 0,0, 0, 1, 1)
    love.graphics.push()
    -- love.graphics.scale(2)
    for _, layer in ipairs(self.tileLayers) do
        layer:draw()
    end
    love.graphics.pop()
    if self.map then
        self.map:draw(0,0,1,1)
    end
    
    self.stage:draw()
end

function GameState:loadMap(map, mode, ox, oy)
    local path = "data/maps/" .. map .. ".tmj"
    local filestring = love.filesystem.read(path)
    self.map = sti(path, mode, ox, oy)
end

function GameState:update()
    self.stage:update()
    if self.map then
        self.map:update(DT)
    end
end

return GameState