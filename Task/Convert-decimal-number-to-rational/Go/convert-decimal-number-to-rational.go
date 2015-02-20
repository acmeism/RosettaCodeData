package main

import (
    "fmt"
    "math/big"
)

func main() {
    for _, d := range []string{"0.9054054", "0.518518", "0.75"} {
        if r, ok := new(big.Rat).SetString(d); ok {
            fmt.Println(d, "=", r)
        } else {
            fmt.Println(d, "invalid decimal number")
        }
    }
}
