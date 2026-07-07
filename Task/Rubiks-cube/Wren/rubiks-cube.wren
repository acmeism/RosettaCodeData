import "graphics" for Canvas, Color
import "dome" for Window
import "./polygon" for Polygon

/*
    Represents a 3D representation of a Rubik's cube with colored squares.
    The cube is drawn in a 3D perspective, with each face represented by a square.
    The colors of the squares can be customized to represent different states of the cube.
    The squares are set up as scrambled. Squares on the front face are colored red,
    green, and blue, squares on the right face are colored orange, white and blue, and
    squares on the top face are colored yellow, orange, and white.
*/
class RubiksCube {
    construct new() {
        Window.title = "Rubik's cube"
        Window.resize(400, 400)
        Canvas.resize(400, 400)
        Canvas.cls(Color.white)
    }

    init() { drawCube() }

    // Helper function fills polygon with given color
    // and outlines it in black.
    drawCell(corners, color, width) {
        var poly = Polygon.quick(corners)
        poly.drawfill(color)
        poly.draw(Color.black, width)
    }

    drawCube() {
        var width = 2  // outline width for the cube edges
        var s = 40    // cell size in pixels
        var skx = 20  // horizonal skew per depth step
        var sky = -12 // vertical skew per depth step (negative = upward on the screen)
        var fx = 110  // bottom left corner of the front face,
        var fy = 278  // chosen to center cube in the drawing

        // color tables
        var frontColors = [
            [Color.red,  Color.red,  Color.green],
            [Color.red,  Color.blue, Color.green],
            [Color.blue, Color.blue, Color.green]
        ]
        var topColors = [
            [Color.yellow, Color.orange, Color.white],
            [Color.yellow, Color.orange, Color.white],
            [Color.yellow, Color.orange, Color.white]
        ]
        var rightColors = [
            [Color.orange, Color.orange, Color.orange],
            [Color.white,  Color.white,  Color.white],
            [Color.blue,   Color.blue,   Color.blue]
        ]

        // front face
        for (j in 0..2) {
            for (i in 0..2) {
                var x = fx + i * s
                var y = fy - (3 - j) * s
                var corners = [
                    [x, y], [x + s, y], [x + s, y + s], [x, y + s]
                ]
                drawCell(corners, frontColors[j][i], width)
            }
        }

        // top face
        for (k in 0..2) {
            for (i in 0..2) {
                var x0 = fx + i * s + k * skx
                var y0 = fy - 3 * s + k * sky
                var corners =  [
                    [x0,           y0],
                    [x0 + s,       y0],
                    [x0 + s + skx, y0 + sky],
                    [x0 + skx,     y0 + sky]
                ]
                drawCell(corners, topColors[k][i], width)
            }
        }

        // right face
        for (k in 0..2) {
            for (j in 0..2) {
                var x0 = fx + 3 * s + k * skx
                var y0 = fy - (3 - j) * s + k * sky
                var corners =  [
                    [x0,       y0],
                    [x0 + skx, y0 + sky],
                    [x0 + skx, y0 + sky + s],
                    [x0,       y0 + s]
                ]
                drawCell(corners, rightColors[j][k], width)
            }
        }
    }

    update() {}

    draw(alpha) {}
}

var Game = RubiksCube.new()
