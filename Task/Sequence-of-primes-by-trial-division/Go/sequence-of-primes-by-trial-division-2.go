package main

import "fmt"

func newP() func() int {
    n := 1
    return func() int {
        for {
            n++
            // Trial division as naïvely as possible.  For a candidate n,
            // numbers between 1 and n are checked to see if they divide n.
            // If no number divides n, n is prime.
            for f := 2; ; f++ {
                if f == n {
                    return n
                }
                if n%f == 0 { // here is the trial division
                    break
                }
            }
        }
    }
}

func main() {
    p := newP()
    fmt.Print("First twenty:")
    for i := 0; i < 20; i++ {
        fmt.Print(" ", p())
    }
    fmt.Println()
}
