import "/dynamic" for Tuple
import "/math" for Nums
import "/seq" for Lst
import "/sort" for Sort
import "random" for Random

// A Point is represented by a 2 element List of Nums
var PtSqd = Fn.new { |p, q| Nums.sum(Lst.zip(p, q).map { |r| (r[0] - r[1]) * (r[0] - r[1]) }) }

var HyperRect = Tuple.create("HyperRect", ["min", "max"])

var HrCopy = Fn.new { |hr| HyperRect.new(hr.min.toList, hr.max.toList) }

var NearestNeighbor = Tuple.create("NearestNeighbor", ["nearest", "distSqd", "nodesVisited"])

var KdNode = Tuple.create("KdNode", ["domElt", "split", "left", "right"])

class KdTree {
    construct new(pts, bounds) {
        var nk2 // recursive closure
        nk2 = Fn.new { |exset, split|
            if (exset.count == 0) return null
            var cmp = Fn.new { |p, q| (p[split] - q[split]).sign }
            Sort.quick(exset, 0, exset.count - 1, cmp)
            var m = (exset.count/2).floor
            var d = exset[m]
            while (m + 1 < exset.count && exset[m + 1][split] == d[split]) m = m + 1
            var s2 = split + 1
            if (s2 == d.count) s2 = 0
            return KdNode.new(
                d,
                split,
                nk2.call(exset[0...m], s2),
                nk2.call(exset[m + 1..-1], s2)
            )
        }
        _n = nk2.call(pts, 0)
        _bounds = bounds
    }

    nearest(p) { nn_(_n, p, _bounds, 1/0) }

    nn_(kd, target, hr, maxDistSqd) {
        if (!kd) return NearestNeighbor.new(null, 1/0, 0)
        var nodesVisited = 1
        var s = kd.split
        var pivot = kd.domElt
        var leftHr = HrCopy.call(hr)
        var rightHr = HrCopy.call(hr)
        leftHr.max[s] = pivot[s]
        rightHr.min[s] = pivot[s]
        var targetInLeft = target[s] <= pivot[s]
        var nearerKd  = (targetInLeft) ? kd.left : kd.right
        var nearerHr  = (targetInLeft) ? leftHr : rightHr
        var furtherKd = (targetInLeft) ? kd.right : kd.left
        var furtherHr = (targetInLeft) ? rightHr : leftHr
        var res = nn_(nearerKd, target, nearerHr, maxDistSqd)
        var nearest = res.nearest
        var distSqd = res.distSqd
        var nv = res.nodesVisited
        nodesVisited = nodesVisited + nv
        var maxDistSqd2 = (distSqd < maxDistSqd) ? distSqd : maxDistSqd
        var d = pivot[s] - target[s]
        d = d * d
        if (d > maxDistSqd2) return NearestNeighbor.new(nearest, distSqd, nodesVisited)
        d = PtSqd.call(pivot, target)
        if (d < distSqd) {
            nearest = pivot
            distSqd = d
            maxDistSqd2 = distSqd
        }
        var temp = nn_(furtherKd, target, furtherHr, maxDistSqd2)
        nodesVisited = nodesVisited + temp.nodesVisited
        if (temp.distSqd < distSqd) {
            nearest = temp.nearest
            distSqd = temp.distSqd
        }
        return NearestNeighbor.new(nearest, distSqd, nodesVisited)
    }
}

var rand = Random.new()

var randomPt = Fn.new { |dim|
     var pt = List.filled(dim, 0)
     for (i in 0...dim) pt[i] = rand.float()
     return pt
}

var randomPts = Fn.new { |dim, n|
    var pts = List.filled(n, null)
    for (i in 0...n) pts[i] = randomPt.call(dim)
    return pts
}

var showNearest = Fn.new { |heading, kd, p|
    System.print("%(heading):")
    System.print("Point            : %(p)")
    var res = kd.nearest(p)
    System.print("Nearest neighbor : %(res.nearest)")
    System.print("Distance         : %(res.distSqd.sqrt)")
    System.print("Nodes visited    : %(res.nodesVisited)")
    System.print()
}

var points = [[2, 3], [5, 4], [9, 6], [4, 7], [8, 1], [7, 2]]
var hr = HyperRect.new([0, 0], [10, 10])
var kd = KdTree.new(points, hr)
showNearest.call("WP example data", kd, [9, 2])

hr = HyperRect.new([0, 0, 0], [1, 1, 1])
kd = KdTree.new(randomPts.call(3, 1000), hr)
showNearest.call("1,000 random 3D points", kd, randomPt.call(3))

hr = HrCopy.call(hr)
kd = KdTree.new(randomPts.call(3, 400000), hr)
showNearest.call("400,000 random 3D points", kd, randomPt.call(3))
