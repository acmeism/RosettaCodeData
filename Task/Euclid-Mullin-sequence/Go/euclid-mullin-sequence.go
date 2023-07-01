package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "log"
)

var (
    zero  = big.NewInt(0)
    one   = big.NewInt(1)
    two   = big.NewInt(2)
    three = big.NewInt(3)
    four  = big.NewInt(4)
    five  = big.NewInt(5)
    six   = big.NewInt(6)
    ten   = big.NewInt(10)
    max   = big.NewInt(100000)
)

func pollardRho(n, c *big.Int) *big.Int {
    g := func(x, y *big.Int) *big.Int {
        x2 := new(big.Int)
        x2.Mul(x, x)
        x2.Add(x2, c)
        return x2.Mod(x2, y)
    }
    x, y, z := big.NewInt(2), big.NewInt(2), big.NewInt(1)
    d := new(big.Int)
    count := 0
    for {
        x = g(x, n)
        y = g(g(y, n), n)
        d.Sub(x, y)
        d.Abs(d)
        d.Mod(d, n)
        z.Mul(z, d)
        count++
        if count == 100 {
            d.GCD(nil, nil, z, n)
            if d.Cmp(one) != 0 {
                break
            }
            z.Set(one)
            count = 0
        }
    }
    if d.Cmp(n) == 0 {
        return zero
    }
    return d
}

func smallestPrimeFactorWheel(n *big.Int) *big.Int {
    if n.ProbablyPrime(15) {
        return n
    }
    z := new(big.Int)
    if z.Rem(n, two).Cmp(zero) == 0 {
        return two
    }
    if z.Rem(n, three).Cmp(zero) == 0 {
        return three
    }
    if z.Rem(n, five).Cmp(zero) == 0 {
        return five
    }
    k := big.NewInt(7)
    i := 0
    inc := []*big.Int{four, two, four, two, four, six, two, six}
    for z.Mul(k, k).Cmp(n) <= 0 {
        if z.Rem(n, k).Cmp(zero) == 0 {
            return k
        }
        k.Add(k, inc[i])
        if k.Cmp(max) > 0 {
            break
        }
        i = (i + 1) % 8
    }
    return nil
}

func smallestPrimeFactor(n *big.Int) *big.Int {
    s := smallestPrimeFactorWheel(n)
    if s != nil {
        return s
    }
    c := big.NewInt(1)
    s = new(big.Int).Set(n)
    for n.Cmp(max) > 0 {
        d := pollardRho(n, c)
        if d.Cmp(zero) == 0 {
            if c.Cmp(ten) == 0 {
                log.Fatal("Pollard Rho doesn't appear to be working.")
            }
            c.Add(c, one)
        } else {
            // can't be sure PR will find the smallest prime factor first
            if d.Cmp(s) < 0 {
                s.Set(d)
            }
            n.Quo(n, d)
            if n.ProbablyPrime(5) {
                if n.Cmp(s) < 0 {
                    return n
                }
                return s
            }
        }
    }
    return s
}

func main() {
    k := 19
    fmt.Println("First", k, "terms of the Euclid–Mullin sequence:")
    fmt.Println(2)
    prod := big.NewInt(2)
    z := new(big.Int)
    count := 1
    for count < k {
        z.Add(prod, one)
        t := smallestPrimeFactor(z)
        fmt.Println(t)
        prod.Mul(prod, t)
        count++
    }
}
