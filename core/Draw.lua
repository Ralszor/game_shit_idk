local Draw = {}

function Draw.print(text, x, y, w, mode)
    love.graphics.printf(
        text,
        x,
        y,
        w or love.graphics.getWidth(),
        mode
    )
end

function Draw.draw(texture, x, y, r, sx, sy, ox, oy, kx, ky)

    love.graphics.draw(
        texture,
        x or 0,
        y or 0,
        r or 0,
        sx or 1,
        sy or 1,
        (ox or 0)*texture:getWidth(),
        (oy or 0)*texture:getHeight(),
        kx,
        ky
    )
end

---@param sprite love.Image[]
---@param frame number
---@param x number # The position to draw the object (x-axis).
---@param y number # The position to draw the object (y-axis).
---@param r number? # Orientation (radians). (Defaults to 0.)
---@param sx number? # Scale factor (x-axis). (Defaults to 1.)
---@param sy number? # Scale factor (y-axis). (Defaults to sx.)
---@param ox number? # Origin offset (x-axis). (Defaults to 0.)
---@param oy number? # Origin offset (y-axis). (Defaults to 0.)
---@param kx number? # Shearing factor (x-axis). (Defaults to 0.)
---@param ky number? # Shearing factor (y-axis). (Defaults to 0.)
function Draw.drawFrame(sprite, frame, x, y, r, sx, sy, ox, oy, kx, ky)

    local texture = sprite[math.floor(frame)]

    love.graphics.draw(
        texture,
        x or 0,
        y or 0,
        r or 0,
        sx or 1,
        sy or 1,
        (ox or 0)*texture:getWidth(),
        (oy or 0)*texture:getHeight(),
        kx,
        ky
    )
end


function Draw.rectangle(mode, x, y, w, h, t)
    love.graphics.rectangle(
        mode,
        x,
        y,
        w,
        h,
        t
    )
end

function Draw.setColor(r, g, b, a)
    love.graphics.setColor(r, g, b, a)
end

function Draw.setLineWidth(n)
    love.graphics.setLineWidth(n)
end

return Draw
