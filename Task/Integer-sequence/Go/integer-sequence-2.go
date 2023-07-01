package main

import (
    "big"
    "fmt"
)

func main() {
    one := big.NewInt(1)
    for i := big.NewInt(1);; i.Add(i, one) {
        fmt.Println(i)
    }
}
