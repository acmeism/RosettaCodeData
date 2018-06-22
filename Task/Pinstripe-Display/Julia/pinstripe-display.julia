using Luxor

function drawbars(w, h, sections, dk, lt)
    Drawing(w,h)
    background("white")
    width = 1
    height = h/sections
    for y in 0:height:h-1
        setline(width)
        for x in 0:w/width
            sethue(x % 2 == 0 ? dk: lt)
            line(Point(x*width,y), Point(x*width,y+height), :stroke)
        end
        width += 1
    end
end

drawbars(1920, 1080, 4, "black", "white")
finish()
preview()
