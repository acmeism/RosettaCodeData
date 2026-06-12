package main

import (
    "fmt"
    "log"
    "math/rand"
    "time"
)

// Generates and prints all numbers within an inclusive range whose endpoints are
// non-negative 64-bit integers. The numbers are generated in random order with
// any repetitions being ignored.
func generate(from, to int64) {
    if to < from || from < 0 {
        log.Fatal("Invalid range.")
    }
    span := to - from + 1
    generated := make([]bool, span) // all false by default, zero indexing
    count := span
    for count > 0 {
        n := from + rand.Int63n(span) // upper endpoint is exclusive
        if !generated[n-from] {
            generated[n-from] = true
            fmt.Printf("%2d ", n)
            count--
        }
    }
    fmt.Println()
}

func main() {
    rand.Seed(time.Now().UnixNano())

    // generate 5 sets say
    for i := 1; i <= 5; i++ {
        generate(1, 20)
    }
}
