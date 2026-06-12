package main

import (
    "fmt"
    "math"
    "sort"
)

const adj = 0.0001 // adjustment to ensure f/p square root exact for perfect integer squares

var primes = []uint64{
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
} // seems to be enough

func gcd(x, y uint64) uint64 {
    for y != 0 {
        x, y = y, x%y
    }
    return x
}

func isSquareFree(x uint64) bool {
    for _, p := range primes {
        p2 := p * p
        if p2 > x {
            break
        }
        if x%p2 == 0 {
            return false
        }
    }
    return true
}

func iroot(x, p uint64) uint64 {
    return uint64(math.Pow(float64(x), 1.0/float64(p)) + adj)
}

func ipow(x, p uint64) uint64 {
    prod := uint64(1)
    for p > 0 {
        if p&1 != 0 {
            prod *= x
        }
        p >>= 1
        x *= x
    }
    return prod
}

func powerful(n, k uint64) []uint64 {
    set := make(map[uint64]bool)
    var f func(m, r uint64) // recursive closure
    f = func(m, r uint64) {
        if r < k {
            set[m] = true
            return
        }
        for v := uint64(1); v <= iroot(n/m, r); v++ {
            if r > k {
                if !isSquareFree(v) || gcd(m, v) != 1 {
                    continue
                }
            }
            f(m*ipow(v, r), r-1)
        }
    }
    f(1, (1<<k)-1)
    list := make([]uint64, 0, len(set))
    for key := range set {
        list = append(list, key)
    }
    sort.Slice(list, func(i, j int) bool {
        return list[i] < list[j]
    })
    return list
}

func main() {
    power := uint64(10)
    for k := uint64(2); k <= 10; k++ {
        power *= 10
        a := powerful(power, k)
        le := len(a)
        h, t := a[0:5], a[le-5:]
        fmt.Printf("%d %2d-powerful numbers <= 10^%-2d: %v ... %v\n", le, k, k, h, t)
    }
    fmt.Println()
    for k := uint64(2); k <= 10; k++ {
        power := uint64(1)
        var counts []int
        for j := uint64(0); j < k+10; j++ {
            a := powerful(power, k)
            counts = append(counts, len(a))
            power *= 10
        }
        j := k + 10
        fmt.Printf("Count of %2d-powerful numbers <= 10^j, j in [0, %d): %v\n", k, j, counts)
    }
}
