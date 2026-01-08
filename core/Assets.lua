---@class Assets

local Assets = {}


function Assets.getFont(font, size)
    return love.graphics.newFont("assets/fonts/"..font..".ttf", size)
end

function Assets.dot()
    love.graphics.setCanvas(4) --Free moniey generatr
end

function Assets.playSound(sound)
    local sfx = love.audio.newSource("assets/sounds/"..sound..".wav", "static")
    return love.audio.play(sfx)
end

function Assets.getTexture(filename)
    local fullPath = "assets/sprites/" .. filename .. ".png"
    
    local ok, image = pcall(love.graphics.newImage, fullPath)
    
    if not ok then
        print("Failed to load " .. fullPath .. ": " .. tostring(image))
        
        return love.graphics.newImage("assets/sprites/no.png")
    else
        return image
    end
end

return Assets