package main

import (
    "fmt"
    "math/big"
    "time"
)

var p []*big.Int
var pd []int

func partDiffDiff(n int) int {
    if n&1 == 1 {
        return (n + 1) / 2
    }
    return n + 1
}

func partDiff(n int) int {
    if n < 2 {
        return 1
    }
    pd[n] = pd[n-1] + partDiffDiff(n-1)
    return pd[n]
}

func partitionsP(n int) {
    if n < 2 {
        return
    }
    psum := new(big.Int)
    for i := 1; i <= n; i++ {
        pdi := partDiff(i)
        if pdi > n {
            break
        }
        sign := int64(-1)
        if (i-1)%4 < 2 {
            sign = 1
        }
        t := new(big.Int).Mul(p[n-pdi], big.NewInt(sign))
        psum.Add(psum, t)
    }
    p[n] = psum
}

func main() {
    start := time.Now()
    const N = 6666
    p = make([]*big.Int, N+1)
    pd = make([]int, N+1)
    p[0], pd[0] = big.NewInt(1), 1
    p[1], pd[1] = big.NewInt(1), 1
    for n := 2; n <= N; n++ {
        partitionsP(n)
    }
    fmt.Printf("p[%d)] = %d\n", N, p[N])
    fmt.Printf("Took %s\n", time.Since(start))
}
