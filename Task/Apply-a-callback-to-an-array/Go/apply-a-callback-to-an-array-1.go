package main

import "fmt"

func main() {
    for _, i := range []int{1, 2, 3, 4, 5} {
        fmt.Println(i * i)
    }
}
