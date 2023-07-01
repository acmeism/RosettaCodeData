import "random" for Random
import "/dynamic" for Struct
import "/fmt" for Fmt

var Point = Struct.create("Point", ["x", "y", "group"])

var r = Random.new()
var hugeVal = Num.infinity

var RAND_MAX = Num.maxSafeInteger
var PTS = 100000
var K = 11
var W = 400
var H = 400

var rand = Fn.new { r.int(RAND_MAX) }
var randf = Fn.new { |m| m * rand.call() / (RAND_MAX - 1) }

var genXY = Fn.new { |count, radius|
    var pts = List.filled(count, null)

    /* note: this is not a uniform 2-d distribution */
    for (i in 0...count) {
        pts[i] = Point.new(0, 0, 0)
        var ang = randf.call(2 * Num.pi)
        var r = randf.call(radius)
        pts[i].x = r * ang.cos
        pts[i].y = r * ang.sin
    }
    return pts
}

var dist2 = Fn.new { |a, b|
    var x = a.x - b.x
    var y = a.y - b.y
    return x * x + y * y
}

var nearest = Fn.new { |pt, cent, nCluster|
    var minD = hugeVal
    var minI = pt.group
    for (i in 0...nCluster) {
        var d = dist2.call(cent[i], pt)
        if (minD > d) {
            minD = d
            minI = i
        }
    }
    return [minI, minD]
}

var copyPoint = Fn.new { |pt| Point.new(pt.x, pt.y, pt.group) }

var kpp = Fn.new { |pts, len, cent|
    var nCent = cent.count
    var d = List.filled(len, 0)
    cent[0] = copyPoint.call(pts[rand.call() % len])
    for (nCluster in 1...nCent) {
        var sum = 0
        for (j in 0...len) {
            d[j] = nearest.call(pts[j], cent, nCluster)[1]
            sum = sum + d[j]
        }
        sum = randf.call(sum)
        for (j in 0...len) {
            sum = sum - d[j]
            if (sum > 0) continue
            cent[nCluster] = copyPoint.call(pts[j])
            break
        }
    }
    for (j in 0...len) pts[j].group = nearest.call(pts[j], cent, nCent)[0]
}

var lloyd = Fn.new { |pts, len, nCluster|
    var cent = List.filled(nCluster, null)
    for (i in 0...nCluster) cent[i] = Point.new(0, 0, 0)
    kpp.call(pts, len, cent)
    while(true) {
        /* group element for centroids are used as counters */
        for (i in 0...nCluster) {
            cent[i].x = 0
            cent[i].y = 0
            cent[i].group = 0
        }
        for (j in 0...len) {
            var p = pts[j]
            var c = cent[p.group]
            c.group = c.group + 1
            c.x = c.x + p.x
            c.y = c.y + p.y
        }
        for (i in 0...nCluster) {
            var c = cent[i]
            c.x = c.x / c.group
            c.y = c.y / c.group
        }
        var changed = 0

        /* find closest centroid of each point */
        for (j in 0...len) {
            var p = pts[j]
            var minI = nearest.call(p, cent, nCluster)[0]
            if (minI != p.group) {
                changed = changed + 1
                p.group = minI
            }
        }

        /* stop when 99.9% of points are good */
        if (changed <= (len >> 10)) break
    }
    for (i in 0...nCluster) cent[i].group = i
    return cent
}

var printEps = Fn.new { |pts, len, cent, nCluster|
    var colors = List.filled(nCluster * 3, 0)
    for (i in 0...nCluster) {
        colors[3 * i + 0] = (3 * (i + 1) % 11) / 11
        colors[3 * i + 1] = (7 * i % 11) / 11
        colors[3 * i + 2] = (9 * i % 11) / 11
    }
    var minX = hugeVal
    var minY = hugeVal
    var maxX = -hugeVal
    var maxY = -hugeVal
    for (j in 0...len) {
        var p = pts[j]
        if (maxX < p.x) maxX = p.x
        if (minX > p.x) minX = p.x
        if (maxY < p.y) maxY = p.y
        if (minY > p.y) minY = p.y
    }
    var scale = (W / (maxX - minX)).min(H / (maxY - minY))
    var cx = (maxX + minX) / 2
    var cy = (maxY + minY) / 2

    System.print("\%!PS-Adobe-3.0\n\%\%BoundingBox: -5 -5 %(W + 10) %(H + 10)")
    System.print("/l {rlineto} def /m {rmoveto} def")
    System.print("/c { .25 sub exch .25 sub exch .5 0 360 arc fill } def")
    System.write("/s { moveto -2 0 m 2 2 l 2 -2 l -2 -2 l closepath ")
    System.write("     gsave 1 setgray fill grestore gsave 3 setlinewidth")
    System.print(" 1 setgray stroke grestore 0 setgray stroke }def")
    var f1 = "$g $g $g setrgbcolor"
    var f2 = "$.3f $.3f c"
    var f3 = "\n0 setgray $g $g s"
    for (i in 0...nCluster) {
        var c = cent[i]
        Fmt.print(f1, colors[3 * i], colors[3 * i + 1], colors[3 * i + 2])
        for (j in 0...len) {
            var p = pts[j]
            if (p.group != i) continue
            Fmt.print(f2, (p.x - cx) * scale + W / 2, (p.y - cy) * scale + H / 2)
        }
        Fmt.print(f3, (c.x - cx) * scale + W / 2, (c.y - cy) * scale + H / 2)
    }
    System.write("\n\%\%EOF")
}

var v = genXY.call(PTS, 10)
var c = lloyd.call(v, PTS, K)
printEps.call(v, PTS, c, K)
