--Very stup id fucking loader i hate it god fuck you fuck you eat a dick love.graphics.setCanvas(4)

---@class LoadState
local LoadState = {}

local g = 0
LoadState.Loader = {}
local a = love.graphics.newImage("assets/sprites/no.png")

LoadState.Loader.waiting = 0
LoadState.done = false
LoadState.Loader.end_funcs = {}
LoadState.Loader.next_key = 0

function LoadState:enter()
    LoadState.nextState = "MENUING"
    LoadState.Loader.in_channel = love.thread.getChannel("load_in")
    LoadState.Loader.out_channel = love.thread.getChannel("load_out")

    LoadState.Loader.thread = love.thread.newThread("core/loadthread.lua")
    LoadState.Loader.thread:start()
    self:loadAssets("", "all", "", function() LoadState.done = true end)
end

function LoadState:update()
    g = g+1
    local msg = LoadState.Loader.out_channel:pop()
    if msg then
        print(TableUtils.dump(msg))
        if msg.status == "finished" then
            LoadState.Loader.in_channel:push("stop")
            Assets.loadData(msg.data.assets)
            StateManager.setState(LoadState.nextState)
        end
    end
end

function LoadState:draw()
    love.graphics.clear(0.3,0.3,0.3, 1)
    Draw.draw(a, SCREEN_WIDTH/2, SCREEN_HEIGHT/2, math.rad(g/2),0.5, 0.5, a:getWidth()/2, a:getHeight()/2)
end

--- Loads assets of the specified type from the given directory, and calls the given callback when done.
---@param dir    string       The directory to load assets from.
---@param loader string       The type of assets to load.
---@param paths? string|table The specific asset paths to load.
---@param after? function     The function to call when done.
function LoadState:loadAssets(dir, loader, paths, after)
    LoadState.Loader.message = ""
    LoadState.Loader.waiting = LoadState.Loader.waiting + 1

    if after then
        LoadState.Loader.end_funcs[LoadState.Loader.next_key] = after
    end

    LoadState.Loader.in_channel:push({
        key = LoadState.Loader.next_key,
        dir = dir,
        loader = loader,
        paths = paths
    })
    LoadState.Loader.next_key = LoadState.Loader.next_key + 1
end

return LoadState