using Luxor

function chaos()
    width  = 1000
    height = 1000
    Drawing(width, height, "./chaos.png")
    t = Turtle(0, 0, true, 0, (0., 0., 0.))
    x = rand(1:width)
    y = rand(1:height)

    for l in 1:30_000
        v = rand(1:3)
        if v == 1
            x /= 2
            y /= 2
        elseif v == 2
            x = width/2 + (width/2 - x)/2
            y = height - (height - y)/2
        else
            x = width - (width - x)/2
            y = y / 2
        end
        Reposition(t, x, height-y)
        Circle(t, 3)
    end
end

chaos()
finish()
preview()
