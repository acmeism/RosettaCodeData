using Images

@inline function hsv2rgb(h, s, v)
    c = v * s
    x = c * (1 - abs(((h/60) % 2) - 1))
    m = v - c

    if h < 60
        r,g,b = (c, x, 0)
    elseif h < 120
        r,g,b = (x, c, 0)
    elseif h < 180
        r,g,b = (0, c, x)
    elseif h < 240
        r,g,b = (0, x, c)
    elseif h < 300
        r,g,b = (x, 0, c)
    else
        r,g,b = (c, 0, x)
    end

    (r + m), (b + m), (g + m)
end

function julia_set(c = -0.7+0.27015im)

    w, h = 800, 800

    zoom  = 0.7       # the zoom factor
    moveX = 0         # the amount of shift on the x axis
    moveY = 0         # the amount of shift on the y axis

    L = 2             # the maximum value of |z|
    I = 255           # the maximum number of iterations

    img = zeros(RGB{Float64}, h, w)

    for x in 1:w, y in 1:h
        n = 0
        z = Complex(
            (2*x - w) / (w * zoom) + moveX,
            (2*y - h) / (h * zoom) + moveY
        )
        while abs(z) < L && (n += 1) < I
            z = z^2 + c
        end
        v = (I - n) / I
        r,g,b = hsv2rgb(v*360, 1, v)
        img[y,x] = RGB{Float64}(r, g, b)
    end

    save("julia_set.png", img)
end

julia_set()
