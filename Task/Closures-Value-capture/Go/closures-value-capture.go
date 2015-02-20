package main

import "fmt"

func main() {
    fs := make([]func() int, 10)
    for i := range fs {
        i := i
        fs[i] = func() int {
            return i * i
        }
    }
    fmt.Println("func #0:", fs[0]())
    fmt.Println("func #3:", fs[3]())
}
