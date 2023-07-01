import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

var Deg72 = 72 * Num.pi / 180  // 72 degrees in radians
var ScaleFactor = 1 / (2 + Math.cos(Deg72) * 2)
var Palette = [Color.red, Color.blue, Color.green, Color.indigo, Color.brown]
var ColorIndex = 0
var OldX = 0
var OldY = 0

class SierpinskiPentagon {
    construct new(width, height) {
        Window.title = "Sierpinksi Pentagon"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
    }

    init() {
        var order = 5  // can also set this to 1, 2, 3, or 4
        var hw = _w / 2
        var margin = 20
        var radius = hw - 2 * margin
        var side = radius * Math.sin(Num.pi/5) * 2
        drawPentagon(hw, 3 * margin, side, order - 1)
    }

    drawPentagon(x, y, side, depth) {
        var angle = 3 * Deg72
        if (depth == 0) {
            var col = Palette[ColorIndex]
            OldX = x
            OldY = y
            for (i in 0..4) {
                x = x + Math.cos(angle) * side
                y = y - Math.sin(angle) * side
                Canvas.line(OldX, OldY, x, y, col, 2)
                OldX = x
                OldY = y
                angle = angle + Deg72
            }
            ColorIndex = (ColorIndex + 1) % 5
        } else {
            side = side * ScaleFactor
            var dist = side * (1 + Math.cos(Deg72) * 2)
            for (i in 0..4) {
                x = x + Math.cos(angle) * dist
                y = y - Math.sin(angle) * dist
                drawPentagon(x, y, side, depth-1)
                angle = angle + Deg72
            }
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = SierpinskiPentagon.new(640, 640)
