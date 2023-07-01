package main

import (
    "fmt"
    "math"
)

const MAXITER = 151

func minkowski(x float64) float64 {
    if x > 1 || x < 0 {
        return math.Floor(x) + minkowski(x-math.Floor(x))
    }
    p := uint64(x)
    q := uint64(1)
    r := p + 1
    s := uint64(1)
    d := 1.0
    y := float64(p)
    for {
        d = d / 2
        if y+d == y {
            break
        }
        m := p + r
        if m < 0 || p < 0 {
            break
        }
        n := q + s
        if n < 0 {
            break
        }
        if x < float64(m)/float64(n) {
            r = m
            s = n
        } else {
            y = y + d
            p = m
            q = n
        }
    }
    return y + d
}

func minkowskiInv(x float64) float64 {
    if x > 1 || x < 0 {
        return math.Floor(x) + minkowskiInv(x-math.Floor(x))
    }
    if x == 1 || x == 0 {
        return x
    }
    contFrac := []uint32{0}
    curr := uint32(0)
    count := uint32(1)
    i := 0
    for {
        x *= 2
        if curr == 0 {
            if x < 1 {
                count++
            } else {
                i++
                t := contFrac
                contFrac = make([]uint32, i+1)
                copy(contFrac, t)
                contFrac[i-1] = count
                count = 1
                curr = 1
                x--
            }
        } else {
            if x > 1 {
                count++
                x--
            } else {
                i++
                t := contFrac
                contFrac = make([]uint32, i+1)
                copy(contFrac, t)
                contFrac[i-1] = count
                count = 1
                curr = 0
            }
        }
        if x == math.Floor(x) {
            contFrac[i] = count
            break
        }
        if i == MAXITER {
            break
        }
    }
    ret := 1.0 / float64(contFrac[i])
    for j := i - 1; j >= 0; j-- {
        ret = float64(contFrac[j]) + 1.0/ret
    }
    return 1.0 / ret
}

func main() {
    fmt.Printf("%19.16f %19.16f\n", minkowski(0.5*(1+math.Sqrt(5))), 5.0/3.0)
    fmt.Printf("%19.16f %19.16f\n", minkowskiInv(-5.0/9.0), (math.Sqrt(13)-7)/6)
    fmt.Printf("%19.16f %19.16f\n", minkowski(minkowskiInv(0.718281828)),
        minkowskiInv(minkowski(0.1213141516171819)))
}
