var centroid = Fn.new { |pts|
    var n = pts.count
    if (n == 0) Fiber.abort("List must contain at least one point.")
    var d = pts[0].count
    if (pts.skip(1).any { |p| p.count != d }) {
        Fiber.abort("Points must all have the same dimension.")
    }
    var res = List.filled(d, 0)
    for (j in 0...d) {
        for (i in 0...n) {
            res[j] = res[j] + pts[i][j]
        }
        res[j] = res[j] / n
    }
    return res
}

var points = [
    [ [1], [2], [3] ],
    [ [8, 2], [0, 0] ],
    [ [5, 5, 0], [10, 10, 0] ],
    [ [1, 3.1, 6.5], [-2, -5, 3.4], [-7, -4, 9], [2, 0, 3] ],
    [ [0, 0, 0, 0, 1], [0, 0, 0, 1, 0], [0, 0, 1, 0, 0], [0, 1, 0, 0, 0] ]
]

for (pts in points) {
    System.print("%(pts) => Centroid: %(centroid.call(pts))")
}
