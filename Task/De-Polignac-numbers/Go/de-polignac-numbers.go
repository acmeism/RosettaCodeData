package main

import (
    "fmt"
    "rcu"
)

func main() {
    pows2 := make([]int, 20)
    for i := 0; i < 20; i++ {
        pows2[i] = 1 << i
    }
    dp := []int{1}
    dp1000, dp10000 := 0, 0
    for n, count := 3, 1; count < 10000; n += 2 {
        found := false
        for _, pow := range pows2 {
            if pow > n {
                break
            }
            if rcu.IsPrime(n - pow) {
                found = true
                break
            }
        }
        if !found {
            count++
            if count <= 50 {
                dp = append(dp, n)
            } else if count == 1000 {
                dp1000 = n
            } else if count == 10000 {
                dp10000 = n
            }
        }
    }
    fmt.Println("First 50 De Polignac numbers:")
    rcu.PrintTable(dp, 10, 5, true)
    fmt.Printf("\nOne thousandth: %s\n", rcu.Commatize(dp1000))
    fmt.Printf("\nTen thousandth: %s\n", rcu.Commatize(dp10000))
}
