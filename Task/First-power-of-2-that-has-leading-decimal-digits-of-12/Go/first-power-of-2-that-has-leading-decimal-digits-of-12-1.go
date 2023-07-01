package main

import (
    "fmt"
    "math"
    "time"
)

const ld10 = math.Ln2 / math.Ln10

func commatize(n uint64) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func p(L, n uint64) uint64 {
    i := L
    digits := uint64(1)
    for i >= 10 {
        digits *= 10
        i /= 10
    }
    count := uint64(0)
    for i = 0; count < n; i++ {
        e := math.Exp(math.Ln10 * math.Mod(float64(i)*ld10, 1))
        if uint64(math.Trunc(e*float64(digits))) == L {
            count++
        }
    }
    return i - 1
}

func main() {
    start := time.Now()
    params := [][2]uint64{{12, 1}, {12, 2}, {123, 45}, {123, 12345}, {123, 678910}}
    for _, param := range params {
        fmt.Printf("p(%d, %d) = %s\n", param[0], param[1], commatize(p(param[0], param[1])))
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
