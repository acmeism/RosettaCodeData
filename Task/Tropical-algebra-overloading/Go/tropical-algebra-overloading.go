package main

import (
    "fmt"
    "log"
    "math"
)

var MinusInf = math.Inf(-1)

type MaxTropical struct{ r float64 }

func newMaxTropical(r float64) MaxTropical {
    if math.IsInf(r, 1) || math.IsNaN(r) {
        log.Fatal("Argument must be a real number or negative infinity.")
    }
    return MaxTropical{r}
}

func (t MaxTropical) eq(other MaxTropical) bool {
    return t.r == other.r
}

// equivalent to ⊕ operator
func (t MaxTropical) add(other MaxTropical) MaxTropical {
    if t.r == MinusInf {
        return other
    }
    if other.r == MinusInf {
        return t
    }
    return newMaxTropical(math.Max(t.r, other.r))
}

// equivalent to ⊗ operator
func (t MaxTropical) mul(other MaxTropical) MaxTropical {
    if t.r == 0 {
        return other
    }
    if other.r == 0 {
        return t
    }
    return newMaxTropical(t.r + other.r)
}

// exponentiation function
func (t MaxTropical) pow(e int) MaxTropical {
    if e < 1 {
        log.Fatal("Exponent must be a positive integer.")
    }
    if e == 1 {
        return t
    }
    p := t
    for i := 2; i <= e; i++ {
        p = p.mul(t)
    }
    return p
}

func (t MaxTropical) String() string {
    return fmt.Sprintf("%g", t.r)
}

func main() {
    // 0 denotes ⊕ and 1 denotes ⊗
    data := [][]float64{
        {2, -2, 1},
        {-0.001, MinusInf, 0},
        {0, MinusInf, 1},
        {1.5, -1, 0},
        {-0.5, 0, 1},
    }
    for _, d := range data {
        a := newMaxTropical(d[0])
        b := newMaxTropical(d[1])
        if d[2] == 0 {
            fmt.Printf("%s ⊕ %s = %s\n", a, b, a.add(b))
        } else {
            fmt.Printf("%s ⊗ %s = %s\n", a, b, a.mul(b))
        }
    }

    c := newMaxTropical(5)
    fmt.Printf("%s ^ 7 = %s\n", c, c.pow(7))

    d := newMaxTropical(8)
    e := newMaxTropical(7)
    f := c.mul(d.add(e))
    g := c.mul(d).add(c.mul(e))
    fmt.Printf("%s ⊗ (%s ⊕ %s) = %s\n", c, d, e, f)
    fmt.Printf("%s ⊗ %s ⊕ %s ⊗ %s = %s\n", c, d, c, e, g)
    fmt.Printf("%s ⊗ (%s ⊕ %s) == %s ⊗ %s ⊕ %s ⊗ %s is %t\n", c, d, e, c, d, c, e, f.eq(g))
}
