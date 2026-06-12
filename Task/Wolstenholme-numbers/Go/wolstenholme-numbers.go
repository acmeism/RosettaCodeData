package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "golang.org/x/exp/constraints"
    "rcu"
)

type Int = constraints.Integer

func ord[T Int](c T) string {
    m := c % 100
    if m >= 4 && m <= 20 {
        return "th"
    }
    m %= 10
    if m == 1 {
        return "st"
    } else if m == 2 {
        return "nd"
    } else if m == 3 {
        return "rd"
    } else {
        return "th"
    }
}

func abbreviate(s string) string {
    le := len(s)
    if le < 40 {
        return s
    }
    return s[:20] + "..." + s[le-20:]
}

func main() {
    pc, si := 0, 0
    l := [5]int64{500, 1000, 2500, 5000, 10000}
    w, h := new(big.Rat), new(big.Rat)
    primes := make([]*big.Int, 15)
    fmt.Println("Wolstenholme numbers:")
    for k := int64(1); k <= 10000; k++ {
        h.SetFrac64(1, k*k)
        w.Add(w, h)
        n := w.Num()
        if pc < 15 && n.ProbablyPrime(15) {
            primes[pc] = n
            pc++
        }
        if k <= 20 {
            fmt.Printf("%6d%s: %s\n", k, ord(k), n.String())
        } else if k == l[si] {
            s := n.String()
            a := abbreviate(s)
            ks := rcu.Commatize(k)
            fmt.Printf("%6s%s: %s (digits: %d)\n", ks, ord(k), a, len(s))
            si++
        }
    }
    fmt.Println("\nPrime Wolstenholme numbers:")
    for i, p := range primes {
        s := p.String()
        if i < 4 {
            fmt.Printf("%6d%s: %s\n", i+1, ord(i+1), s)
        } else {
            a := abbreviate(s)
            fmt.Printf("%6d%s: %s (digits: %d)\n", i+1, ord(i+1), a, len(s))
        }
    }
}
