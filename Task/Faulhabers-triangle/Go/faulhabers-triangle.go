package main

import (
    "fmt"
    "math/big"
)

func bernoulli(n uint) *big.Rat {
    a := make([]big.Rat, n+1)
    z := new(big.Rat)
    for m := range a {
        a[m].SetFrac64(1, int64(m+1))
        for j := m; j >= 1; j-- {
            d := &a[j-1]
            d.Mul(z.SetInt64(int64(j)), d.Sub(d, &a[j]))
        }
    }
    // return the 'first' Bernoulli number
    if n != 1 {
        return &a[0]
    }
    a[0].Neg(&a[0])
    return &a[0]
}

func binomial(n, k int) int64 {
    if n <= 0 || k <= 0 || n < k {
        return 1
    }
    var num, den int64 = 1, 1
    for i := k + 1; i <= n; i++ {
        num *= int64(i)
    }
    for i := 2; i <= n-k; i++ {
        den *= int64(i)
    }
    return num / den
}

func faulhaberTriangle(p int) []big.Rat {
    coeffs := make([]big.Rat, p+1)
    q := big.NewRat(1, int64(p)+1)
    t := new(big.Rat)
    u := new(big.Rat)
    sign := -1
    for j := range coeffs {
        sign *= -1
        d := &coeffs[p-j]
        t.SetInt64(int64(sign))
        u.SetInt64(binomial(p+1, j))
        d.Mul(q, t)
        d.Mul(d, u)
        d.Mul(d, bernoulli(uint(j)))
    }
    return coeffs
}

func main() {
    for i := 0; i < 10; i++ {
        coeffs := faulhaberTriangle(i)
        for _, coeff := range coeffs {
            fmt.Printf("%5s  ", coeff.RatString())
        }
        fmt.Println()
    }
    fmt.Println()
    // get coeffs for (k + 1)th row
    k := 17
    cc := faulhaberTriangle(k)
    n := int64(1000)
    nn := big.NewRat(n, 1)
    np := big.NewRat(1, 1)
    sum := new(big.Rat)
    tmp := new(big.Rat)
    for _, c := range cc {
        np.Mul(np, nn)
        tmp.Set(np)
        tmp.Mul(tmp, &c)
        sum.Add(sum, tmp)
    }
    fmt.Println(sum.RatString())
}
