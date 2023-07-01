import "dome" for Window
import "graphics" for Canvas, Color

// signifies the white edges on the blue squares
var LT = 0
var TR = 1
var RB = 2
var BL = 3

var Edges = [
    [LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB],
    [LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL],
    [TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL],
    [TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT],
    [RB, TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT],
    [RB, RB, TR, TR, LT, LT, BL, BL, RB, RB, TR, TR],
    [BL, RB, RB, TR, TR, LT, LT, BL, BL, RB, RB, TR],
    [BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB, RB],
    [LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB],
    [LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL],
    [TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL],
    [TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT]
]

var Light_olive = Color.hex("#d3d004")
var Pale_blue   = Color.hex("#3250ff")

var W = Color.white
var B = Color.black

var Colors = [
    [W, B, B, W],
    [W, W, B, B],
    [B, W, W, B],
    [B, B, W, W]
]

class PeripheralDrift {
    construct new() {
        Window.resize(1000, 1000)
        Canvas.resize(1000, 1000)
        Window.title = "Peripheral drift illusion"
    }

    init() {
        Canvas.cls(Light_olive)
        for (x in 0..11) {
            var px = 90 + x * 70
            for (y in 0..11) {
                var py = 90 + y * 70
                Canvas.rectfill(px, py, 50, 50, Pale_blue)
                drawEdge(px, py, Edges[y][x])
            }
        }
    }

    drawEdge(px, py, edge) {
        var c = Colors[edge]
        Canvas.line(px, py, px + 46, py, c[0], 4)
        Canvas.line(px + 46, py, px + 46, py + 46, c[1], 4)
        Canvas.line(px, py + 46, px + 46, py + 46, c[2], 4)
        Canvas.line(px, py + 46, px, py, c[3], 4)
    }

    update() {}

    draw(alpha) {}
}

var Game = PeripheralDrift.new()
