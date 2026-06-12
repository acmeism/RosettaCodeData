package main

import (
    "fmt"
    "time"
)

func main() {
    start := time.Now()
    for a := 3; ; a++ {
        for b := a + 1; ; b++ {
            c := 1000 - a - b
            if c <= b {
                break
            }
            if a*a+b*b == c*c {
                fmt.Printf("a = %d, b = %d, c = %d\n", a, b, c)
                fmt.Println("a + b + c =", a+b+c)
                fmt.Println("a * b * c =", a*b*c)
                fmt.Println("\nTook", time.Since(start))
                return
            }
        }
    }
}
