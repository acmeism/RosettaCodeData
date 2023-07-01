package main

import (
    "fmt"
    "hash/crc32"
)

func main() {
    s := []byte("The quick brown fox jumps over the lazy dog")
    result := crc32.ChecksumIEEE(s)
    fmt.Printf("%X\n", result)
}
