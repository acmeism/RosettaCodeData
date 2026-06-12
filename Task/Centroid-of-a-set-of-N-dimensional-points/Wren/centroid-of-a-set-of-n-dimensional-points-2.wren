import "./seq" for Lst
import "./math" for Nums

var centroid = Fn.new { |pts|
    return Lst.columns(pts).map { |c| Nums.mean(c) }.toList
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
