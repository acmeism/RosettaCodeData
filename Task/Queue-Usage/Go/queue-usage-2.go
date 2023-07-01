package main

import "fmt"

func main() {
    q := make(chan string, 3)
    fmt.Println("empty?", len(q) == 0)

    x := "black"
    fmt.Println("push", x)
    q <- x

    fmt.Println("empty?", len(q) == 0)
    select {
    case r := <-q:
        fmt.Println(r, "popped")
    default:
        fmt.Println("pop failed")
    }

    var n int
    for _, x := range []string{"blue", "red", "green"} {
        fmt.Println("pushing", x)
        q <- x
        n++
    }

    for i := 0; i < n; i++ {
        select {
        case r := <-q:
            fmt.Println(r, "popped")
        default:
            fmt.Println("pop failed")
        }
    }
}
