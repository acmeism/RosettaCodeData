var MAXN = 2500
var EPS  = 1e-8

class Vect {
    construct new(x, y, z, id) {
        _x  = x
        _y  = y
        _z  = z
        _id = id
    }

    static new(x, y, z) { new(x, y, z, 0) }

    x      { _x      }
    x=(v)  { _x = v  }
    y      { _y      }
    y=(v)  { _y = v  }
    z      { _z      }
    z=(v)  { _z = v  }
    id     { _id     }
    id=(v) { _id = v }

    -(other) { Vect.new(_x - other.x, _y - other.y, _z - other.z) }

    /(other) {
        return Vect.new(_y * other.z - _z * other.y,
                        _z * other.x - _x * other.z,
                        _x * other.y - _y * other.x)
    }

    *(other) { _x * other.x + _y * other.y + _z * other.z }

    m { (this * this).sqrt }

    ==(other) { _x == other.x && _y == other.y && _z == other.z }

    toString { "Vect(%(_x), %(_y), %(_z), %(_id))" }
}

class Line {
    construct new(u, v) {
        _u = u
        _v = v
    }

    u     { _u     }
    u=(x) { _u = x }
    v     { _v     }
    v=(x) { _v = x }
}

class Plane {
    construct new(u, v, w) {
        _vec = (u && v && w) ? [u, v, w] : [null, null, null]
    }

    static new() { new(null, null, null) }

    normal { (_vec[1] - _vec[0]) / (_vec[2] - _vec[0]) }

    u { _vec[0] }
    v { _vec[1] }
    w { _vec[2] }
}

var Gtr = Fn.new { |a, b| a - b > EPS }

var eq  = Fn.new { |a, b| -EPS < a - b && a - b < EPS }

var abs = Fn.new { |x| Gtr.call(0, x) ? -x : x }

// Signed distance.
var distPointPlane = Fn.new { |v, p| (v - p.u) * p.normal / p.normal.m }

// Unsigned distance
var distPointLine = Fn.new { |v, f|
    if ((v - f.u).m > 0) {
        return ((f.v - f.u) / (v - f.u)).m / (f.v - f.u).m
    }
    return 0
}

var distPointPoint = Fn.new { |u, v| (u - v).m }

var isAbove = Fn.new { |v, p| Gtr.call((v - p.u) * p.normal, 0) }

// Convex Hull Structures

var TIME = 0

class Facet {
    construct new(id, p) {
        // neighbor，corresponds to point (u->v, v->w, w->u)
        _n = [0, 0, 0]
        _id = id
        // access timestamp
        _vistime = 0
        _isdel = false
        _p = p ? p : Plane.new()
    }

    static new() { new(0, null) }

    n       { _n      }
    id      { _id     }
    id =(i) { _id = i }
    p       { _p      }
    p =(v)  { _p  = v }

    vistime     { _vistime     }
    vistime=(v) { _vistime = v }
    isdel       { _isdel       }
    isdel=(v)   { _isdel = v   }

    setN(n1, n2, n3) { _n = [n1, n2, n3] }

    toString { "Facet(id=%(_id), isdel=%(_isdel), vistime=%(_vistime))" }
}

// Edge of the horizon.
class Edge {
    construct new() {
        _netid = 0
        _facetid = 0
    }

    netid       { _netid       }
    netid=(v)   { _netid = v   }
    facetid     { _facetid     }
    facetid=(v) { _facetid = v }
}

// Store all faces.
var FAC = []

class ConvexHulls3d {
    construct new(index) {
        // Index face.
        _index = index
        _surfaceArea = 0
    }

    index     { _index     }
    index=(i) { _index = i }

    dfsArea(nf) {
        // Already visited in current timestamp.
        if (FAC[nf].vistime == TIME) return
        FAC[nf].vistime = TIME
        // Check if plane is intialized.
        if (FAC[nf].p.normal) _surfaceArea = _surfaceArea + FAC[nf].p.normal.m / 2
        for (i in 0..2) dfsArea(FAC[nf].n[i])
    }

    getSurfaceArea() {
        if (Gtr.call(_surfaceArea, 0)) return _surfaceArea
        TIME = TIME + 1
        dfsArea(_index)
        return _surfaceArea
    }

    getHorizon(f, p, vistime, e1, e2, resfdel) {
        if (!isAbove.call(p, FAC[f].p)) return 0
        if (FAC[f].vistime == TIME) return -1
        FAC[f].vistime = TIME
        // Mark the deleted face.
        FAC[f].isdel = true
        resfdel.add(FAC[f].id)
        var ret = -2
        for (i in 0..2) {
            var res = getHorizon(FAC[f].n[i], p, vistime, e1, e2, resfdel)
            if (res == 0) {
                var pt = [FAC[f].p.vec[i].id, FAC[f].p.vec[(i + 1) % 3].id]
                for (j in 0..1) {
                    if (vistime[pt[j]] != TIME) {
                        vistime[pt[j]] = TIME
                        e1[pt[j]].netid = pt[(j + 1) % 2]
                        e1[pt[j]].facetid = FAC[f].n[i]
                    } else {
                        e2[pt[j]].netid = pt[(j + 1) % 2]
                        e2[pt[j]].facetid = FAC[f].n[i]
                    }
                }
                ret = pt[0]
            } else if (res != -1 && res != -2) {
                // The face is enclosed in the middle.
                ret = res
            }
        }
        return ret
    }
}

// Global points.
var pts = []

// Construct initial simplex.
var getStart = Fn.new { |point, totp|
    var pt = [point[1]] * 6
    var s  = [point[1]] * 4

    // Find the maximum point of the coordinate axis.
    var i = 2
    while (i < totp + 1) {
        if (Gtr.call(point[i].x, pt[0].x)) pt[0] = point[i]
        if (Gtr.call(pt[1].x, point[i].x)) pt[1] = point[i]
        if (Gtr.call(point[i].y, pt[2].y)) pt[2] = point[i]
        if (Gtr.call(pt[3].y, point[i].y)) pt[3] = point[i]
        if (Gtr.call(point[i].z, pt[4].z)) pt[4] = point[i]
        if (Gtr.call(pt[5].z, point[i].z)) pt[5] = point[i]
        i = i + 1
    }

    // Take the two points with the largest distance.
    for (i in 0..5) {
        var j = i + 1
        while (j < 6) {
            if (Gtr.call(distPointPoint.call(pt[i], pt[j]), distPointPoint.call(s[0], s[1]))) {
                s[0] = pt[i]
                s[1] = pt[j]
            }
            j = j + 1
        }
    }

    // Take the point farthest from the line connecting the two points.
    for (i in 0..5) {
        if (Gtr.call(distPointLine.call(pt[i], Line.new(s[0], s[1])),
                     distPointLine.call(s[2], Line.new(s[0], s[1])))) {
            s[2] = pt[i]
        }
    }

    // Take the point farthest from the face.
    for (i in 1...totp + 1){
        if (Gtr.call(abs.call(distPointPlane.call(point[i], Plane.new(s[0], s[1], s[2]))),
                     abs.call(distPointPlane.call(s[3], Plane.new(s[0], s[1], s[2]))))) {
            s[3] = point[i]
        }
    }

    // Ensure that the constructed face faces outwards.
    if (Gtr.call(0, distPointPlane.call(s[3], Plane.new(s[0], s[1], s[2])))) {
        s.swap(1, 2)
    }

    // Construct simplex
    var f = List.filled(4, 0)
    for (i in 0..3) {
        FAC.add(Facet.new(FAC.count, null))
        f[i] = FAC.count - 1
    }

    FAC[f[0]].p = Plane.new(s[0], s[2], s[1])  // Bottom face
    FAC[f[1]].p = Plane.new(s[0], s[1], s[3])
    FAC[f[2]].p = Plane.new(s[1], s[2], s[3])
    FAC[f[3]].p = Plane.new(s[2], s[0], s[3])

    FAC[f[0]].setN(f[3], f[2], f[1])
    FAC[f[1]].setN(f[0], f[2], f[3])
    FAC[f[2]].setN(f[0], f[3], f[1])
    FAC[f[3]].setN(f[0], f[1], f[2])

    // Assign point set space to four faces.
    for (i in 0..3) pts.add([])

    // Assign points to four faces.
    for (i in 1...totp + 1) {
        if (point[i] == s[0] || point[i] == s[1] || point[i] == s[2] || point[i] == s[3]) {
            continue
        }
        for (j in 0..3) {
            if (isAbove.call(point[i], FAC[f[j]].p)) {
                pts[f[j]].add(point[i])
                break
            }
        }
    }

    // Return the initial simplex, using a face as index.
    return ConvexHulls3d.new(f[0])
}

// Border line graph information.
var e = List.filled(2, null)
for (i in 0..1) {
    e[i] = List.filled(MAXN, null)
    for (j in 0...MAXN) e[i][j] = Edge.new()
}

// Timestamp of each point access.
var vistime = List.filled(MAXN, 0)
var que = []

// Save the newly constructed face.
var resfnew = []

// Save the deleted face
var resfdel = []

// Save the point to be allocated
var respt = []

var quickHull3d = Fn.new { |point, totp|
    var hull = getStart.call(point, totp)
    // Add the face of initial simplex to queue.
    var que = [hull.index]
    for (i in 0..2) que.add(FAC[hull.index].n[i])
    // snew saves index face of the final convex hull.
    var snew = 0

    while (!que.isEmpty) {

        var nf = que.removeAt(0)
        // Skip if the current face has been deleted.
        if (FAC[nf].isdel) continue
        // Skip if no vertices are allocated to the current face.
        if (pts[nf].isEmpty) {
            snew = nf
            continue
        }
        // Find the farthest point from the face.
        var p = pts[nf][0]
        for (i in 1...pts[nf].count) {
            if (Gtr.call(distPointPlane.call(pts[nf][i], FAC[nf].p), distPointPlane.call(p, FAC[nf].p))) {
                p = pts[nf][i]
            }
        }

        // Find the horizon
        TIME = TIME + 1
        resfdel = []
        // The current face must be deleted, so start dfs from current face
        var s = hull.getHorizon(nf, p, vistime, e[0], e[1], resfdel)

        // Iterate over horizon(go around a circle), construct new face.
        // When finding horizon, we can't know whether an edge is clockwise
        // or counterclockwise, so it needs to be judged here.
        resfnew = []
        TIME = TIME + 1
        var from  = 0  // the previous visited point
        var lastf = 0  // the last created face
        var fstf  = 0  // the first created face

        while (vistime[s] != TIME) {
            // Record whether the current point has been visited with timestamp.
            vistime[s] = TIME
            var net  = 0  // next point
            var f    = 0  // the unseen face connected to the current edge on horizon
            var fnew = 0  // new face

            // Make sure the traversal direction is correct.
            if (e[0][s].netid == from) {
                net = e[1][s].netid
                f   = e[1][s].facetid
            } else {
                net = e[0][s].netid
                f   = e[0][s].facetid
            }

            // Find the counterclockwise information of these two points on the adjacent face.
            var pt1 = -1
            var pt2 = -1
            for (i in 0..2) {
                if (point[s] == FAC[f].p.vec[i])   pt1 = i
                if (point[net] == FAC[f].p.vec[i]) pt2 = i
            }

            // Make sure pt1->pt2 is arranged counterclockwise by adjacent face points.
            if ((pt1 + 1) % 3 != pt2) {
                var t = pt1
                pt1 = pt2
                pt2 = t
            }

            // The face constructed in this way faces outward
            FAC.add(Facet.new(FAC.count, Plane.new(FAC[f].p.vec[pt2], FAC[f].p.vec[pt1], p)))
            fnew = FAC.count - 1
            pts.add([])
            resfnew.add(fnew)

            // Maintain adjacency information.
            FAC[fnew].n[0] = f
            FAC[f].n[pt1] = fnew
            if (lastf != 0) {
                // Can't determine whether to traverse clockwise or counterclockwise in advance.
                // Maintain adjacency information between new faces.
                if (FAC[fnew].p.vec[1] == FAC[lastf].p.vec[0]) {
                    FAC[fnew].n[1]  = lastf
                    FAC[lastf].n[2] = fnew
                } else {
                    FAC[fnew].n[2]  = lastf
                    FAC[lastf].n[1] = fnew
                }
            } else {
                fstf = fnew  // no new face yet
            }
            lastf = fnew
            from = s
            s = net
        }

        // Give the new face head and tail maintenance critical information.
        if (FAC[fstf].p.vec[1] == FAC[lastf].p.vec[0]) {
            FAC[fstf].n[1]  = lastf
            FAC[lastf].n[2] = fstf
        } else {
            FAC[fstf].n[2]  = lastf
            FAC[lastf].n[1] = fstf
        }

        // Get all the points to be assigned.
        respt = []
        for (i in 0...resfdel.count) {
            for (j in 0...pts[resfdel[i]].count) respt.add(pts[resfdel[i]][j])
            pts[resfdel[i]] = []
        }

        // Assign points.
        for (i in 0...respt.count) {
            if (respt[i] == p) continue  // skip the points used to create the new face
            for (j in 0...resfnew.count) {
                if (isAbove.call(respt[i], FAC[resfnew[j]].p)) {
                    pts[resfnew[j]].add(respt[i])
                    break  // make sure the points are not reassigned
                }
            }
        }

        // Add the new face to queue.
        for (i in 0...resfnew.count) que.add(resfnew[i])
    }
    hull.index = snew
    return hull
}

var preConvexHulls = Fn.new {
    // 0 for reservation
    pts.add([])
    FAC.add(Facet.new())
}

preConvexHulls.call()
var n = 4  // number of points
var point = List.filled(n + 1, null)  // 1-indexed to match original code
var myInput = [ [0, 0, 0], [1, 0, 0], [0, 1, 0], [0, 0, 1] ]

for (i in 1..n) {
    var x = myInput[i-1][0]
    var y = myInput[i-1][1]
    var z = myInput[i-1][2]
    point[i] = Vect.new(x, y, z, i)
}
var hull = quickHull3d.call(point, n)
var sa = hull.getSurfaceArea()
System.print((sa * 1000).round / 1000)
