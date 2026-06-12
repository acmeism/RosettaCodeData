import "./vector" for Vector2
import "./dynamic" for Tuple

var Projection = Tuple.create("Projection", ["min", "max"])

/* In the following a polygon is represented as a list of vertices
   and a vertex by a pair of x, y coordinates in the plane. */

var getAxes = Fn.new { |poly|
    var axes = List.filled(poly.count, null)
    for (i in 0...poly.count) {
        var vertex1 = poly[i]
        var vertex2 = poly[(i+1 == poly.count) ? 0 : i+1]
        var vector1 = Vector2.new(vertex1[0], vertex1[1])
        var vector2 = Vector2.new(vertex2[0], vertex2[1])
        var edge = vector1 - vector2
        axes[i] = edge.perp
    }
    return axes
}

var projectOntoAxis = Fn.new { |poly, axis|
    var vertex0 = poly[0]
    var vector0 = Vector2.new(vertex0[0], vertex0[1])
    var min = axis.dot(vector0)
    var max = min
    for (i in 1...poly.count) {
        var vertex = poly[i]
        var vector = Vector2.new(vertex[0], vertex[1])
        var p = axis.dot(vector)
        if (p < min) {
            min = p
        } else if (p > max) {
            max = p
        }
    }
    return Projection.new(min, max)
}

var projectionsOverlap = Fn.new { |proj1, proj2|
    if (proj1.max < proj2.min) return false
    if (proj2.max < proj1.min) return false
    return true
}

var polygonsOverlap = Fn.new { |poly1, poly2|
    var axes1 = getAxes.call(poly1)
    var axes2 = getAxes.call(poly2)
    for (axes in [axes1, axes2]) {
        for (axis in axes) {
            var proj1 = projectOntoAxis.call(poly1, axis)
            var proj2 = projectOntoAxis.call(poly2, axis)
            if (!projectionsOverlap.call(proj1, proj2)) return false
        }
    }
    return true
}

var poly1 = [[0, 0], [0, 2], [1, 4], [2, 2], [2, 0]]
var poly2 = [[4, 0], [4, 2], [5, 4], [6, 2], [6, 0]]
var poly3 = [[1, 0], [1, 2], [5, 4], [9, 2], [9, 0]]
System.print("poly1 = %(poly1)")
System.print("poly2 = %(poly2)")
System.print("poly3 = %(poly3)")
System.print()
System.print("poly1 and poly2 overlap? %(polygonsOverlap.call(poly1, poly2))")
System.print("poly1 and poly3 overlap? %(polygonsOverlap.call(poly1, poly3))")
System.print("poly2 and poly3 overlap? %(polygonsOverlap.call(poly2, poly3))")
