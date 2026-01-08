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
        ox,
        oy,
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