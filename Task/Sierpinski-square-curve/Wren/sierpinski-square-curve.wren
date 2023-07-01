import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math
import "./lsystem" for LSystem, Rule

var TwoPi = Num.pi * 2

class SierpinskiSquareCurve {
    construct new(width, height, back, fore) {
        Window.title = "Sierpinski Square Curve"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _bc = back
        _fc = fore
    }

    init() {
        Canvas.cls(_bc)
        var cx = 10
        var cy = (_h/2).floor + 5
        var theta = 0
        var h = 6
        var lsys = LSystem.new(
            ["X"],                                    //  variables
            ["F", "+", "-"],                          //  constants
            "F+XF+F+XF",                              //  axiom
            [Rule.new("X", "XF-F+F-XF+F+XF-F+F-X")],  //  rules
            Num.pi / 2                                //  angle (90 degrees in radians)
        )
        var result = lsys.iterate(5)
        var operations = {
            "F": Fn.new {
                var newX = cx + h*Math.sin(theta)
                var newY = cy - h*Math.cos(theta)
                Canvas.line(cx, cy, newX, newY, _fc, 2)
                cx = newX
                cy = newY
            },
            "+": Fn.new {
                theta = (theta + lsys.angle) % TwoPi
            },
            "-": Fn.new {
                theta = (theta - lsys.angle) % TwoPi
            }
        }
        LSystem.execute(result, operations)
    }

    update() {}

    draw(alpha) {}
}

var Game = SierpinskiSquareCurve.new(770, 770, Color.blue, Color.yellow)
