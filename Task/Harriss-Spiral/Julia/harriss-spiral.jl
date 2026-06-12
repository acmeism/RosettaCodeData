""" https://rosettacode.org/wiki/Harriss_Spiral """

using Luxor

const HR = 1.324718 # The Harriss Ratio, aka Ian Stewart's "plastic number"
const SHOW_LINES = false

""" Recursively draw the Harriss spiral for `iteration` iterations, with radius sqrt(2) smaller each iteration. """
function harriss(x, y, angle, len, iteration, linew, radius = 0.0, cntrx = 0.0, cntry = 0.0)
    iteration < 1 && return
    startangle = angle + 45
    endangle = startangle + 90
    # Calculate end point of lines
    xend = x + len * cospi(angle / 180)
    yend = y + len * sinpi(angle / 180)
    heading = yend < y ? "SN" : xend < x ? "EW" : yend > y ? "NS" : xend > x ? "WE" : "error"
    if SHOW_LINES
        sethue(0, 0, 0)
        setline(1)
        line(Point(x, y), Point(xend, yend), action = :stroke)
    end
    radius = len / sqrt(2)
    if heading == "SN"
        cntrx = x - len / 2
        cntry = y - len / 2
        sethue(255, 255, 0)
        setline(linew)
    elseif heading == "EW"
        cntrx = x - len / 2
        cntry = y + len / 2
        sethue(255, 0, 0)
        setline(linew)
    elseif heading == "NS"
        cntrx = x + len / 2
        cntry = y + len / 2
        sethue(0, 0, 255)
        setline(linew)
    elseif heading == "WE"
        cntrx = x + len / 2
        cntry = y - len / 2
        sethue(0, 0, 0)
        setline(linew)
    end
    arc(cntrx, cntry, radius, π * startangle / 180, π * endangle / 180, action = :stroke)
    harriss(xend, yend, angle - 90, len / HR, iteration - 1, linew, radius, cntrx, cntry)
end


""" Draw the Harriss spiral several times in its fractal "nest of spirals" format """
function draw()
    Drawing()
    background(211/255, 211/255, 211/255) # light gray
    origin()
    startx = 50
    starty = 280
    init_len = 525 / HR / HR
    # Reverse Order Hides Joints
    harriss(startx - (init_len / HR + init_len / HR^3), starty - init_len / HR^7, 180, init_len / HR^6, 2, 6.0) # level 3
    harriss(startx - (init_len / HR + init_len / HR^3), starty - (init_len + init_len / HR^2), 270, init_len / HR^5, 3, 6.0) # level 3
    harriss(startx + init_len / HR^4, starty - (init_len + init_len / HR^2), 270, init_len / HR^5, 3, 6.0) # level 3
    harriss(startx + init_len / HR, starty - (init_len + init_len / HR^2), 0, init_len / HR^4, 4, 6.0) # level 3 rt-upper
    harriss(startx - init_len / HR^4, starty - init_len / HR, 0, init_len / HR^5, 2, 10.0) # level 2 mid-upper
    harriss(startx - init_len / HR^4, starty - init_len / HR^3, -270, init_len / HR^4, 3, 12.0) # level 2 mid-lower
    harriss(startx - init_len / HR, starty - init_len / HR^3, 180, init_len / HR^3, 4, 12.0) # level 2 lt-lower
    harriss(startx - init_len / HR, starty - init_len, 270, init_len / HR^2, 5, 14.0) # level 2 lt-upper
    harriss(startx, starty - init_len, 0, init_len / HR, 6, 14.0) # level 2 rt-upper
    harriss(startx, starty, -90, init_len, 7, 18.0) # level 1 base spiral
    finish()
    preview()
end

draw()
