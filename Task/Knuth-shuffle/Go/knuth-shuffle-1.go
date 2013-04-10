package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    var a [20]int
    for i := range a {
        a[i] = i
    }
    fmt.Println(a)

    rand.Seed(time.Now().UnixNano())
    for i := len(a) - 1; i >= 1; i-- {
        j := rand.Intn(i + 1)
        a[i], a[j] = a[j], a[i]
    }
    fmt.Println(a)
}
