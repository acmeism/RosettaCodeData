package main

import (
    "fmt"
    "math/rand"
    "sort"
    "time"
)

func main() {
    s := rand.NewSource(time.Now().UnixNano())
    r := rand.New(s)
    for {
        var values [6]int
        vsum := 0
        for i := range values {
            var numbers [4]int
            for j := range numbers {
                numbers[j] = 1 + r.Intn(6)
            }
            sort.Ints(numbers[:])
            nsum := 0
            for _, n := range numbers[1:] {
                nsum += n
            }
            values[i] = nsum
            vsum += values[i]
        }
        if vsum < 75 {
            continue
        }
        vcount := 0
        for _, v := range values {
            if v >= 15 {
                vcount++
            }
        }
        if vcount < 2 {
            continue
        }
        fmt.Println("The 6 random numbers generated are:")
        fmt.Println(values)
        fmt.Println("\nTheir sum is", vsum, "and", vcount, "of them are >= 15")
        break
    }
}
