package main

import (
    "bytes"
    "fmt"
    "math/rand"
    "time"
)

func init() {
    rand.Seed(time.Now().UnixNano())
}

func generate(n uint) string {
    a := bytes.Repeat([]byte("[]"), int(n))
    for i := len(a) - 1; i >= 1; i-- {
        j := rand.Intn(i + 1)
        a[i], a[j] = a[j], a[i]
    }
    return string(a)
}

func testBalanced(s string) {
    fmt.Print(s + ": ")
    open := 0
    for _,c := range s {
        switch c {
        case '[':
            open++
        case ']':
            if open == 0 {
                fmt.Println("not ok")
                return
            }
            open--
        default:
            fmt.Println("not ok")
            return
        }
    }
    if open == 0 {
        fmt.Println("ok")
    } else {
        fmt.Println("not ok")
    }
}

func main() {
    rand.Seed(time.Now().UnixNano())
    for i := uint(0); i < 10; i++ {
        testBalanced(generate(i))
    }
    testBalanced("()")
}
