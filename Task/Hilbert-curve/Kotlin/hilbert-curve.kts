// Version 1.2.40

data class Point(var x: Int, var y: Int)

fun d2pt(n: Int, d: Int): Point {
    var x = 0
    var y = 0
    var t = d
    var s = 1
    while (s < n) {
        val rx = 1 and (t / 2)
        val ry = 1 and (t xor rx)
        val p = Point(x, y)
        rot(s, p, rx, ry)
        x = p.x + s * rx
        y = p.y + s * ry
        t /= 4
        s *= 2
    }
    return Point(x, y)
}

fun rot(n: Int, p: Point, rx: Int, ry: Int) {
    if (ry == 0) {
        if (rx == 1) {
            p.x = n - 1 - p.x
            p.y = n - 1 - p.y
        }
        val t  = p.x
        p.x = p.y
        p.y = t
    }
}

fun main(args:Array<String>) {
    val n = 32
    val k = 3
    val pts = List(n * k) { CharArray(n * k) { ' ' } }
    var prev = Point(0, 0)
    pts[0][0] = '.'
    for (d in 1 until n * n) {
        val curr = d2pt(n, d)
        val cx = curr.x * k
        val cy = curr.y * k
        val px = prev.x * k
        val py = prev.y * k
        pts[cx][cy] = '.'
        if (cx == px ) {
            if (py < cy)
                for (y in py + 1 until cy) pts[cx][y] = '|'
            else
                for (y in cy + 1 until py) pts[cx][y] = '|'
        }
        else {
            if (px < cx)
               for (x in px + 1 until cx) pts[x][cy] = '_'
            else
               for (x in cx + 1 until px) pts[x][cy] = '_'
        }
        prev = curr
    }
    for (i in 0 until n * k) {
        for (j in 0 until n * k) print(pts[j][i])
        println()
    }
}
