import "./fmt" for Fmt

class RayCasting {
    static intersects(a, b, p) {
        if (a[1] > b[1]) return intersects(b, a, p)
        if (p[1] == a[1] || p[1] == b[1]) p[1] = p[1] + 0.0001
        if (p[1] > b[1] || p[1] < a[1] || p[0] >= a[0].max(b[0])) return false
        if (p[0] < a[0].min(b[0])) return true
        var red  = (p[1] - a[1]) / (p[0] - a[0])
        var blue = (b[1] - a[1]) / (b[0] - a[0])
        return red >= blue
    }

    static contains(shape, pnt) {
        var inside = false
        var len = shape.count
        for (i in 0...len) {
            if (intersects(shape[i], shape[(i + 1) % len], pnt)) inside = !inside
        }
        return inside
    }

    static square { [[0, 0], [20, 0], [20, 20], [0, 20]] }

    static squareHole { [[0, 0], [20, 0], [20, 20], [0, 20], [5, 5], [15, 5], [15, 15], [5, 15]] }

    static strange { [[0, 0], [5, 5], [0, 20], [5, 15], [15, 15], [20, 20], [20, 0]] }

    static hexagon { [[6, 0], [14, 0], [20, 10], [14, 20], [6, 20], [0, 10]] }

    static shapes { [square, squareHole, strange, hexagon] }
}

var testPoints = [[10, 10], [10, 16], [-20, 10], [0, 10], [20, 10], [16, 10], [20, 20]]
for (shape in RayCasting.shapes) {
    for (pnt in testPoints) Fmt.write("$7s ", RayCasting.contains(shape, pnt))
    System.print()
}
