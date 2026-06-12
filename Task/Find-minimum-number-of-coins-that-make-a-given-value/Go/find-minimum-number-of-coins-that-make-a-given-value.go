package main

import "fmt"

func main() {
    denoms := []int{200, 100, 50, 20, 10, 5, 2, 1}
    coins := 0
    amount := 988
    remaining := 988
    fmt.Println("The minimum number of coins needed to make a value of", amount, "is as follows:")
    for _, denom := range denoms {
        n := remaining / denom
        if n > 0 {
            coins += n
            fmt.Printf("  %3d x %d\n", denom, n)
            remaining %= denom
            if remaining == 0 {
                break
            }
        }
    }
    fmt.Println("\nA total of", coins, "coins in all.")
}
