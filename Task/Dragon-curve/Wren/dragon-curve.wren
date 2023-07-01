import "graphics" for Canvas, Color
import "dome" for Window

class Game {
   static init() {
        Window.title = "Dragon curve"
        Window.resize(800, 600)
        Canvas.resize(800, 600)
        var iter = 14
        var turns = getSequence(iter)
        var startingAngle = -iter * Num.pi / 4
        var side = 400 / 2.pow(iter/2)
        dragon(turns, startingAngle, side)
    }

    static getSequence(iterations) {
        var turnSequence = []
        for (i in 0...iterations) {
            var copy = []
            copy.addAll(turnSequence)
            if (copy.count > 1) copy = copy[-1..0]
            turnSequence.add(1)
            copy.each { |i| turnSequence.add(-i) }
        }
        return turnSequence
    }

    static dragon(turns, startingAngle, side) {
        var col = Color.blue
        var angle = startingAngle
        var x1 = 230
        var y1 = 350
        var x2 = x1 + (angle.cos * side).truncate
        var y2 = y1 + (angle.sin * side).truncate
        Canvas.line(x1, y1, x2, y2, col)
        x1 = x2
        y1 = y2
        for (turn in turns) {
            angle = angle + turn*Num.pi/2
            x2 = x1 + (angle.cos * side).truncate
            y2 = y1 + (angle.sin * side).truncate
            Canvas.line(x1, y1, x2, y2, col)
            x1 = x2
            y1 = y2
        }
    }

    static update() {}

    static draw(alpha) {}
}
