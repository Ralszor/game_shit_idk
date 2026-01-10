---@class GameState
local GameState = {}

function GameState:enter()
    love.audio.stop()
    self.timer = Timer()
    self.warn = false
    self.con = 0
    self:doTheFuckingSequence()
end

function GameState:doTheFuckingSequence()
    love.graphics.clear(0,0,0,1)
    self.timer:script(function (wait)
        wait(1)
        local a = Assets.playSound("intro")
        print(a:getDuration())
        wait(0.855)
        self.con = 0.25
        wait(0.855)
        self.con = 0.5
        wait(0.855)
        self.con = 0.75
        wait(0.855)
        self.con = 1
        Assets.playSound("nocontroller")
        self.warn = true
    end)
end

function GameState:draw()
    love.graphics.clear(69/255, 84/255, 237/255, 1*self.con)
    if self.warn then
        love.graphics.clear(69/255, 84/255, 237/255, 1)
        Draw.setColor(1,1,1,1)
        love.graphics.setFont(Assets.getFont("main", 8))
        love.graphics.printf("_______________ ", 0, SCREEN_HEIGHT/2-24, love.graphics.getWidth()/2, "center")
        love.graphics.printf("| NO CONTROLLER |", 0, SCREEN_HEIGHT/2-10, love.graphics.getWidth()/2, "center")
        love.graphics.printf("_______________ ", 0, SCREEN_HEIGHT/2-2, love.graphics.getWidth()/2, "center")
        
    end
end

function GameState:update()
    self.timer:update()
end

return GameState