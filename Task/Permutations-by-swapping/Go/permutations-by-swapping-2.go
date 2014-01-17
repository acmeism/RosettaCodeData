package main

import (
    "fmt"
    "permute"
)

func main() {
    p := []int{11, 22, 33}
    i := permute.Iter(p)
    for sign := i(); sign != 0; sign = i() {
        fmt.Println(p, sign)
    }
}
