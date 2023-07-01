package main

import (
    "fmt"
    "math"
)

func isqrt(x uint64) uint64 {
    x0 := x >> 1
    x1 := (x0 + x/x0) >> 1
    for x1 < x0 {
        x0 = x1
        x1 = (x0 + x/x0) >> 1
    }
    return x0
}

func gcd(x, y uint64) uint64 {
    for y != 0 {
        x, y = y, x%y
    }
    return x
}

var multiplier = []uint64{
    1, 3, 5, 7, 11, 3 * 5, 3 * 7, 3 * 11, 5 * 7, 5 * 11, 7 * 11, 3 * 5 * 7, 3 * 5 * 11, 3 * 7 * 11, 5 * 7 * 11, 3 * 5 * 7 * 11,
}

func squfof(N uint64) uint64 {
    s := uint64(math.Sqrt(float64(N)) + 0.5)
    if s*s == N {
        return s
    }
    for k := 0; k < len(multiplier) && N <= math.MaxUint64/multiplier[k]; k++ {
        D := multiplier[k] * N
        P := isqrt(D)
        Pprev := P
        Po := Pprev
        Qprev := uint64(1)
        Q := D - Po*Po
        L := uint32(isqrt(8 * s))
        B := 3 * L
        i := uint32(2)
        var b, q, r uint64
        for ; i < B; i++ {
            b = uint64((Po + P) / Q)
            P = b*Q - P
            q = Q
            Q = Qprev + b*(Pprev-P)
            r = uint64(math.Sqrt(float64(Q)) + 0.5)
            if (i&1) == 0 && r*r == Q {
                break
            }
            Qprev = q
            Pprev = P
        }
        if i >= B {
            continue
        }
        b = uint64((Po - P) / r)
        P = b*r + P
        Pprev = P
        Qprev = r
        Q = (D - Pprev*Pprev) / Qprev
        i = 0
        for {
            b = uint64((Po + P) / Q)
            Pprev = P
            P = b*Q - P
            q = Q
            Q = Qprev + b*(Pprev-P)
            Qprev = q
            i++
            if P == Pprev {
                break
            }
        }
        r = gcd(N, Qprev)
        if r != 1 && r != N {
            return r
        }
    }
    return 0
}

func main() {
    examples := []uint64{
        2501,
        12851,
        13289,
        75301,
        120787,
        967009,
        997417,
        7091569,
        13290059,
        42854447,
        223553581,
        2027651281,
        11111111111,
        100895598169,
        1002742628021,
        60012462237239,
        287129523414791,
        9007199254740931,
        11111111111111111,
        314159265358979323,
        384307168202281507,
        419244183493398773,
        658812288346769681,
        922337203685477563,
        1000000000000000127,
        1152921505680588799,
        1537228672809128917,
        4611686018427387877,
    }
    fmt.Println("Integer              Factor     Quotient")
    fmt.Println("------------------------------------------")
    for _, N := range examples {
        fact := squfof(N)
        quot := "fail"
        if fact > 0 {
            quot = fmt.Sprintf("%d", N/fact)
        }
        fmt.Printf("%-20d %-10d %s\n", N, fact, quot)
    }
}
