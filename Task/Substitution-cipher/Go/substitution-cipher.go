package main

import (
    "fmt"
    "strings"
)

var key = "]kYV}(!7P$n5_0i R:?jOWtF/=-pe'AD&@r6%ZXs\"v*N[#wSl9zq2^+g;LoB`aGh{3.HIu4fbK)mU8|dMET><,Qc\\C1yxJ"

func encode(s string) string {
    bs := []byte(s)
    for i := 0; i < len(bs); i++ {
        bs[i] = key[int(bs[i]) - 32]
    }
    return string(bs)
}

func decode(s string) string {
    bs := []byte(s)
    for i := 0; i < len(bs); i++ {
        bs[i] = byte(strings.IndexByte(key, bs[i]) + 32)
    }
    return string(bs)
}

func main() {
    s := "The quick brown fox jumps over the lazy dog, who barks VERY loudly!"
    enc := encode(s)
    fmt.Println("Encoded: ", enc)
    fmt.Println("Decoded: ", decode(enc))
}
