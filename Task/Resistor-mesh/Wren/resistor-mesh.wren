class Node {
    construct new(v, fixed) {
        _v = v
        _fixed = fixed
    }

    v { _v }
    v=(value) { _v = value }

    fixed { _fixed }
    fixed=(value) { _fixed = value }
}

var setBoundary = Fn.new { |m|
    m[1][1].v = 1
    m[1][1].fixed = 1
    m[6][7].v = -1
    m[6][7].fixed = -1
}

var calcDiff = Fn.new { |m, d, w, h|
    var total = 0
    for (i in 0...h) {
        for (j in 0...w) {
            var v = 0
            var n = 0
            if (i > 0) {
                v = v + m[i-1][j].v
                n = n + 1
            }
            if (j > 0) {
                v = v + m[i][j-1].v
                n = n + 1
            }
            if (i + 1 < h) {
                v =  v + m[i+1][j].v
                n = n + 1
            }
            if (j + 1 < w) {
                v = v + m[i][j+1].v
                n = n + 1
            }
            v = m[i][j].v - v/n
            d[i][j].v = v
            if (m[i][j].fixed == 0) total = total + v*v
        }
    }
    return total
}

var iter = Fn.new { |m, w, h|
    var d = List.filled(h, null)
    for (i in 0...h) {
        d[i] = List.filled(w, null)
        for (j in 0...w) d[i][j] = Node.new(0, 0)
    }
    var cur = [0] * 3
    var diff = 1e10
    while (diff > 1e-24) {
        setBoundary.call(m)
        diff = calcDiff.call(m, d, w, h)
        for (i in 0...h) {
            for (j in 0...w) m[i][j].v = m[i][j].v - d[i][j].v
        }
    }
    for (i in 0...h) {
        for (j in 0...w) {
            var k = 0
            if (i != 0) k = k + 1
            if (j != 0) k = k + 1
            if (i < h - 1) k = k + 1
            if (j < w - 1) k = k + 1
            cur[m[i][j].fixed + 1] = cur[m[i][j].fixed + 1] + d[i][j].v * k
        }
    }
    return (cur[2] - cur[0]) / 2
}

var S = 10
var mesh = List.filled(S, null)
for (i in 0...S) {
    mesh[i] = List.filled(S, null)
    for (j in 0...S) mesh[i][j] = Node.new(0, 0)
}
var r = 2 / iter.call(mesh, S, S)
System.print("R = %(r)")
