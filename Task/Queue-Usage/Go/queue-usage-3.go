package main

import (
    "fmt"
    "container/list"
)

func main() {
    q := list.New()
    fmt.Println("empty?", q.Len() == 0)

    x := "black"
    fmt.Println("push", x)
    q.PushBack(x)

    fmt.Println("empty?", q.Len() == 0)
    if e := q.Front(); e != nil {
        r := q.Remove(e)
        fmt.Println(r, "popped")
    } else {
        fmt.Println("pop failed")
    }

    var n int
    for _, x := range []string{"blue", "red", "green"} {
        fmt.Println("pushing", x)
        q.PushBack(x)
        n++
    }

    for i := 0; i < n; i++ {
        if e := q.Front(); e != nil {
            r := q.Remove(e)
            fmt.Println(r, "popped")
        } else {
            fmt.Println("pop failed")
        }
    }
}
