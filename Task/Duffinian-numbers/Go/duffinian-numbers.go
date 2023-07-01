package main

import (
    "fmt"
    "math"
    "rcu"
)

func isSquare(n int) bool {
    s := int(math.Sqrt(float64(n)))
    return s*s == n
}

func main() {
    limit := 200000 // say
    d := rcu.PrimeSieve(limit-1, true)
    d[1] = false
    for i := 2; i < limit; i++ {
        if !d[i] {
            continue
        }
        if i%2 == 0 && !isSquare(i) && !isSquare(i/2) {
            d[i] = false
            continue
        }
        sigmaSum := rcu.SumInts(rcu.Divisors(i))
        if rcu.Gcd(sigmaSum, i) != 1 {
            d[i] = false
        }
    }

    var duff []int
    for i := 1; i < len(d); i++ {
        if d[i] {
            duff = append(duff, i)
        }
    }
    fmt.Println("First 50 Duffinian numbers:")
    rcu.PrintTable(duff[0:50], 10, 3, false)

    var triplets [][3]int
    for i := 2; i < limit; i++ {
        if d[i] && d[i-1] && d[i-2] {
            triplets = append(triplets, [3]int{i - 2, i - 1, i})
        }
    }
    fmt.Println("\nFirst 56 Duffinian triplets:")
    for i := 0; i < 14; i++ {
        s := fmt.Sprintf("%6v", triplets[i*4:i*4+4])
        fmt.Println(s[1 : len(s)-1])
    }
}
