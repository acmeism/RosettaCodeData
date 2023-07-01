package main

import (
    "crypto/sha256"
    "fmt"
    "log"
)

func main() {
    h := sha256.New()
    if _, err := h.Write([]byte("Rosetta code")); err != nil {
        log.Fatal(err)
    }
    fmt.Printf("%x\n", h.Sum(nil))
}
