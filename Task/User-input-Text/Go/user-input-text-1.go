package main

import "fmt"

func main() {
    var s string
    var i int
    if _, err := fmt.Scan(&s, &i); err == nil && i == 75000 {
        fmt.Println("good")
    } else {
        fmt.Println("wrong")
    }
}
