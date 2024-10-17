using Images

@inline function hsv2rgb(h, s, v)
    c = v * s
    x = c * (1 - abs(((h/60) % 2) - 1))
    m = v - c
    r,g,b = if     h < 60   (c, x, 0)
            elseif h < 120  (x, c, 0)
            elseif h < 180  (0, c, x)
            elseif h < 240  (0, x, c)
            elseif h < 300  (x, 0, c)
            else            (c, 0, x) end
    (r + m), (b + m), (g + m)
end

function mandelbrot()
    w       = 1600
    h       = 1200
    zoom    = 0.5
    moveX   = -0.5
    moveY   = 0
    maxIter = 30
    img = Array{RGB{Float64},2}(undef,h,w)
    for x in 1:w
      for y in 1:h
        i = maxIter
        z = c = Complex( (2*x - w) / (w * zoom) + moveX,
                         (2*y - h) / (h * zoom) + moveY )
        while abs(z) < 2 && (i -= 1) > 0
            z = z^2 + c
        end
        r,g,b = hsv2rgb(i / maxIter * 360, 1, i / maxIter)
        img[y,x] = RGB{Float64}(r, g, b)
      end
    end
    return img
end

img = mandelbrot()
save("mandelbrot.png", img)
