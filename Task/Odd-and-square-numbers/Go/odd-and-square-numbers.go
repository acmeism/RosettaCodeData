package main

import (
    "fmt"
    "math"
)

func main() {
    pow := 1
    for p := 0; p < 5; p++ {
        low := int(math.Ceil(math.Sqrt(float64(pow))))
        if low%2 == 0 {
            low++
        }
        pow *= 10
        high := int(math.Sqrt(float64(pow)))
        var oddSq []int
        for i := low; i <= high; i += 2 {
            oddSq = append(oddSq, i*i)
        }
        fmt.Println(len(oddSq), "odd squares from", pow/10, "to", pow, "\b:")
        for i := 0; i < len(oddSq); i++ {
            fmt.Printf("%d ", oddSq[i])
            if (i+1)%10 == 0 {
                fmt.Println()
            }
        }
        fmt.Println("\n")
    }
}
