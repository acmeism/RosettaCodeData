package main

import "fmt"

func gcd(x, y int) int {
    for y != 0 {
        x, y = y, x%y
    }
    return x
}

func main() {
    fmt.Println(gcd(33, 77))
    fmt.Println(gcd(49865, 69811))
}
