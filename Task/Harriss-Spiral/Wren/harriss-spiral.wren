import "dome" for Window
import "graphics" for Canvas, Color
import "math" for M
import "random" for Random
import "./ellipse" for Circle

var HR  = 1.3247  // Harriss ratio
var HR2 = HR * HR
var HR3 = HR2 * HR
var HR4 = HR2 * HR2
var HR5 = HR4 * HR
var HR6 = HR4 * HR2
var HR8 = HR4 * HR4
var LINES = false  // set to true to show construction lines
var Rand = Random.new()

class HarrissSpiral {
    construct new(width, height) {
        Window.title = "Harriss spiral"
        Window.resize(width, height)
        Canvas.resize(width, height)
        if (LINES) Canvas.cls(Color.white) else Canvas.cls(Color.darkgray)
        _w = width
        _h = height
    }

    // We always show the arcs so no need for a parameter for that.
    drawArcSegment(x, y, angle, length, iteration, arcColor, lineWidth, showLines) {
        var heading
        var radius
        var cx
        var cy
        var circle
        var adj
        if (iteration > 0) {
            var startAngle = angle + 45
            var endAngle = startAngle + 90

            var xEnd = x + length * M.cos(angle * Num.pi / 180)
            var yEnd = y + length * M.sin(angle * Num.pi / 180)

            if (M.floor(yEnd) < M.floor(y)) heading = "SN"  // 6
            if (M.floor(xEnd) < M.floor(x)) heading = "EW"  // 5
            if (M.floor(yEnd) > M.floor(y)) heading = "NS"  // 4
            if (M.floor(xEnd) > M.floor(x)) heading = "WE"  // 3

            if (showLines) Canvas.line(x, y, xEnd, yEnd, Color.black)

            radius = 0.70710678 * length

            if (heading == "SN") {
                cx = x - length / 2
                cy = y - length / 2
                arcColor = (Rand.int(2) == 1) ? Color.yellow : Color.green
            } else if (heading == "EW") {
                cx = x - length / 2
                cy = y + length / 2
                arcColor = Color.red
            } else if (heading == "NS") {
                cx = x + length / 2
                cy = y + length / 2
                arcColor = Color.blue
            } else if (heading == "WE") {
                cx = x + length / 2
                cy = y - length / 2
                arcColor = (Rand.int(2) == 1) ? Color.orange : Color.black
            }
            for (i in -lineWidth/2...lineWidth/2) {
                circle = Circle.new(cx, cy, radius + i)
                adj = lineWidth/8 - (i < 0 ? -i/4 : (i+1)/4)
                circle.drawArc(arcColor, startAngle - adj, endAngle + adj)
            }
            drawArcSegment(xEnd, yEnd, angle-90, length/HR, iteration-1, arcColor, lineWidth, showLines)
        }
    }

    drawSpiral() {
        var h = 600
        var sx = (_w/2 + 80) // starting x
        var sy = (_h - 140)  // starting y
        var il = h / HR2     // initial length

        drawArcSegment(sx + il/HR,  sy - (il + il/HR2),   0, il / HR4, 4, Color.green, 6, LINES)
        drawArcSegment(sx + il/HR4, sy - (il + il/HR2), 270, il / HR5, 3, Color.black, 6, LINES)
        drawArcSegment(sx - (il/HR + il/HR3), sy - (il + il/HR2), 270, il / HR5, 3, Color.black, 6, LINES)
        drawArcSegment(sx - (il/HR + il/HR3), sy - il/HR8, 180, il / HR6, 2, Color.blue, 6, LINES)
        drawArcSegment(sx - il/HR4, sy - il/HR3, -270, il / HR4, 3, Color.blue, 8, LINES)
        drawArcSegment(sx - il/HR4, sy - il/HR, 0, il / HR5, 2, Color.green, 8, LINES)
        drawArcSegment(sx - il/HR, sy - il, 270, il / HR2, 5, Color.red, 12, LINES)
        drawArcSegment(sx - il/HR, sy - il/HR3, 180, il / HR3, 4, Color.black, 12, LINES)
        drawArcSegment(sx, sy - il, 0, il / HR, 6, Color.black, 16, LINES)
        drawArcSegment(sx, sy, -90, il, 7, Color.orange, 16, LINES)
    }

    init() { drawSpiral() }

    update() {}

    draw(dt) {}
}

var Game = HarrissSpiral.new(1000, 800)
