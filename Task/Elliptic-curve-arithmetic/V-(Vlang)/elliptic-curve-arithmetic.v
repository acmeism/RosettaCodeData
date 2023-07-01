import math

const b_coeff = 7

struct Pt {
	x f64
	y f64
}

fn zero() Pt {
    return Pt{math.inf(1), math.inf(1)}
}

fn is_zero(p Pt) bool {
    return p.x > 1e20 || p.x < -1e20
}

fn neg(p Pt) Pt {
    return Pt{p.x, -p.y}
}

fn dbl(p Pt) Pt {
    if is_zero(p) {
        return p
    }
    l := (3 * p.x * p.x) / (2 * p.y)
    x := l*l - 2*p.x
    return Pt{
        x: x,
        y: l*(p.x-x) - p.y,
    }
}

fn add(p Pt, q Pt) Pt {
    if p.x == q.x && p.y == q.y {
        return dbl(p)
    }
    if is_zero(p) {
        return q
    }
    if is_zero(q) {
        return p
    }
    l := (q.y - p.y) / (q.x - p.x)
    x := l*l - p.x - q.x
    return Pt{
        x: x,
        y: l*(p.x-x) - p.y,
    }
}

fn mul(mut p Pt, n int) Pt {
    mut r := zero()
    for i := 1; i <= n; i <<= 1 {
        if i&n != 0 {
            r = add(r, p)
        }
        p = dbl(p)
    }
    return r
}

fn show(s string, p Pt) {
    print("$s")
    if is_zero(p) {
        println("Zero")
    } else {
        println("(${p.x:.3f}, ${p.y:.3f})")
    }
}

fn from_y(y f64) Pt {
    return Pt{
        x: math.cbrt(y*y - b_coeff),
        y: y,
    }
}

fn main() {
    mut a := from_y(1)
    b := from_y(2)
    show("a = ", a)
    show("b = ", b)
    c := add(a, b)
    show("c = a + b = ", c)
    d := neg(c)
    show("d = -c = ", d)
    show("c + d = ", add(c, d))
    show("a + b + d = ", add(a, add(b, d)))
    show("a * 12345 = ", mul(mut a, 12345))
}
