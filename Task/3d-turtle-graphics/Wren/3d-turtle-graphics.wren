import "dome" for Window
import "graphics" for Canvas, Color
import "math" for Math
import "./turtle" for Turtle

class Main {
    construct new(width, height) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "3d turtle graphics"
        _w = width
        _h = height
    }

    init() {
        Canvas.cls(Color.white)
        _t = Turtle.new()
        drawHouse3D(_w/4)
        barChart([15, 10, 50, 35, 20], _w/3)
    }

    drawRectCuboid(x, y, hsize, vsize) {
        // draw front rectangle
        _t.drawRect(x, y, hsize, vsize)

        // draw back rectangle
        _t.drawRect(x + hsize/2, y - hsize/2, hsize, vsize)

        var side = ((2 * hsize * hsize).sqrt/2).floor

        // turn right 45 degrees
        _t.right(45)

        // goto bottom left front
        _t.goto(x, y + vsize)
        _t.walk(side)

        // goto top left front
        _t.goto(x, y)
        _t.walk(side)

        // goto bottom right front
        _t.goto(x + hsize, y + vsize)
        _t.walk(side)

        // goto top right front
        _t.goto(x + hsize, y)
        _t.walk(side)
    }

    drawHouse3D(size) {
        // save initial turtle position and direction
        var saveX = _t.x
        var saveY = _t.y
        var saveD = _t.dir

        _t.pen.width = 2

        // draw house
        drawRectCuboid(_w/8, _h/2, size, size)

        // draw roof
        _t.left(10)
        _t.goto(_w/8, _h/2)
        _t.walk(size)

        _t.dir = 63
        _t.walk((size*15/16).floor)
        _t.back((size*15/16).floor)

        _t.left(44)
        _t.walk((size*31/32).floor)
        _t.back((size*31/32).floor)
        _t.dir = 102
        _t.walk((size/3).floor)

        // draw door
        var doorWidth  = (size/4).floor
        var doorHeight = (size/2.5).floor
        _t.drawRect(_w/4 + doorWidth/2, _h/2 + (size/2).floor - doorHeight, doorWidth, doorHeight)

        // draw window
        var windWidth  = (size/3).floor
        var windHeight = (size/4).floor
        _t.drawRect(_w/4 + size/1.8, _h/2 + (size/2.8).floor - windHeight, windWidth, windHeight)

        // restore initial turtle position and direction
        _t.x = saveX
        _t.y = saveY
        _t.dir = saveD
    }

    // nums assumed to be all non-negative
    barChart(nums, size) {
        _t.pen.color = Color.brown

        // save intial turtle position and direction
        var saveX = _t.x
        var saveY = _t.y
        var saveD = _t.dir

        // find maximum
        var max = 0
        for (n in nums) if (n > max) max = n

        // scale to fit within a square with sides 'size' and draw chart
        var barWidth = (size / nums.count).floor
        var startX = _w / 2 + 20
        var startY = _h / 2
        for (i in 0...nums.count) { // nums.count) {
            var barHeight = (nums[i] * size / max).round
            drawRectCuboid(startX, startY - barHeight, barWidth, barHeight)
            startX = startX + barWidth
        }

        // restore intial turtle position and direction
        _t.x = saveX
        _t.y = saveY
        _t.dir = saveD
    }

    update() {}

    draw(alpha) {}
}

var Game = Main.new(800, 800)
