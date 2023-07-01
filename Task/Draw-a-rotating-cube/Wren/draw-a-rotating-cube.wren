import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math

var Nodes = [
    [-1, -1, -1],
    [-1, -1,  1],
    [-1,  1, -1],
    [-1,  1,  1],
    [ 1, -1, -1],
    [ 1, -1,  1],
    [ 1,  1, -1],
    [ 1,  1,  1]
]

var Edges = [
    [0, 1],
    [1, 3],
    [3, 2],
    [2, 0],
    [4, 5],
    [5, 7],
    [7, 6],
    [6, 4],
    [0, 4],
    [1, 5],
    [2, 6],
    [3, 7]
]

class RotatingCube {
    construct new(width, height) {
        Window.title = "Rotating cube"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _width = width
        _height = height
        _fore = Color.blue
    }

    init() {
        scale(100)
        rotateCube(Num.pi / 4, Math.atan(2.sqrt))
        drawCube()
    }

    update() {
        rotateCube(Num.pi / 180, 0)
    }

    draw(alpha) {
        drawCube()
    }

    scale(s) {
        for (node in Nodes) {
            node[0] = node[0] * s
            node[1] = node[1] * s
            node[2] = node[2] * s
        }
    }

    drawCube() {
        Canvas.cls(Color.white)
        Canvas.offset(_width / 2, _height / 2)
        for (edge in Edges) {
            var xy1 = Nodes[edge[0]]
            var xy2 = Nodes[edge[1]]
            Canvas.line(Math.round(xy1[0]), Math.round(xy1[1]),
                        Math.round(xy2[0]), Math.round(xy2[1]), _fore)
        }
        for (node in Nodes) {
            Canvas.rectfill(Math.round(node[0]) - 4, Math.round(node[1]) - 4, 8, 8, _fore)
        }
    }

    rotateCube(angleX, angleY) {
        var sinX = Math.sin(angleX)
        var cosX = Math.cos(angleX)
        var sinY = Math.sin(angleY)
        var cosY = Math.cos(angleY)
        for (node in Nodes) {
            var x = node[0]
            var y = node[1]
            var z = node[2]
            node[0] = x * cosX - z * sinX
            node[2] = z * cosX + x * sinX
            z = node[2]
            node[1] = y * cosY - z * sinY
            node[2] = z * cosY + y * sinY
        }
    }
}

var Game = RotatingCube.new(640, 640)
