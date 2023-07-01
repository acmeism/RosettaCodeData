using Images

fpart(x) = mod(x, one(x))
rfpart(x) = one(x) - fpart(x)

function drawline!(img::Matrix{Gray{N0f8}}, x0::Integer, y0::Integer, x1::Integer, y1::Integer)
    steep = abs(y1 - y0) > abs(x1 - x0)

    if steep
        x0, y0 = y0, x0
        x1, y1 = y1, x1
    end
    if x0 > x1
        x0, x1 = x1, x0
        y0, y1 = y1, y0
    end

    dx = x1 - x0
    dy = y1 - y0
    grad = dy / dx

    if iszero(dx)
        grad = oftype(grad, 1.0)
    end

    # handle first endpoint
    xend = round(Int, x0)
    yend = y0 + grad * (xend - x0)
    xgap = rfpart(x0 + 0.5)
    xpxl1 = xend
    ypxl1 = floor(Int, yend)

    if steep
        img[ypxl1,   xpxl1] = rfpart(yend) * xgap
        img[ypxl1+1, xpxl1] =  fpart(yend) * xgap
    else
        img[xpxl1, ypxl1  ] = rfpart(yend) * xgap
        img[xpxl1, ypxl1+1] =  fpart(yend) * xgap
    end
    intery = yend + grad # first y-intersection for the main loop

    # handle second endpoint
    xend = round(Int, x1)
    yend = y1 + grad * (xend - x1)
    xgap = fpart(x1 + 0.5)
    xpxl2 = xend
    ypxl2 = floor(Int, yend)
    if steep
        img[ypxl2,   xpxl2] = rfpart(yend) * xgap
        img[ypxl2+1, xpxl2] =  fpart(yend) * xgap
    else
        img[xpxl2, ypxl2  ] = rfpart(yend) * xgap
        img[xpxl2, ypxl2+1] =  fpart(yend) * xgap
    end

    # main loop
    if steep
        for x in xpxl1+1:xpxl2-1
            img[floor(Int, intery),   x] = rfpart(intery)
            img[floor(Int, intery)+1, x] =  fpart(intery)
            intery += grad
        end
    else
        for x in xpxl1+1:xpxl2-1
            img[x, floor(Int, intery)  ] = rfpart(intery)
            img[x, floor(Int, intery)+1] =  fpart(intery)
            intery += grad
        end
    end

    return img
end

img = fill(Gray(1.0N0f8), 250, 250);
drawline!(img, 8, 8, 192, 154)
