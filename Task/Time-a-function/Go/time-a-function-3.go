package main

import (
    "fmt"
    "testing"
)

func empty() {}

func count() {
    for i := 0; i < 1e6; i++ {
    }
}

func main() {
    e := testing.Benchmark(func(b *testing.B) {
        for i := 0; i < b.N; i++ {
            empty()
        }
    })
    c := testing.Benchmark(func(b *testing.B) {
        for i := 0; i < b.N; i++ {
            count()
        }
    })
    fmt.Println("Empty function:    ", e)
    fmt.Println("Count to a million:", c)
    fmt.Println()
    fmt.Printf("Empty: %12.4f\n", float64(e.T.Nanoseconds())/float64(e.N))
    fmt.Printf("Count: %12.4f\n", float64(c.T.Nanoseconds())/float64(c.N))
}
