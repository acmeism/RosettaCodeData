package main

import "fmt"

func ord(n int) string {
    s := "th"
    switch c := n % 10; c {
    case 1, 2, 3:
        if n%100/10 == 1 {
            break
        }
        switch c {
        case 1:
            s = "st"
        case 2:
            s = "nd"
        case 3:
            s = "rd"
        }
    }
    return fmt.Sprintf("%d%s", n, s)
}

func main() {
    for n := 0; n <= 25; n++ {
        fmt.Printf("%s ", ord(n))
    }
    fmt.Println()
    for n := 250; n <= 265; n++ {
        fmt.Printf("%s ", ord(n))
    }
    fmt.Println()
    for n := 1000; n <= 1025; n++ {
        fmt.Printf("%s ", ord(n))
    }
    fmt.Println()
}
