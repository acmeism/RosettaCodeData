import "graphics" for Canvas, Color
import "dome" for Window
import "math" for Math
import "./lsystem" for LSystem, Rule

var TwoPi = Num.pi * 2

class KochSnowflake {
    construct new(width, height, back, fore) {
        Window.title = "Koch Snowflake"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _bc = back
        _fc = fore
    }

    init() {
        Canvas.cls(_bc)
        var cx = 80
        var cy = 270
        var theta = Num.pi/2
        var h = 9
        var lsys = LSystem.new(
            ["F"],                        //  variables
            ["+", "-"],                   //  constants
            "F--F--F",                    //  axiom
            [Rule.new("F", "F+F--F+F")],  //  rules
            Num.pi / 3                    //  angle (60 degrees in radians)
        )
        var result = lsys.iterate(3)
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

var Game = KochSnowflake.new(400, 400, Color.blue, Color.yellow)
