struct Point {
    mut:
    x int
    y int
}

fn rot(n int, mut p Point, rx int, ry int) {
    if ry == 0 {
        if rx == 1 {
            p.x = n - 1 - p.x
            p.y = n - 1 - p.y
        }
        t := p.x
        p.x = p.y
        p.y = t
    }
}

fn d2pt(n int, d int) Point {
    mut x := 0
    mut y := 0
    mut t := d
    mut s := 1
    mut p := Point{0, 0}
    for s < n {
        rx := 1 & (t / 2)
        ry := 1 & (t ^ rx)
        p = Point{x, y}
        rot(s, mut p, rx, ry)
        x = p.x + s * rx
        y = p.y + s * ry
        t /= 4
        s *= 2
    }
    return Point{x, y}
}

fn main() {
    n := 32
    k := 3
    mut pts := [][]rune{len: n * k, init: []rune{len: n * k, init: ` `}}
    mut prev := Point{0, 0}
    pts[0][0] = `.`
    for d in 1 .. n * n {
        curr := d2pt(n, d)
        cx := curr.x * k
        cy := curr.y * k
        px := prev.x * k
        py := prev.y * k
        pts[cx][cy] = `.`
        if cx == px {
            if py < cy {
                for y in py + 1 .. cy {
                    pts[cx][y] = `|`
                }
            } else {
                for y in cy + 1 .. py {
                    pts[cx][y] = `|`
                }
            }
        } else {
            if px < cx {
                for x in px + 1 .. cx {
                    pts[x][cy] = `_`
                }
            } else {
                for x in cx + 1 .. px {
                    pts[x][cy] = `_`
                }
            }
        }
        prev = curr
    }
    for i in 0 .. n * k {
        for j in 0 .. n * k {
            print(pts[j][i].str())
        }
        println("")
    }
}
