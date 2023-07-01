package main

import "fmt"

func swap(a, b *interface{}) {
    *a, *b = *b, *a
}

func main() {
    var a, b interface{} = 3, "four"
    fmt.Println(a, b)
    swap(&a, &b)
    fmt.Println(a, b)
}
