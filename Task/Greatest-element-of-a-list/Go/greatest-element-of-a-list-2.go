package main

import (
    "fmt"
    "math/rand"
    "time"
)

// function, per task description
func largest(a []int) (lg int, ok bool) {
    if len(a) == 0 {
        return
    }
    lg = a[0]
    for _, e := range a[1:] {
        if e > lg {
            lg = e
        }
    }
    return lg, true
}

func main() {
    // random size slice
    rand.Seed(time.Now().UnixNano())
    a := make([]int, rand.Intn(11))
    for i := range a {
        a[i] = rand.Intn(101) - 100 // fill with random numbers
    }

    fmt.Println(a)
    lg, ok := largest(a)
    if ok {
        fmt.Println(lg)
    } else {
        fmt.Println("empty list.  no maximum.")
    }
}
