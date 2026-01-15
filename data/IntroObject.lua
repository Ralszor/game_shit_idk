---@class IntroObject : Object
local IntroObject, super = class("IntroObject", Object)
local Input = require("core.Input")
local Scanline = require("core.objects.StupidFuckingScanlineBar")
local music = require("core.music")

function IntroObject:init()
    super.init(self)
    love.audio.stop()
    self.timer = Timer()
    self.frametimer = 0
    self.layer = 9999
    self.warn = false
    self.prompt = false
    self.con = 0
    self.con2 = 0
    self.con3 = 0
    self.rendering = false
    self.pressed_z = false
    love.graphics.push()
    self:doTheFuckingSequence(1)
    self.stupidBars = {}
end

---@param part integer
function IntroObject:doTheFuckingSequence(part)
    if part == 1 then
        love.graphics.clear(0,0,0,1)
        self.timer:script(function (wait)
            wait(1)
            local a = Assets.playSound("intro")
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
            wait(2)
            print(self.frametimer)
            self:doPrompt()
        end)
    end
    if part == 2 and self.prompt == true then
        Assets.playSound("tv_poweron")
        self.timer:script(function (wait)
            for i = 1, 7 do
                self.con2 = self.con2 + 1
                wait(0.25)
            end
            self.con2 = 8
            table.insert(self.stupidBars, self.stage:add(Scanline(0, 120)))
            table.insert(self.stupidBars, self.stage:add(Scanline(0, 200)))
            wait(1)
            self.con2 = 9
            for k, bar in ipairs(self.stupidBars) do
                bar:remove()
            end
            wait(2)
            self:doTheFuckingSequence(3)
        end)
    end
    if part == 3 then
        self.rendering = true
        self.timer:script(function (wait)
            love.graphics.pop()
            for i = 1, 8 do
                print(i)
                self.con3 = self.con3 + 1
                wait(0.5)
            end
            self:doTheFuckingSequence(4)
        end)
    end
    if part == 4 then
        self.timer:script(function (wait)
            wait(0.5)
            if StateManager.CurrentState.map.properties then
                local musicFile = StateManager.CurrentState.map.properties["music"]
                StateManager.CurrentState.music:play(musicFile, 0.5, 1)
            end
            self:remove()
        end)
    end
end

function IntroObject:doPrompt()
    self.prompt = true
end

function IntroObject:draw()
    if not self.pressed_z then
        
        love.graphics.clear(69/255, 84/255, 237/255, 1*self.con)
        if not self.warn then
            Draw.setColor(0,0,0,1*(self.con-0.25))
            Draw.draw(Assets.getTexture("mantle_title"), SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 0, 2, 2,0.5, 0.5)
        end
    end
    if self.warn then
        love.graphics.clear(69/255, 84/255, 237/255, 1)
        Draw.setColor(1,1,1,1)
        love.graphics.setFont(Assets.getFont("main", 16))
        love.graphics.printf("_______________ ", 0, SCREEN_HEIGHT/2-38, SCREEN_WIDTH, "center")
        love.graphics.printf("| NO CONTROLLER |", 0, SCREEN_HEIGHT/2-10, SCREEN_WIDTH, "center")
        love.graphics.printf("_______________ ", 0, SCREEN_HEIGHT/2+12, SCREEN_WIDTH, "center")
        
    end
    if self.prompt then
        love.graphics.printf("Press Z to Continue", 0, SCREEN_HEIGHT/2+50, SCREEN_WIDTH, "center")
    end
    if self.pressed_z and not self.rendering then
        love.graphics.clear(0,0,0,0)
        Draw.setColor(205/255, 223/255, 25/255)
        if self.con2 == 1 then
            Draw.rectangle("fill", 0, SCREEN_HEIGHT/2, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        elseif self.con2 == 2 then
            Draw.rectangle("fill", SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        elseif self.con2 == 3 then
            Draw.rectangle("fill", 0, 0, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        elseif self.con2 == 4 then
            Draw.rectangle("fill", SCREEN_WIDTH/2, SCREEN_HEIGHT/2, SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
        elseif self.con2 == 5 then
            Draw.rectangle("fill", 0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2)
        elseif self.con2 == 6 then
            Draw.rectangle("fill", 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2)
        elseif self.con2 == 7 then
            Draw.rectangle("fill", 0, SCREEN_HEIGHT/4, SCREEN_WIDTH, SCREEN_HEIGHT/2)
        elseif self.con2 == 8 then
            Draw.rectangle("fill",0,0,SCREEN_WIDTH, SCREEN_HEIGHT)
        elseif self.con2 == 9 and self.con3 == 0 then
            Draw.setColor(COLORS.red)
            Draw.draw(Assets.getTexture("boardheart"), SCREEN_WIDTH/2, SCREEN_HEIGHT/2-2, 0, 1, 1, 0.5, 0.5)
        end
    end
    if self.rendering then
        --love.graphics.setBackgroundColor(1,1,1,0)
        Draw.setColor(COLORS.black)
        love.graphics.rectangle("fill",0, SCREEN_HEIGHT+(32*self.con3), SCREEN_WIDTH, -SCREEN_HEIGHT)
        Draw.setColor(COLORS.white)
        if self.con3 <= 4 then
            Draw.draw(Assets.getTexture("heart_topHalf"),  SCREEN_WIDTH/2, SCREEN_HEIGHT/2-6 + 16, 0, 1, 1, 0.5, 0.5)
        end
        if self.con3 <= 5 then
            Draw.draw(Assets.getTexture("heart_bottomHalf"),  SCREEN_WIDTH/2, SCREEN_HEIGHT/2+3 + 16, 0, 1, 1, 0.5, 0.5)
        end
        
        --love.graphics.translate(0, 30*self.con3)
    end
end

function IntroObject:update()
    self.timer:update()
    self.frametimer = self.frametimer + 1
    if self.frametimer > 194 then
        self:checkInput()
    end
end

function IntroObject:checkInput()
    if Input.keyPressed("z") then
        self:doTheFuckingSequence(2)
        self.pressed_z = true
        self.prompt = false
        self.warn = false
    end
end

return IntroObject
