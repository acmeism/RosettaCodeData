package main

import "fmt"

type sBox [8][16]byte

type gost struct {
    k87, k65, k43, k21 [256]byte
    enc                []byte
}

func newGost(s *sBox) *gost {
    var g gost
    for i := range g.k87 {
        g.k87[i] = s[7][i>>4]<<4 | s[6][i&15]
        g.k65[i] = s[5][i>>4]<<4 | s[4][i&15]
        g.k43[i] = s[3][i>>4]<<4 | s[2][i&15]
        g.k21[i] = s[1][i>>4]<<4 | s[0][i&15]
    }
    g.enc = make([]byte, 8)
    return &g
}

func (g *gost) f(x uint32) uint32 {
    x = uint32(g.k87[x>>24&255])<<24 | uint32(g.k65[x>>16&255])<<16 |
        uint32(g.k43[x>>8&255])<<8 | uint32(g.k21[x&255])
    return x<<11 | x>>(32-11)
}

// code above adapted from posted C code

// validation code below follows example on talk page

// cbrf from WP
var cbrf = sBox{
    {4, 10, 9, 2, 13, 8, 0, 14, 6, 11, 1, 12, 7, 15, 5, 3},
    {14, 11, 4, 12, 6, 13, 15, 10, 2, 3, 8, 1, 0, 7, 5, 9},
    {5, 8, 1, 13, 10, 3, 4, 2, 14, 15, 12, 7, 6, 0, 9, 11},
    {7, 13, 10, 1, 0, 8, 9, 15, 14, 4, 6, 12, 11, 2, 5, 3},
    {6, 12, 7, 1, 5, 15, 13, 8, 4, 10, 9, 14, 0, 3, 11, 2},
    {4, 11, 10, 0, 7, 2, 1, 13, 3, 6, 8, 5, 9, 12, 15, 14},
    {13, 11, 4, 1, 3, 15, 5, 9, 0, 10, 14, 7, 6, 8, 2, 12},
    {1, 15, 13, 0, 5, 7, 10, 4, 9, 2, 3, 14, 6, 11, 8, 12},
}

func u32(b []byte) uint32 {
    return uint32(b[0]) | uint32(b[1])<<8 | uint32(b[2])<<16 | uint32(b[3])<<24
}

func b4(u uint32, b []byte) {
    b[0] = byte(u)
    b[1] = byte(u >> 8)
    b[2] = byte(u >> 16)
    b[3] = byte(u >> 24)
}

func (g *gost) mainStep(input []byte, key []byte) {
    key32 := u32(key)
    input1 := u32(input[:4])
    input2 := u32(input[4:])
    b4(g.f(key32+input1)^input2, g.enc[:4])
    copy(g.enc[4:], input[:4])
}

func main() {
    input := []byte{0x21, 0x04, 0x3B, 0x04, 0x30, 0x04, 0x32, 0x04}
    key := []byte{0xF9, 0x04, 0xC1, 0xE2}

    g := newGost(&cbrf)
    g.mainStep(input, key)
    for _, b := range g.enc {
        fmt.Printf("[%02x]", b)
    }
    fmt.Println()
}
