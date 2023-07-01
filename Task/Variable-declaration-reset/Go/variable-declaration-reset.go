package main

import "fmt"

func main() {
    s := []int{1, 2, 2, 3, 4, 4, 5}

    // There is no output as 'prev' is created anew each time
    // around the loop and set implicitly to zero.
    for i := 0; i < len(s); i++ {
        curr := s[i]
        var prev int
        if i > 0 && curr == prev {
            fmt.Println(i)
        }
        prev = curr
    }

    // Now 'prev' is created only once and reassigned
    // each time around the loop producing the desired output.
    var prev int
    for i := 0; i < len(s); i++ {
        curr := s[i]
        if i > 0 && curr == prev {
            fmt.Println(i)
        }
        prev = curr
    }
}
