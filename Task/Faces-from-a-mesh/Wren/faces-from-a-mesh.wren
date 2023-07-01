import "./sort" for Sort
import "./seq" for Lst
import "./fmt" for Fmt

// Check two perimeters are equal.
var perimEqual = Fn.new { |p1, p2|
    var le = p1.count
    if (le != p2.count) return false
    for (p in p1) {
        if (!p2.contains(p)) return false
    }
    // use copy to avoid mutating 'p1'
    var c = p1.toList
    for (r in 0..1) {
        for (i in 0...le) {
            if (Lst.areEqual(c, p2)) return true
            // do circular shift to right
            Lst.rshift(c)
        }
        // now process in opposite direction
        Lst.reverse(c) // reverses 'c' in place
    }
    return false
}

var faceToPerim = Fn.new { |face|
    // use copy to avoid mutating 'face'
    var le = face.count
    if (le == 0) return []
    var edges = List.filled(le, null)
    for (i in 0...le) {
        // check edge pairs are in correct order
        if (face[i][1] <= face[i][0]) return []
        edges[i] = [face[i][0], face[i][1]]
    }
    // sort edges in ascending order
    var cmp = Fn.new { |e1, e2|
        if (e1[0] != e2[0]) {
            return (e1[0] - e2[0]).sign
        }
        return (e1[1] - e2[1]).sign
    }
    Sort.insertion(edges, cmp)
    var first = edges[0][0]
    var last  = edges[0][1]
    var perim = [first, last]
    // remove first edge
    edges.removeAt(0)
    le = le - 1
    while (le > 0) {
        var i = 0
        var outer = false
        var cont = false
        for (e in edges) {
            var found = false
            if (e[0] == last) {
                perim.add(e[1])
                last = e[1]
                found = true
            } else if (e[1] == last) {
                perim.add(e[0])
                last = e[0]
                found = true
            }
            if (found) {
                // remove i'th edge
                edges.removeAt(i)
                le = le - 1
                if (last == first) {
                    if (le == 0) {
                        outer = true
                        break
                    } else {
                        return []
                    }
                }
                cont = true
                break
            }
            i = i + 1
        }
        if (outer && !cont) break
    }
    return perim[0..-2]
}

System.print("Perimeter format equality checks:")
var areEqual = perimEqual.call([8, 1, 3], [1, 3, 8])
System.print("  Q == R is %(areEqual)")
areEqual = perimEqual.call([18, 8, 14, 10, 12, 17, 19], [8, 14, 10, 12, 17, 19, 18])
System.print("  U == V is %(areEqual)")
var e = [[7, 11], [1, 11], [1, 7]]
var f = [[11, 23], [1, 17], [17, 23], [1, 11]]
var g = [[8, 14], [17, 19], [10, 12], [10, 14], [12, 17], [8, 18], [18, 19]]
var h = [[1, 3], [9, 11], [3, 11], [1, 11]]
System.print("\nEdge to perimeter format translations:")
var i = 0
for (face in [e, f, g, h]) {
    var perim = faceToPerim.call(face)
    if (perim.isEmpty) {
        Fmt.print("  $c => Invalid edge format", i + 69) // 'E' is ASCII 69
    } else {
        Fmt.print("  $c => $n", i + 69, perim)
    }
}
