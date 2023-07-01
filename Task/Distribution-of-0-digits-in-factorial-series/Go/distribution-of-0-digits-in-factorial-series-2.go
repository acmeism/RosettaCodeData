package main

import (
    "fmt"
    "rcu"
)

var rfs = []int{1} // reverse factorial(1) in base 1000
var zc = make([]int, 999)

func init() {
    for x := 1; x <= 9; x++ {
        zc[x-1] = 2     // 00x
        zc[10*x-1] = 2  // 0x0
        zc[100*x-1] = 2 // x00
        var y = 10
        for y <= 90 {
            zc[y+x-1] = 1      // 0yx
            zc[10*y+x-1] = 1   // y0x
            zc[10*(y+x)-1] = 1 // yx0
            y += 10
        }
    }
}

func main() {
    total := 0.0
    trail := 1
    first := 0
    firstRatio := 0.0
    fmt.Println("The mean proportion of zero digits in factorials up to the following are:")
    for f := 2; f <= 10000; f++ {
        carry := 0
        d999 := 0
        zeros := (trail - 1) * 3
        j := trail
        l := len(rfs)
        for j <= l || carry != 0 {
            if j <= l {
                carry = rfs[j-1]*f + carry
            }
            d999 = carry % 1000
            if j <= l {
                rfs[j-1] = d999
            } else {
                rfs = append(rfs, d999)
            }
            if d999 == 0 {
                zeros += 3
            } else {
                zeros += zc[d999-1]
            }
            carry /= 1000
            j++
        }
        for rfs[trail-1] == 0 {
            trail++
        }
        // d999 = quick correction for length and zeros
        d999 = rfs[len(rfs)-1]
        if d999 < 100 {
            if d999 < 10 {
                d999 = 2
            } else {
                d999 = 1
            }
        } else {
            d999 = 0
        }
        zeros -= d999
        digits := len(rfs)*3 - d999
        total += float64(zeros) / float64(digits)
        ratio := total / float64(f)
        if ratio >= 0.16 {
            first = 0
            firstRatio = 0.0
        } else if first == 0 {
            first = f
            firstRatio = ratio
        }
        if f == 100 || f == 1000 || f == 10000 {
            fmt.Printf("%6s = %12.10f\n", rcu.Commatize(f), ratio)
        }
    }
    fmt.Printf("%6s = %12.10f", rcu.Commatize(first), firstRatio)
    fmt.Println(" (stays below 0.16 after this)")
    fmt.Printf("%6s = %12.10f\n", "50,000", total/50000)
}
