using Luxor

function sierpinski_curve(x0, y0, h, level)
    x1, y1 = x0, y0
    lineto(x, y) = begin line(Point(x1, y1), Point(x, y), :stroke); x1, y1 = x, y end
    lineN() = lineto(x1,y1-2*h)
    lineS() = lineto(x1,y1+2*h)
    lineE() = lineto(x1+2*h,y1)
    lineW() = lineto(x1-2*h,y1)
    lineNW() = lineto(x1-h,y1-h)
    lineNE() = lineto(x1+h,y1-h)
    lineSE() = lineto(x1+h,y1+h)
    lineSW() = lineto(x1-h,y1+h)
    function drawN(i)
        if i == 1
            lineNE(); lineN(); lineNW()
        else
            drawN(i-1); lineNE(); drawE(i-1); lineN(); drawW(i-1); lineNW(); drawN(i-1)
        end
    end
    function drawE(i)
        if i == 1
            lineSE(); lineE(); lineNE()
        else
            drawE(i-1); lineSE(); drawS(i-1); lineE(); drawN(i-1); lineNE(); drawE(i-1)
        end
    end
    function drawS(i)
        if i == 1
            lineSW(); lineS(); lineSE()
        else
            drawS(i-1); lineSW(); drawW(i-1); lineS(); drawE(i-1); lineSE(); drawS(i-1)
        end
    end
    function drawW(i)
        if i == 1
            lineNW(); lineW(); lineSW()
        else
            drawW(i-1); lineNW(); drawN(i-1); lineW(); drawS(i-1); lineSW(); drawW(i-1)
        end
    end
    function draw_curve(levl)
        drawN(levl); lineNE(); drawE(levl); lineSE()
        drawS(levl); lineSW(); drawW(levl); lineNW()
    end
    draw_curve(level)
end

Drawing(800, 800)
sierpinski_curve(10, 790, 3, 6)
finish()
preview()
