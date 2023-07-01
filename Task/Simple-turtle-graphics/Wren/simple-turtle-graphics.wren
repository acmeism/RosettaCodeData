import "dome" for Window
import "graphics" for Canvas, Color
import "./turtle" for Turtle

class Main {
    construct new(width, height) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "Simple turtle graphics"
        _w = width
        _h = height
    }

    init() {
        Canvas.cls(Color.white)
        _t = Turtle.new()
        drawHouse(_w/4)
        barChart([15, 10, 50, 35, 20], _w/3)
    }

    drawHouse(size) {
        // save initial turtle position and direction
        var saveX = _t.x
        var saveY = _t.y
        var saveD = _t.dir

        _t.pen.width = 2

        // draw house
        _t.drawRect(_w/4, _h/2, size, size)

        // draw roof
        _t.right(30)
        _t.walk(size)
        _t.right(120)
        _t.walk(size)

        // draw door
        var doorWidth  = (size/4).floor
        var doorHeight = (size/2).floor
        _t.drawRect(_w/4 + doorWidth/2, _h/2 + doorHeight, doorWidth, doorHeight)

        // draw window
        var windWidth  = (size/3).floor
        var windHeight = (size/4).floor
        _t.drawRect(_w/4 + size/2, _h/2 + size/2, windWidth, windHeight)

        // restore initial turtle position and direction
        _t.x = saveX
        _t.y = saveY
        _t.dir = saveD
    }

    // nums assumed to be all non-negative
    barChart(nums, size) {
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
        for (i in 0...nums.count) {
            var barHeight = (nums[i] * size / max).round
            _t.drawRect(startX, startY - barHeight, barWidth, barHeight)
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

var Game = Main.new(600, 600)
