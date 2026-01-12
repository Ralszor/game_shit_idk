DT = 1/30

CANVAS = love.graphics.newCanvas(384, 288)


SCREEN_WIDTH = CANVAS:getWidth()
SCREEN_HEIGHT = CANVAS:getHeight()

WORLD_LAYERS = {
    BOTTOM = 0,
    MID = 50,
    BELOW_PLAYER = 50.9,
    PLAYER = 51,
    TOP = 100,
    BELOW_TEXTBOX = 149,
    TEXTBOX = 150,
}

COLORS = {
    white = {1,1,1,1},
    red = {1,0,0,1},
    orange = {1, 0.5, 0, 1},
    yellow = {1,1,0,1},
    lime = {0.5,1,0,1},
    green = {0,1,0,1},
    cyan = {0,1,1,1},
    blue = {0,0,1,1},
    pink = {1,0,1,1},
    purple = {217/255, 0, 1, 1},
    shit = {84/255, 64/255, 40/255, 1},
    grey = {0.5,0.5,0.5,1},
    black = {0,0,0,1}

}
