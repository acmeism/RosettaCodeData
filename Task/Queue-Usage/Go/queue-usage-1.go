package main

import (
    "fmt"
    "queue"
)

func main() {
    q := new(queue.Queue)
    fmt.Println("empty?", q.Empty())

    x := "black"
    fmt.Println("push", x)
    q.Push(x)

    fmt.Println("empty?", q.Empty())
    r, ok := q.Pop()
    if ok {
        fmt.Println(r, "popped")
    } else {
        fmt.Println("pop failed")
    }

    var n int
    for _, x := range []string{"blue", "red", "green"} {
        fmt.Println("pushing", x)
        q.Push(x)
        n++
    }

    for i := 0; i < n; i++ {
        r, ok := q.Pop()
        if ok {
            fmt.Println(r, "popped")
        } else {
            fmt.Println("pop failed")
        }
    }
}
