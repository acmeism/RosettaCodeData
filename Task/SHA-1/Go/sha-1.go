package main

import (
    "crypto/sha1"
    "fmt"
)

func main() {
    h := sha1.New()
    h.Write([]byte("Rosetta Code"))
    fmt.Printf("%x\n", h.Sum(nil))
}
