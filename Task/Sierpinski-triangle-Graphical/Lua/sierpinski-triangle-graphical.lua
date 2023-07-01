-- The argument 'tri' is a list of co-ords: {x1, y1, x2, y2, x3, y3}
function sierpinski (tri, order)
    local new, p, t = {}
    if order > 0 then
        for i = 1, #tri do
            p = i + 2
            if p > #tri then p = p - #tri end
            new[i] = (tri[i] + tri[p]) / 2
        end
        sierpinski({tri[1],tri[2],new[1],new[2],new[5],new[6]}, order-1)
        sierpinski({new[1],new[2],tri[3],tri[4],new[3],new[4]}, order-1)
        sierpinski({new[5],new[6],new[3],new[4],tri[5],tri[6]}, order-1)
    else
        love.graphics.polygon("fill", tri)
    end
end

-- Callback function used to draw on the screen every frame
function love.draw ()
    sierpinski({400, 100, 700, 500, 100, 500}, 7)
end
