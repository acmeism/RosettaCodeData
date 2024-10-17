function drawcircle!(img::Matrix{T}, col::T, x0::Int, y0::Int, radius::Int) where T
    x = radius - 1
    y = 0
    δx = δy = 1
    er = δx - (radius << 1)

    s = x + y
    while x ≥ y
        for opx in (+, -), opy in (+, -), el in (x, y)
            @inbounds img[opx(x0, el) + 1, opy(y0, s - el) + 1] = col
        end
        if er ≤ 0
            y  += 1
            er += δy
            δy += 2
        end
        if er > 0
            x  -= 1
            δx += 2
            er += (-radius << 1) + δx
        end
        s = x + y
    end
    return img
end

# Test
using Images

img = fill(Gray(255.0), 25, 25);
drawcircle!(img, Gray(0.0), 12, 12, 12)
