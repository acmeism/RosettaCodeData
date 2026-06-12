package main

import (
    "fmt"
    "math"
    "rcu"
)

func main() {
    var squares []int
    limit := int(math.Sqrt(1000))
    i := 1
    for i <= limit {
        n := i * i
        if rcu.IsPrime(n + 1) {
            squares = append(squares, n)
        }
        if i == 1 {
            i = 2
        } else {
            i += 2
        }
    }
    fmt.Println("There are", len(squares), "square numbers 'n' where 'n+1' is prime, viz:")
    fmt.Println(squares)
}
