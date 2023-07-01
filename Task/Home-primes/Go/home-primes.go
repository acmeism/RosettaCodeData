package main

import (
    "fmt"
    "math/big"
    "rcu"
    "sort"
)

var zero = new(big.Int)
var one = big.NewInt(1)
var two = big.NewInt(2)
var three = big.NewInt(3)
var four = big.NewInt(4)
var five = big.NewInt(5)
var six = big.NewInt(6)

// simple wheel based prime factors routine for BigInt
func primeFactorsWheel(m *big.Int) []*big.Int {
    n := new(big.Int).Set(m)
    t := new(big.Int)
    inc := []*big.Int{four, two, four, two, four, six, two, six}
    var factors []*big.Int
    for t.Rem(n, two).Cmp(zero) == 0 {
        factors = append(factors, two)
        n.Quo(n, two)
    }
    for t.Rem(n, three).Cmp(zero) == 0 {
        factors = append(factors, three)
        n.Quo(n, three)
    }
    for t.Rem(n, five).Cmp(zero) == 0 {
        factors = append(factors, five)
        n.Quo(n, five)
    }
    k := big.NewInt(7)
    i := 0
    for t.Mul(k, k).Cmp(n) <= 0 {
        if t.Rem(n, k).Cmp(zero) == 0 {
            factors = append(factors, new(big.Int).Set(k))
            n.Quo(n, k)
        } else {
            k.Add(k, inc[i])
            i = (i + 1) % 8
        }
    }
    if n.Cmp(one) > 0 {
        factors = append(factors, n)
    }
    return factors
}

func pollardRho(n *big.Int) *big.Int {
    g := func(x, n *big.Int) *big.Int {
        x2 := new(big.Int)
        x2.Mul(x, x)
        x2.Add(x2, one)
        return x2.Mod(x2, n)
    }
    x, y, d := new(big.Int).Set(two), new(big.Int).Set(two), new(big.Int).Set(one)
    t, z := new(big.Int), new(big.Int).Set(one)
    count := 0
    for {
        x = g(x, n)
        y = g(g(y, n), n)
        t.Sub(x, y)
        t.Abs(t)
        t.Mod(t, n)
        z.Mul(z, t)
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
        return new(big.Int)
    }
    return d
}

func primeFactors(m *big.Int) []*big.Int {
    n := new(big.Int).Set(m)
    var factors []*big.Int
    lim := big.NewInt(1e9)
    for n.Cmp(one) > 0 {
        if n.Cmp(lim) > 0 {
            d := pollardRho(n)
            if d.Cmp(zero) != 0 {
                factors = append(factors, primeFactorsWheel(d)...)
                n.Quo(n, d)
                if n.ProbablyPrime(10) {
                    factors = append(factors, n)
                    break
                }
            } else {
                factors = append(factors, primeFactorsWheel(n)...)
                break
            }
        } else {
            factors = append(factors, primeFactorsWheel(n)...)
            break
        }
    }
    sort.Slice(factors, func(i, j int) bool { return factors[i].Cmp(factors[j]) < 0 })
    return factors
}

func main() {
    list := make([]int, 20)
    for i := 2; i <= 20; i++ {
        list[i-2] = i
    }
    list[19] = 65
    for _, i := range list {
        if rcu.IsPrime(i) {
            fmt.Printf("HP%d = %d\n", i, i)
            continue
        }
        n := 1
        j := big.NewInt(int64(i))
        h := []*big.Int{j}
        for {
            pf := primeFactors(j)
            k := ""
            for _, f := range pf {
                k += fmt.Sprintf("%d", f)
            }
            j, _ = new(big.Int).SetString(k, 10)
            h = append(h, j)
            if j.ProbablyPrime(10) {
                for l := n; l > 0; l-- {
                    fmt.Printf("HP%d(%d) = ", h[n-l], l)
                }
                fmt.Println(h[n])
                break
            } else {
                n++
            }
        }
    }
}
