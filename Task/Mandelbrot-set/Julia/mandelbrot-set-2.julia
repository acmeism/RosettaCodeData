using Images

@inline function hsv2rgb(h, s, v)
    const c = v * s
    const x = c * (1 - abs(((h/60) % 2) - 1))
    const m = v - c

    const r,g,b =
        if h < 60
            (c, x, 0)
        elseif h < 120
            (x, c, 0)
        elseif h < 180
            (0, c, x)
        elseif h < 240
            (0, x, c)
        elseif h < 300
            (x, 0, c)
        else
            (c, 0, x)
        end

    (r + m), (b + m), (g + m)
end

function mandelbrot()

    const w, h = 1000, 1000

    const zoom  = 0.5
    const moveX = 0
    const moveY = 0

    const img = Array{RGB{Float64}}(h, w)
    const maxIter = 30

    for x in 1:w
        for y in 1:h
            i = maxIter
            const c = Complex(
                (2*x - w) / (w * zoom) + moveX,
                (2*y - h) / (h * zoom) + moveY
            )
            z = c
            while abs(z) < 2 && (i -= 1) > 0
                z = z^2 + c
            end
            const r,g,b = hsv2rgb(i / maxIter * 360, 1, i / maxIter)
            img[y,x] = RGB{Float64}(r, g, b)
        end
    end

    save("mandelbrot_set.png", img)
end

mandelbrot()
