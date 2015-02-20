package main

import (
    "bytes"
    "fmt"
)

type moveToFront string

func (symbols moveToFront) encode(s string) []int {
    seq := make([]int, len(s))
    pad := []byte(symbols)
    c1 := []byte{0}
    for i := 0; i < len(s); i++ {
        c := s[i]
        c1[0] = c
        x := bytes.Index(pad, c1)
        seq[i] = x
        copy(pad[1:], pad[:x])
        pad[0] = c
    }
    return seq
}
func (symbols moveToFront) decode(seq []int) string {
    chars := make([]byte, len(seq))
    pad := []byte(symbols)
    for i, x := range seq {
        c := pad[x]
        chars[i] = c
        copy(pad[1:], pad[:x])
        pad[0] = c
    }
    return string(chars)
}

func main() {
    m := moveToFront("abcdefghijklmnopqrstuvwxyz")
    for _, s := range []string{"broood", "bananaaa", "hiphophiphop"} {
        enc := m.encode(s)
        dec := m.decode(enc)
        fmt.Println(s, enc, dec)
        if dec != s {
            panic("Whoops!")
        }
    }
}
