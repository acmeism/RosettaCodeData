using Luxor, Colors

function house(🐢, x, y, siz)
    oldorientation = 🐢.orientation
    xpos, ypos = 🐢.xpos, 🐢.ypos
    # house wall
    Reposition(🐢, x, y)
    Rectangle(🐢, siz, siz)
    # roof
    Reposition(🐢, x - siz / 2, y -  siz / 2)
    Turn(🐢, -60)
    Forward(🐢, siz)
    Turn(🐢, 120)
    Forward(🐢, siz)
    # turtle_demo
    doorheight, doorwidth = siz / 2, siz / 4
    Pencolor(🐢, 0, 0, 0)
    Reposition(🐢, x, y + doorheight / 2)
    Rectangle(🐢, doorwidth, doorheight)
    # window
    windowheight, windowwidth = siz /3, siz / 4
    Reposition(🐢, x + siz / 4, y - siz / 4)
    Rectangle(🐢, windowwidth, windowheight)
    Reposition(🐢, x - siz / 4, y - siz / 4)
    Rectangle(🐢, windowwidth, windowheight)
    Orientation(🐢, oldorientation)
    Reposition(🐢, xpos, ypos)
end

function barchart(🐢, data, x, y, siz)
    oldorientation = 🐢.orientation
    xpos, ypos = 🐢.xpos, 🐢.ypos
    maxdata = maximum(data)
    # scale to fit within a square with sides `siz` and draw bars of chart
    barwidth = siz / length(data)
    Pencolor(🐢, 1.0, 0.0, 0.5)
    Reposition(🐢, x, y)
    for n in data  # draw each bar in chart
        barheight = n * siz / maxdata
        Reposition(🐢, x, y - barheight / 2)
        Rectangle(🐢, barwidth, barheight)
        x += barwidth
    end
    Orientation(🐢, oldorientation)
    Reposition(🐢, xpos, ypos)
end

function testturtle(width = 400, height = 600)
    dra = Drawing(600, 400, "turtle_demo.png")
    origin()
    background("midnightblue")
    🐢 = Turtle()
    Pencolor(🐢, "cyan")
    Penwidth(🐢, 1.5)
    house(🐢, -width / 3, height / 7, width / 2)
    barchart(🐢, [15, 10, 50, 35, 20], width / 8, height / 8, width / 2)
    finish()
end

testturtle()
