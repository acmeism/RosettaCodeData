package main

import (
    "fmt"
    big "github.com/ncw/gmp"
    "time"
)

var (
    one   = new(big.Int).SetUint64(1)
    two   = new(big.Int).SetUint64(2)
    three = new(big.Int).SetUint64(3)
)

func min(i, j int) int {
    if i < j {
        return i
    }
    return j
}

func pierpont(n int, first bool) (p [2][]*big.Int) {
    p[0] = make([]*big.Int, n)
    p[1] = make([]*big.Int, n)
    for i := 0; i < n; i++ {
        p[0][i] = new(big.Int)
        p[1][i] = new(big.Int)
    }
    p[0][0].Set(two)
    count, count1, count2 := 0, 1, 0
    var s []*big.Int
    s = append(s, new(big.Int).Set(one))
    i2, i3, k := 0, 0, 1
    n2, n3, t := new(big.Int), new(big.Int), new(big.Int)
    for count < n {
        n2.Mul(s[i2], two)
        n3.Mul(s[i3], three)
        if n2.Cmp(n3) < 0 {
            t.Set(n2)
            i2++
        } else {
            t.Set(n3)
            i3++
        }
        if t.Cmp(s[k-1]) > 0 {
            s = append(s, new(big.Int).Set(t))
            k++
            t.Add(t, one)
            if count1 < n && t.ProbablyPrime(10) {
                p[0][count1].Set(t)
                count1++
            }
            t.Sub(t, two)
            if count2 < n && t.ProbablyPrime(10) {
                p[1][count2].Set(t)
                count2++
            }
            count = min(count1, count2)
        }
    }
    return p
}

func main() {
    start := time.Now()
    p := pierpont(2000, true)
    fmt.Println("First 50 Pierpont primes of the first kind:")
    for i := 0; i < 50; i++ {
        fmt.Printf("%8d ", p[0][i])
        if (i-9)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\nFirst 50 Pierpont primes of the second kind:")
    for i := 0; i < 50; i++ {
        fmt.Printf("%8d ", p[1][i])
        if (i-9)%10 == 0 {
            fmt.Println()
        }
    }

    fmt.Println("\n250th Pierpont prime of the first kind:", p[0][249])
    fmt.Println("\n250th Pierpont prime of the second kind:", p[1][249])

    fmt.Println("\n1000th Pierpont prime of the first kind:", p[0][999])
    fmt.Println("\n1000th Pierpont prime of the second kind:", p[1][999])

    fmt.Println("\n2000th Pierpont prime of the first kind:", p[0][1999])
    fmt.Println("\n2000th Pierpont prime of the second kind:", p[1][1999])

    elapsed := time.Now().Sub(start)
    fmt.Printf("\nTook %s\n", elapsed)
}
