import "graphics" for Canvas, Color
import "dome" for Window
import "./polygon" for Polygon

class SutherlandHodgman {
    construct new(width, height, subject, clipper) {
        Window.title = "Sutherland-Hodgman"
        Window.resize(width, height)
        Canvas.resize(width, height)
        _subject = subject
        _result = subject.toList
        _clipper = clipper
    }

    init() {
        clipPolygon()
        System.print("Clipped polygon points:")
        for (p in _result) {
            p[1] = (1000*p[1]).round/1000
            System.print(p)
        }
        // display all 3 polygons
        Polygon.quick(_subject).drawfill(Color.blue)
        Polygon.quick(_clipper).drawfill(Color.red)
        Polygon.quick(_result ).drawfill(Color.green)
    }

    clipPolygon() {
        var len = _clipper.count
        for (i in 0...len) {
            var len2 = _result.count
            var input = _result
            _result = []
            var a = _clipper[(i + len - 1) % len]
            var b = _clipper[i]

            for (j in 0...len2) {
                var p = input[(j + len2 - 1) % len2]
                var q = input[j]

                if (isInside(a, b, q)) {
                    if (!isInside(a, b, p)) _result.add(intersection(a, b, p, q))
                    _result.add(q)
                } else if (isInside(a, b, p)) _result.add(intersection(a, b, p, q))
            }
        }
    }

    isInside(a, b, c) {  (a[0] - c[0]) * (b[1] - c[1]) > (a[1] - c[1]) * (b[0] - c[0]) }

    intersection(a, b, p, q) {
        var a1 = b[1] - a[1]
        var b1 = a[0] - b[0]
        var c1 = a1 * a[0] + b1 * a[1]

        var a2 = q[1] - p[1]
        var b2 = p[0] - q[0]
        var c2 = a2 * p[0] + b2 * p[1]

        var d = a1 * b2 - a2 * b1
        var x = (b2 * c1 - b1 * c2) / d
        var y = (a1 * c2 - a2 * c1) / d

        return [x, y]
    }
    update() {}

    draw(alpha) {}
}

var subject = [
    [ 50, 150], [200,  50], [350, 150],
    [350, 300], [250, 300], [200, 250],
    [150, 350], [100, 250], [100, 200]
]
var clipper = [
    [100, 100], [300, 100],
    [300, 300], [100, 300]
]
var Game = SutherlandHodgman.new(600, 500, subject, clipper)
