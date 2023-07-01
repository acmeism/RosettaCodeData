package main

import "fmt"

// Arguments n, p as described in WP
// If Legendre symbol != 1, ok return is false.  Otherwise ok return is true,
// R1 is WP return value R and for convenience R2 is p-R1.
func ts(n, p int) (R1, R2 int, ok bool) {
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
    // argument validation
    if ls(n) != 1 {
        return 0, 0, false
    }
    // WP step 1, factor out powers two.
    // variables Q, S named as at WP.
    Q := p - 1
    S := 0
    for Q&1 == 0 {
        S++
        Q >>= 1
    }
    // WP step 1, direct solution
    if S == 1 {
        R1 = powModP(n, (p+1)/4)
        return R1, p - R1, true
    }
    // WP step 2, select z, assign c
    z := 2
    for ; ls(z) != p-1; z++ {
    }
    c := powModP(z, Q)
    // WP step 3, assign R, t, M
    R := powModP(n, (Q+1)/2)
    t := powModP(n, Q)
    M := S
    // WP step 4, loop
    for {
        // WP step 4.1, termination condition
        if t == 1 {
            return R, p - R, true
        }
        // WP step 4.2, find lowest i...
        i := 0
        for z := t; z != 1 && i < M-1; {
            z = z * z % p
            i++
        }
        // WP step 4.3, using a variable b, assign new values of R, t, c, M
        b := c
        for e := M - i - 1; e > 0; e-- {
            b = b * b % p
        }
        R = R * b % p
        c = b * b % p // more convenient to compute c before t
        t = t * c % p
        M = i
    }
}

func main() {
    fmt.Println(ts(10, 13))
    fmt.Println(ts(56, 101))
    fmt.Println(ts(1030, 10009))
    fmt.Println(ts(1032, 10009))
    fmt.Println(ts(44402, 100049))
}
