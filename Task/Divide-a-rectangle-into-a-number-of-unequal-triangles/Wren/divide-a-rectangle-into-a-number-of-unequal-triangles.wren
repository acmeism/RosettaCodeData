import "random" for Random
import "./seq" for Lst

var rand = Random.new()

var pointsOfRect = Fn.new { |w, h| [[0, 0], [h, 0], [h, w], [0, w]] }

var dist = Fn.new { |p1, p2|
    var dx = p2[0] - p1[0]
    var dy = p2[1] - p1[1]
    return (dx * dx + dy * dy).sqrt
}

// Heron's formula
var area = Fn.new { |tri|
    var a = dist.call(tri[1], tri[0])
    var b = dist.call(tri[2], tri[1])
    var c = dist.call(tri[0], tri[2])
    var s = (a + b + c) * 0.5
    return (s * (s - a) * (s - b) * (s - c)).sqrt
}

var divideRectIntoTris = Fn.new { |w, h, n|
    if (n.type != Num || !n.isInteger || n < 3) {
        Fiber.abort("'n' must be an integer >= 3.")
    }
    var pts = pointsOfRect.call(w, h)

    // upper triangle
    var upper = [pts[0], pts[1], pts[2]]
    var tris = [upper]

    // divide the side of the rectangle along the x-axis into
    // 'n-1' sections of different lengths
    var xs   = List.filled(n, 0)
    var lens = List.filled(n - 1, 0)
    xs[n-1] = w

    // need n-2 random numbers in the open interval (0, w)
    // it's very unlikely that the following loop will need more than one iteration
    while (!Lst.distinct(lens).count == n - 1 || lens.any { |l| l == 0 }) {
        for (i in 1..n-2) xs[i] = rand.float(w)
        xs.sort()
        for (i in 0..n-2) lens[i] = xs[i+1] - xs[i]
    }
    for (i in 0..n-2) tris.add([[xs[i], 0], pts[2], [xs[i+1], 0]])
    return tris
}

var dims = [ [20, 10, 4], [30, 20, 8] ]
for (dim in dims) {
    var w = dim[0]
    var h = dim[1]
    var n = dim[2]
    System.print("A rectangle with a lower left vertex at (0, 0), width %(w) and height %(h)")
    System.print("can be split into the following %(n) triangles:")

    // make sure all triangles have different areas
    while (true) {
        var areas = []
        var tris = divideRectIntoTris.call(w, h, n)
        for (tri in tris) areas.add(area.call(tri))
        if (Lst.distinct(areas).count == n) {
            System.print(tris.join("\n"))
            break
        }
    }
    System.print()
}
