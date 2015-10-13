package main

import "fmt"

var v = []float32{1, 2, .5}

func main() {
    var sum float32
    for _, x := range v {
        sum += x * x
    }
    fmt.Println(sum)
}
