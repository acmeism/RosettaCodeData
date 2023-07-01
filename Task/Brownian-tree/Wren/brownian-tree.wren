import "graphics" for Canvas, Color
import "dome" for Window
import "random" for Random

var Rand = Random.new()

var N8 = [
    [-1, -1], [-1, 0], [-1, 1],
    [ 0, -1],          [ 0, 1],
    [ 1, -1], [ 1, 0], [ 1, 1]
]

class BrownianTree {
    construct new(width, height, particles) {
        Window.title = "Brownian Tree"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _w = width
        _h = height
        _n = particles
    }

    init() {
        Canvas.cls(Color.brown)
        // off center seed position makes pleasingly asymetrical tree
        Canvas.pset(_w/3, _h/3, Color.white)
        var x = 0
        var y = 0
        var a = 0
        while (a < _n) {
            // generate random position for new particle
            x = Rand.int(_w)
            y = Rand.int(_h)
            var outer = false
            var p = Canvas.pget(x, y)
            if (p == Color.white) {
                // as position is already set, find a nearby free position.
                while (p == Color.white) {
                    x = x + Rand.int(3) - 1
                    y = y + Rand.int(3) - 1
                    var ok = x >= 0 && x < _w && y >= 0 && y < _h
                    if (ok) {
                        p = Canvas.pget(x, y)
                    } else { // out of bounds, consider particle lost
                        outer = true
                        a = a + 1
                        break
                    }
                }
            } else {
                // else particle is in free space
                // let it wonder until it touches tree
                while (!hasNeighbor(x, y)) {
                    x = x + Rand.int(3) - 1
                    y = y + Rand.int(3) - 1
                    var ok = x >= 0 && x < _w && y >= 0 && y < _h
                    if (ok) {
                        p = Canvas.pget(x, y)
                    } else { // out of bounds, consider particle lost
                        outer = true
                        a = a + 1
                        break
                    }
                }
            }
            if (outer) continue
            // x, y now specify a free position touching the tree
            Canvas.pset(x, y, Color.white)
            a = a + 1
            // progress indicator
            if (a % 100 == 0) System.print("%(a) of %(_n)")
            a = a + 1
        }
    }

    hasNeighbor(x, y) {
        for (n in N8) {
            var xn = x + n[0]
            var yn = y + n[1]
            var ok = xn >= 0 && xn < _w && yn >= 0 && yn < _h
            if (ok && Canvas.pget(xn, yn) == Color.white) return true
        }
        return false
    }

    update() {}

    draw(alpha) {}
}

var Game = BrownianTree.new(200, 150, 7500)
