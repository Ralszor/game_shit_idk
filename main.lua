------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
--Look at you, peeking in the code. Disgusting.
------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------

Draw = require("core.Draw")
globalvars = require("core.globalvars")
ClassSystem = require("core.ClassSystem")
Object = require("core.Object")
Stage = require("core.Stage")
StateManager = require("core.StateManager")
Fuck = require("data.FuckassObject")
Character = require("core.Character")
Input = require("core.Input")

Assets = require("core.Assets") --Totally not ripped from Kristal hehehehehe :3
TableUtils = require("core.utils.TableUtils") --Totally not ripped from Kristal hehehehehe :3
MathUtils = require("core.utils.MathUtils") --Totally not ripped from Kristal hehehehehe :3
StringUtils = require("core.utils.StringUtils") --Totally not ripped from Kristal hehehehehe :3
Timer = require("core.lib.timer") --Totally not ripped from Kristal hehehehehe :3
Sprite = require("core.objects.Sprite") --Totally not ripped from Kristal hehehehehe :3
EventRegistry = require("core.EventRegistry") --Totally not ripped from Kristal hehehehehe :3

function love.load(args)
    love.window.setMode(CANVAS:getWidth()*2, CANVAS:getHeight()*2, { resizable = true })
    love.graphics.setDefaultFilter("nearest")
    for _, arg in ipairs(args) do
        if arg == "--debug-render" then
            StateRender = require("core.debug.StateRenderingBullshit")
        end
    end
end

local bigf = love.graphics.newFont("assets/fonts/main.ttf", 16)
local smallf = love.graphics.newFont("assets/fonts/main.ttf", 8)

function love.keypressed(key)
    Input.pressed[key] = true

    if StateManager.CurrentState.keypressed then
        StateManager.CurrentState:keypressed(key)
    end

    if key == "v" then
        StateManager.setState("LOADING")
        StateManager.States.LOADING.nextState = "MENUING"
    elseif key == "c" then
        StateManager.setState("LOADING")
        StateManager.States.LOADING.nextState = "TESTING"
    end
end

-- This goes in your main.lua
function love.errorhandler(msg)
    love.audio.stop()
    -- 1. Log the error to the console or a file for debugging
    print("Error caught: " .. msg)
    local rand = love.math.random(1, 10)
    local errimg = love.graphics.newImage("assets/sprites/spr_hero.png")
    

    -- 2. Prepare the traceback (the list of calls leading to the error)
    local traceback = debug.traceback()
    print(traceback)
    

    -- 3. The 'Main Loop' for the error screen
    -- Since the game has crashed, we must run a new mini-loop to show the screen
    return function()
        love.graphics.reset()
        love.event.pump() -- Process OS events (like clicking 'X' to close)
        
        for name, a, b, c, d, e, f in love.event.poll() do
            if name == "quit" then return 1 end
            if name == "keypressed" and a == "escape" then return 1 end
        end

        -- 4. Draw your custom UI
        love.graphics.clear(0.1, 0.1, 0.1) -- Dark background
        
        love.graphics.setFont(bigf)
        love.graphics.setColor(1, 0, 0) -- Red text
        love.graphics.printf("Oopsies! We fucked up!", 10, 5, love.graphics.getWidth())
        
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(smallf)
        love.graphics.printf("Error: " .. tostring(msg), 10, 50, love.graphics.getWidth() - 40)

        love.graphics.setColor(0.5, 0.5, 0.5)
        love.graphics.printf("Traceback:\n" .. traceback, 20, 100, love.graphics.getWidth() - 40)
        
        love.graphics.printf("Press ESC to quit", 0, love.graphics.getHeight() - 50, love.graphics.getWidth(), "center")
        love.graphics.printf("Press Ctrl + C to copy traceback", 0, love.graphics.getHeight() - 75, love.graphics.getWidth(), "center")
        love.graphics.printf("Protip: write love.graphics.setCanvas(4) for free moniey", 0, love.graphics.getHeight() - 100, love.graphics.getWidth(), "center")

        if rand == 10 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(bigf)
            love.graphics.printf("These errors are \npissing me off...",30, 300, 999)
            love.graphics.draw(errimg, 325, 290, 0, 2, 2)
        end
        love.graphics.present()
    end
end

function love.update(dt)
    DT = dt
    if StateManager.CurrentState.update then
        StateManager.CurrentState:update()
    end
    Input.pressed = {}
end

function love.run()
	if love.load then love.load(love.arg.parseGameArguments(arg), arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
    local acc = 0
	local dt = 0
	-- Main loop time.
	return function()
		-- Process events.
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a or 0
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end

		-- Update dt, as we'll be passing it to update
        -- Frame limit
        local frame_rate = 30
        local tick_rate = 1 / frame_rate

        local dt = love.timer.step()
        acc = acc + dt

        if (acc >= tick_rate) then
            -- Attempt to keep remainder for next frame
            acc = acc - (math.floor(acc / tick_rate) * tick_rate)

            love.update(1 / 30)

            if love.graphics and love.graphics.isActive() then
                love.graphics.origin()
                love.graphics.clear({ love.graphics.getBackgroundColor() })

                love.draw()

                love.graphics.present()
            end
        end

        love.timer.sleep(0.001)
	end
end

function love.draw()
    -- love.graphics.setCanvas(4) Uncomment this for free money
    love.graphics.setCanvas(CANVAS)
    love.graphics.clear(0.3,0.3,0.3)
    Draw.setColor(0, 1, 0, 1)
    Draw.setLineWidth(1)
    Draw.rectangle("line", 10, 10, SCREEN_WIDTH-10, SCREEN_HEIGHT-20)
    Draw.setLineWidth(1)
    love.graphics.setFont(bigf)
    Draw.setColor(0, 1, 0, 1)
    Draw.print("Tenna pissed\non my\nfucking wife", 20, 15)
    Draw.setColor(1,1,1,1)
    if StateManager.CurrentState.draw then
        StateManager.CurrentState:draw()
    end
    Draw.setColor(1,1,1,1)
    if StateRender then
        StateRender:draw()
    end
    
    love.graphics.setCanvas()
    CANVAS:setFilter("nearest")
    Draw.draw(CANVAS, love.graphics:getWidth()/2, love.graphics:getHeight()/2, 0, 2, 2, CANVAS:getWidth()/2, CANVAS:getHeight()/2)
end