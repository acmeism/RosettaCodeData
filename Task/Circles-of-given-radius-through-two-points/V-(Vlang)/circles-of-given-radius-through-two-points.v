import math

const (
    two  = "two circles."
    r0   = "R==0.0 does not describe circles."
    co   = "coincident points describe an infinite number of circles."
    cor0 = "coincident points with r==0.0 describe a degenerate circle."
    diam = "Points form a diameter and describe only a single circle."
    far  = "Points too far apart to form circles."
)

struct Point {
	x f64
	y f64
}

fn circles(p1 Point, p2 Point, r f64) (Point, Point, string) {
	mut case := ''
	c1, c2 := p1, p2
    if p1 == p2 {
        if r == 0 {
            return p1, p1, cor0
        }
        case = co
        return c1, c2, case
    }
    if r == 0 {
        return p1, p2, r0
    }
    dx := p2.x - p1.x
    dy := p2.y - p1.y
    q := math.hypot(dx, dy)
    if q > 2*r {
        case = far
        return c1, c2, case
    }
    m := Point{(p1.x + p2.x) / 2, (p1.y + p2.y) / 2}
    if q == 2*r {
        return m, m, diam
    }
    d := math.sqrt(r*r - q*q/4)
    ox := d * dx / q
    oy := d * dy / q
    return Point{m.x - oy, m.y + ox}, Point{m.x + oy, m.y - ox}, two
}

struct Cir {
	p1 Point
	p2 Point
	r f64
}
const td = [
    Cir{Point{0.1234, 0.9876}, Point{0.8765, 0.2345}, 2.0},
    Cir{Point{0.0000, 2.0000}, Point{0.0000, 0.0000}, 1.0},
    Cir{Point{0.1234, 0.9876}, Point{0.1234, 0.9876}, 2.0},
    Cir{Point{0.1234, 0.9876}, Point{0.8765, 0.2345}, 0.5},
    Cir{Point{0.1234, 0.9876}, Point{0.1234, 0.9876}, 0.0},
]

fn main() {
    for tc in td {
        println("p1:  $tc.p1")
        println("p2:  $tc.p2")
        println("r:  $tc.r")
        c1, c2, case := circles(tc.p1, tc.p2, tc.r)
        println("   $case")
        match case {
        	cor0, diam{
            	println("   Center:  $c1")
			}
        	two {
				println("   Center 1:  $c1")
				println("   Center 2:  $c2")
			}
			else{}
		}
        println('')
    }
}
