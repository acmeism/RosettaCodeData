package main

import (
    "fmt"
    "strings"
)

// Highest power of two that divides a given number.
func hpo2(n uint) uint { return n & (-n) }

// Base 2 logarithm of the highest power of 2 dividing a given number.
func lhpo2(n uint) uint {
    q := uint(0)
    m := hpo2(n)
    for m%2 == 0 {
        m = m >> 1
        q++
    }
    return q
}

// nim-sum of two numbers.
func nimsum(x, y uint) uint { return x ^ y }

// nim-product of two numbers.
func nimprod(x, y uint) uint {
    if x < 2 || y < 2 {
        return x * y
    }
    h := hpo2(x)
    if x > h {
        return nimprod(h, y) ^ nimprod(x^h, y) // break x into powers of 2
    }
    if hpo2(y) < y {
        return nimprod(y, x) // break y into powers of 2 by flipping operands
    }
    xp, yp := lhpo2(x), lhpo2(y)
    comp := xp & yp
    if comp == 0 {
        return x * y // no Fermat power in common
    }
    h = hpo2(comp)
    // a Fermat number square is its sequimultiple
    return nimprod(nimprod(x>>h, y>>h), 3<<(h-1))
}

type fnop struct {
    fn func(x, y uint) uint
    op string
}

func main() {
    for _, f := range []fnop{{nimsum, "+"}, {nimprod, "*"}} {
        fmt.Printf(" %s |", f.op)
        for i := 0; i <= 15; i++ {
            fmt.Printf("%3d", i)
        }
        fmt.Println("\n--- " + strings.Repeat("-", 48))
        for i := uint(0); i <= 15; i++ {
            fmt.Printf("%2d |", i)
            for j := uint(0); j <= 15; j++ {
                fmt.Printf("%3d", f.fn(i, j))
            }
            fmt.Println()
        }
        fmt.Println()
    }

    a := uint(21508)
    b := uint(42689)
    fmt.Printf("%d + %d = %d\n", a, b, nimsum(a, b))
    fmt.Printf("%d * %d = %d\n", a, b, nimprod(a, b))
}
