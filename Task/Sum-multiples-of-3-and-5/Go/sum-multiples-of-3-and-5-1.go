package main

import "fmt"

func main() {
    fmt.Println(s35(1000))
}

func s35(i int) int {
    i--
    sum2 := func(d int) int {
        n := i / d
        return d * n * (n + 1)
    }
    return (sum2(3) + sum2(5) - sum2(15)) / 2
}
