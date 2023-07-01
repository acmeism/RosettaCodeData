package main

import (
    "fmt"
    "math/big"
)

func harmonic(n int) *big.Rat {
    sum := new(big.Rat)
    for i := int64(1); i <= int64(n); i++ {
        r := big.NewRat(1, i)
        sum.Add(sum, r)
    }
    return sum
}

func main() {
    fmt.Println("The first 20 harmonic numbers and the 100th, expressed in rational form, are:")
    numbers := make([]int, 21)
    for i := 1; i <= 20; i++ {
        numbers[i-1] = i
    }
    numbers[20] = 100
    for _, i := range numbers {
        fmt.Printf("%3d : %s\n", i, harmonic(i))
    }

    fmt.Println("\nThe first harmonic number to exceed the following integers is:")
    const limit = 10
    for i, n, h := 1, 1, 0.0; i <= limit; n++ {
        h += 1.0 / float64(n)
        if h > float64(i) {
            fmt.Printf("integer = %2d  -> n = %6d  ->  harmonic number = %9.6f (to 6dp)\n", i, n, h)
            i++
        }
    }
}
