import "dome" for Window
import "graphics" for Canvas, Color
import "./iterate" for Indexed, Stepped
import "./seq" for Lst
import "./fmt" for Fmt
import "./plot" for Axes

// Python modulo operator (not same as Wren's)
var pmod = Fn.new { |x, y| ((x % y) + y) % y }

var squareCache = []

"""
    Get the points for each step along a Babylonian spiral of `nsteps` steps.
    Origin is at (0, 0) with first step one unit in the positive direction along
    the vertical (y) axis. The other points are selected to have integer x and y
    coordinates, progressively concatenating the next longest vector with integer
    x and y coordinates on the grid. The direction change of the  new vector is
    chosen to be nonzero and clockwise in a direction that minimizes the change
    in direction from the previous vector.

    See also: oeis.org/A256111, oeis.org/A297346, oeis.org/A297347
"""
var babylonianSpiral = Fn.new { |nsteps|
    for (x in 0...nsteps) squareCache.add(x*x)
    var dxys = [[0, 0], [0, 1]]
    var dsq = 1
    for (i in 0...nsteps) {
        var x = dxys[-1][0]
        var y = dxys[-1][1]
        var theta = y.atan(x)
        var candidates = []
        while (candidates.isEmpty) {
            dsq = dsq + 1
            for (se in Indexed.new(squareCache)) {
                var i = se.index
                var a = se.value
                if (a > (dsq/2).floor) break
                for (j in dsq.sqrt.floor + 1...0) {
                    var b = squareCache[j]
                    if ((a + b) < dsq) break
                    if ((a + b) == dsq) {
                        candidates.addAll([ [i, j], [-i, j], [i, -j], [-i, -j],
                                            [j, i], [-j, i], [j, -i], [-j, -i] ])
                    }
                }
            }
        }
        var comparer = Fn.new { |d| pmod.call(theta - d[1].atan(d[0]), Num.tau) }
        candidates.sort { |a, b| comparer.call(a) < comparer.call(b) }
        dxys.add(candidates[0])
    }

    var accs = []
    var sumx = 0
    var sumy = 0
    for (dxy in dxys) {
        sumx = sumx + dxy[0]
        sumy = sumy + dxy[1]
        accs.add([sumx, sumy])
    }
    return accs
}

// find first 10,000 points
var Points10000 = babylonianSpiral.call(9998) // first two added automatically

// print first 40 to terminal
System.print("The first 40 Babylonian spiral points are:")
for (chunk in Lst.chunks(Points10000[0..39], 10)) Fmt.print("$-9s", chunk)

class Main {
    construct new() {
        Window.title = "Babylonian spiral"
        Canvas.resize(1000, 1000)
        Window.resize(1000, 1000)
        Canvas.cls(Color.white)
        var axes = Axes.new(100, 900, 800, 800, -1000..11000, -5000..10000)
        axes.draw(Color.black, 2)
        var xMarks = Stepped.new(0..10000, 2000)
        var yMarks = Stepped.new(-5000..10000, 5000)
        axes.label(xMarks, yMarks, Color.black, 2, Color.black)
        axes.line(-1000, 10000, 11000, 10000, Color.black, 2)
        axes.line(11000, -5000, 11000, 10000, Color.black, 2)
        axes.lineGraph(Points10000, Color.black, 2)
    }

    init() {}

    update() {}

    draw(alpha) {}
}

var Game = Main.new()
