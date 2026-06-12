package main

import (
    "fmt"
    "rcu"
)

func main() {
    prods := make([]int, 100)
    prods[0] = 1
    for i := 2; i <= 100; i++ {
        factors := rcu.PrimeFactors(i)
        prods[i-1] = factors[0] * factors[len(factors)-1]
    }
    fmt.Println("Product of smallest and greatest prime factors of n for 1 to 100:")
    rcu.PrintTable(prods, 10, 4, false)
}
