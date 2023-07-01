package main

import (
    "fmt"
    "math/big"
)

func main() {
    one := big.NewInt(1)
    two := big.NewInt(2)
    next := new(big.Int)
    sylvester := []*big.Int{two}
    prod := new(big.Int).Set(two)
    count := 1
    for count < 10 {
        next.Add(prod, one)
        sylvester = append(sylvester, new(big.Int).Set(next))
        count++
        prod.Mul(prod, next)
    }
    fmt.Println("The first 10 terms in the Sylvester sequence are:")
    for i := 0; i < 10; i++ {
        fmt.Println(sylvester[i])
    }

    sumRecip := new(big.Rat)
    for _, s := range sylvester {
        sumRecip.Add(sumRecip, new(big.Rat).SetFrac(one, s))
    }
    fmt.Println("\nThe sum of their reciprocals as a rational number is:")
    fmt.Println(sumRecip)
    fmt.Println("\nThe sum of their reciprocals as a decimal number (to 211 places) is:")
    fmt.Println(sumRecip.FloatString(211))
}
