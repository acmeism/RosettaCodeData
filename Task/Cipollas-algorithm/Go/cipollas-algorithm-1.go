package main

import "fmt"

func c(n, p int) (R1, R2 int, ok bool) {
    // a^e mod p
    powModP := func(a, e int) int {
        s := 1
        for ; e > 0; e-- {
            s = s * a % p
        }
        return s
    }
    // Legendre symbol, returns 1, 0, or -1 mod p -- that's 1, 0, or p-1.
    ls := func(a int) int {
        return powModP(a, (p-1)/2)
    }
    // Step 0, validate arguments
    if ls(n) != 1 {
        return
    }
    // Step 1, find a, ω2
    var a, ω2 int
    for a = 0; ; a++ {
        // integer % in Go uses T-division, add p to keep the result positive
        ω2 = (a*a + p - n) % p
        if ls(ω2) == p-1 {
            break
        }
    }
    // muliplication in fp2
    type point struct{ x, y int }
    mul := func(a, b point) point {
        return point{(a.x*b.x + a.y*b.y*ω2) % p, (a.x*b.y + b.x*a.y) % p}
    }
    // Step2, compute power
    r := point{1, 0}
    s := point{a, 1}
    for n := (p + 1) >> 1 % p; n > 0; n >>= 1 {
        if n&1 == 1 {
            r = mul(r, s)
        }
        s = mul(s, s)
    }
    // Step3, check x in Fp
    if r.y != 0 {
        return
    }
    // Step5, check x*x=n
    if r.x*r.x%p != n {
        return
    }
    // Step4, solutions
    return r.x, p - r.x, true
}

func main() {
    fmt.Println(c(10, 13))
    fmt.Println(c(56, 101))
    fmt.Println(c(8218, 10007))
    fmt.Println(c(8219, 10007))
    fmt.Println(c(331575, 1000003))
}
