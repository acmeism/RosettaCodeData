package main

import (
    "fmt"
    "strings"
)

type test struct {
    bs string
    n  int
}

func setRightBits(bits []byte, e, n int) []byte {
    if e == 0 || n <= 0 {
        return bits
    }
    bits2 := make([]byte, len(bits))
    copy(bits2, bits)
    for i := 0; i < e-1; i++ {
        c := bits[i]
        if c == 1 {
            j := i + 1
            for j <= i+n && j < e {
                bits2[j] = 1
                j++
            }
        }
    }
    return bits2
}

func main() {
    b := "010000000000100000000010000000010000000100000010000010000100010010"
    tests := []test{
        test{"1000", 2}, test{"0100", 2}, test{"0010", 2}, test{"0000", 2},
        test{b, 0}, test{b, 1}, test{b, 2}, test{b, 3},
    }
    for _, test := range tests {
        bs := test.bs
        e := len(bs)
        n := test.n
        fmt.Println("n =", n, "\b; Width e =", e, "\b:")
        fmt.Println("    Input b:", bs)
        bits := []byte(bs)
        for i := 0; i < len(bits); i++ {
            bits[i] = bits[i] - '0'
        }
        bits = setRightBits(bits, e, n)
        var sb strings.Builder
        for i := 0; i < len(bits); i++ {
            sb.WriteByte(bits[i] + '0')
        }
        fmt.Println("    Result :", sb.String())
    }
}
