package main

import (
    "fmt"
    "math"
    "rcu"
)

func magicConstant(n int) int {
    return (n*n + 1) * n / 2
}

var ss = []string{
    "\u2070", "\u00b9", "\u00b2", "\u00b3", "\u2074",
    "\u2075", "\u2076", "\u2077", "\u2078", "\u2079",
}

func superscript(n int) string {
    if n < 10 {
        return ss[n]
    }
    if n < 20 {
        return ss[1] + ss[n-10]
    }
    return ss[2] + ss[0]
}

func main() {
    fmt.Println("First 20 magic constants:")
    for n := 3; n <= 22; n++ {
        fmt.Printf("%5d ", magicConstant(n))
        if (n-2)%10 == 0 {
            fmt.Println()
        }
    }

    fmt.Println("\n1,000th magic constant:", rcu.Commatize(magicConstant(1002)))

    fmt.Println("\nSmallest order magic square with a constant greater than:")
    for i := 1; i <= 20; i++ {
        goal := math.Pow(10, float64(i))
        order := int(math.Cbrt(goal*2)) + 1
        fmt.Printf("10%-2s : %9s\n", superscript(i), rcu.Commatize(order))
    }
}
