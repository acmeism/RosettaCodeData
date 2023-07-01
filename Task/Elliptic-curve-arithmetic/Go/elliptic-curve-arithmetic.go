package main

import (
    "fmt"
    "math"
)

const bCoeff = 7

type pt struct{ x, y float64 }

func zero() pt {
    return pt{math.Inf(1), math.Inf(1)}
}

func is_zero(p pt) bool {
    return p.x > 1e20 || p.x < -1e20
}

func neg(p pt) pt {
    return pt{p.x, -p.y}
}

func dbl(p pt) pt {
    if is_zero(p) {
        return p
    }
    L := (3 * p.x * p.x) / (2 * p.y)
    x := L*L - 2*p.x
    return pt{
        x: x,
        y: L*(p.x-x) - p.y,
    }
}

func add(p, q pt) pt {
    if p.x == q.x && p.y == q.y {
        return dbl(p)
    }
    if is_zero(p) {
        return q
    }
    if is_zero(q) {
        return p
    }
    L := (q.y - p.y) / (q.x - p.x)
    x := L*L - p.x - q.x
    return pt{
        x: x,
        y: L*(p.x-x) - p.y,
    }
}

func mul(p pt, n int) pt {
    r := zero()
    for i := 1; i <= n; i <<= 1 {
        if i&n != 0 {
            r = add(r, p)
        }
        p = dbl(p)
    }
    return r
}

func show(s string, p pt) {
    fmt.Printf("%s", s)
    if is_zero(p) {
        fmt.Println("Zero")
    } else {
        fmt.Printf("(%.3f, %.3f)\n", p.x, p.y)
    }
}

func from_y(y float64) pt {
    return pt{
        x: math.Cbrt(y*y - bCoeff),
        y: y,
    }
}

func main() {
    a := from_y(1)
    b := from_y(2)
    show("a = ", a)
    show("b = ", b)
    c := add(a, b)
    show("c = a + b = ", c)
    d := neg(c)
    show("d = -c = ", d)
    show("c + d = ", add(c, d))
    show("a + b + d = ", add(a, add(b, d)))
    show("a * 12345 = ", mul(a, 12345))
}
