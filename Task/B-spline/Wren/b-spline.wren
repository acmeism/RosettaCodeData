import "dome" for Window, Process
import "graphics" for Canvas, Color

class BSpline {
    construct new(width, height, cpoints, k) {
        Window.resize(width, height)
        Canvas.resize(width, height)
        Window.title = "B-spline curve"
        _p = cpoints
        _n = cpoints.count - 1
        _k = k
        _t = (1.._n + 1 + k).toList // use a uniform knot vector, delta = 1
    }

    // B-spline helper function
    w(i, k, x) { (_t[i+k] != _t[i]) ? (x - _t[i]) / (_t[i+k] - _t[i]) : 0 }

    // B-spline function
    b(i, k, x) {
        if (k == 1) return (_t[i] <= x  &&  x < _t[i + 1]) ? 1 : 0
        return w(i, k-1, x) * b(i, k-1, x) + (1 - w(i+1, k-1, x)) * b(i+1, k-1, x)
    }

    // B-spline points
    p() {
        var bpoints = []
        for (x in _t[_k-1]..._t[_n + 1]) {
            var sumX = 0
            var sumY = 0
            for (i in 0.._n) {
                var f = b(i, _k, x)
                sumX = sumX + f * _p[i][0]
                sumY = sumY + f * _p[i][1]
            }
            bpoints.add([sumX.round, sumY.round])
         }
         return bpoints
    }

    init() {
        if (_k > _n + 1 || _k < 1) {
            System.print("k (= %(_k)) can't be more than %(_n+1) or less than 1.")
            Process.exit()
        }
        var bpoints = p()
        // plot the curve
        for (i in 1...bpoints.count) {
            Canvas.line(bpoints[i-1][0], bpoints[i-1][1], bpoints[i][0], bpoints[i][1], Color.white)
        }
    }

    update() {}

    draw(alpha) {}
}

var cpoints = [
    [171, 171], [185, 111], [202, 109], [202, 189], [328, 160], [208, 254],
    [241, 330], [164, 252], [ 69, 278], [139, 208], [ 72, 148], [168, 172]
]
var k = 4 // polynomial degree is one less than this i.e. cubic
var Game = BSpline.new(400, 400, cpoints, k)
