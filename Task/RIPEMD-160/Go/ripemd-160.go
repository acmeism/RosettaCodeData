package main

import (
    "golang.org/x/crypto/ripemd160"
    "fmt"
)

func main() {
    h := ripemd160.New()
    h.Write([]byte("Rosetta Code"))
    fmt.Printf("%x\n", h.Sum(nil))
}
