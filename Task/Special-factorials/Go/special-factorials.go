package main

import (
    "fmt"
    "math/big"
)

func sf(n int) *big.Int {
    if n < 2 {
        return big.NewInt(1)
    }
    sfact := big.NewInt(1)
    fact := big.NewInt(1)
    for i := 2; i <= n; i++ {
        fact.Mul(fact, big.NewInt(int64(i)))
        sfact.Mul(sfact, fact)
    }
    return sfact
}

func H(n int) *big.Int {
    if n < 2 {
        return big.NewInt(1)
    }
    hfact := big.NewInt(1)
    for i := 2; i <= n; i++ {
        bi := big.NewInt(int64(i))
        hfact.Mul(hfact, bi.Exp(bi, bi, nil))
    }
    return hfact
}

func af(n int) *big.Int {
    if n < 1 {
        return new(big.Int)
    }
    afact := new(big.Int)
    fact := big.NewInt(1)
    sign := new(big.Int)
    if n%2 == 0 {
        sign.SetInt64(-1)
    } else {
        sign.SetInt64(1)
    }
    t := new(big.Int)
    for i := 1; i <= n; i++ {
        fact.Mul(fact, big.NewInt(int64(i)))
        afact.Add(afact, t.Mul(fact, sign))
        sign.Neg(sign)
    }
    return afact
}

func ef(n int) *big.Int {
    if n < 1 {
        return big.NewInt(1)
    }
    t := big.NewInt(int64(n))
    return t.Exp(t, ef(n-1), nil)
}

func rf(n *big.Int) int {
    i := 0
    fact := big.NewInt(1)
    for {
        if fact.Cmp(n) == 0 {
            return i
        }
        if fact.Cmp(n) > 0 {
            return -1
        }
        i++
        fact.Mul(fact, big.NewInt(int64(i)))
    }
}

func main() {
    fmt.Println("First 10 superfactorials:")
    for i := 0; i < 10; i++ {
        fmt.Println(sf(i))
    }

    fmt.Println("\nFirst 10 hyperfactorials:")
    for i := 0; i < 10; i++ {
        fmt.Println(H(i))
    }

    fmt.Println("\nFirst 10 alternating factorials:")
    for i := 0; i < 10; i++ {
        fmt.Print(af(i), " ")
    }

    fmt.Println("\n\nFirst 5 exponential factorials:")
    for i := 0; i <= 4; i++ {
        fmt.Print(ef(i), " ")
    }

    fmt.Println("\n\nThe number of digits in 5$ is", len(ef(5).String()))

    fmt.Println("\nReverse factorials:")
    facts := []int64{1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 119}
    for _, fact := range facts {
        bfact := big.NewInt(fact)
        rfact := rf(bfact)
        srfact := fmt.Sprintf("%d", rfact)
        if rfact == -1 {
            srfact = "none"
        }
        fmt.Printf("%4s <- rf(%d)\n", srfact, fact)
    }
}
