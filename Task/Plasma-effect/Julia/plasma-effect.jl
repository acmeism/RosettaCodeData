using Luxor, Colors

Drawing(800, 800)

function plasma(wid, hei)
    for x in -wid:wid, y in -hei:hei
        sethue(parse(Colorant, HSV(180 + 45sin(x/19) + 45sin(y/9) +
            45sin((x+y)/25) + 45sin(sqrt(x^2 + y^2)/8), 1, 1)))
        circle(Point(x, y), 1, :fill)
    end
end

@png plasma(800, 800)
