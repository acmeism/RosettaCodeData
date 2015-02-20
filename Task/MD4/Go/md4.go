package main

import (
    "golang.org/x/crypto/md4"
    "fmt"
)

func main() {
    h := md4.New()
    h.Write([]byte("Rosetta Code"))
    fmt.Printf("%x\n", h.Sum(nil))
}
