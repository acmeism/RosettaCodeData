package main

import "fmt"

var table [256]uint32

func init() {
    for i := range table {
        word := uint32(i)
        for j := 0; j < 8; j++ {
            if word&1 == 1 {
                word = (word >> 1) ^ 0xedb88320
            } else {
                word >>= 1
            }
        }
        table[i] = word
    }
}

func crc32(s string) uint32 {
    crc := ^uint32(0)
    for i := 0; i < len(s); i++ {
        crc = table[byte(crc)^s[i]] ^ (crc >> 8)
    }
    return ^crc
}

func main() {
    fmt.Printf("%0x\n", crc32("The quick brown fox jumps over the lazy dog"))
}
