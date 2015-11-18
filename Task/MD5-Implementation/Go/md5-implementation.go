package main

import (
    "fmt"
    "math"
    "bytes"
    "encoding/binary"
)

type testCase struct {
    hashCode string
    string
}

var testCases = []testCase{
    {"d41d8cd98f00b204e9800998ecf8427e", ""},
    {"0cc175b9c0f1b6a831c399e269772661", "a"},
    {"900150983cd24fb0d6963f7d28e17f72", "abc"},
    {"f96b697d7cb7938d525a2f31aaf161d0", "message digest"},
    {"c3fcd3d76192e4007dfb496cca67e13b", "abcdefghijklmnopqrstuvwxyz"},
    {"d174ab98d277d9f5a5611c2c9f419d9f",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"},
    {"57edf4a22be3c955ac49da2e2107b67a", "12345678901234567890" +
        "123456789012345678901234567890123456789012345678901234567890"},
}

func main() {
    for _, tc := range testCases {
        fmt.Printf("%s\n%x\n\n", tc.hashCode, md5(tc.string))
    }
}

var shift = [...]uint{7, 12, 17, 22, 5, 9, 14, 20, 4, 11, 16, 23, 6, 10, 15, 21}
var table [64]uint32

func init() {
    for i := range table {
        table[i] = uint32((1 << 32) * math.Abs(math.Sin(float64(i + 1))))
    }
}

func md5(s string) (r [16]byte) {
    padded := bytes.NewBuffer([]byte(s))
    padded.WriteByte(0x80)
    for padded.Len() % 64 != 56 {
        padded.WriteByte(0)
    }
    messageLenBits := uint64(len(s)) * 8
    binary.Write(padded, binary.LittleEndian, messageLenBits)

    var a, b, c, d uint32 = 0x67452301, 0xEFCDAB89, 0x98BADCFE, 0x10325476
    var buffer [16]uint32
    for binary.Read(padded, binary.LittleEndian, buffer[:]) == nil { // read every 64 bytes
        a1, b1, c1, d1 := a, b, c, d
        for j := 0; j < 64; j++ {
            var f uint32
            bufferIndex := j
            round := j >> 4
            switch round {
            case 0:
                f = (b1 & c1) | (^b1 & d1)
            case 1:
                f = (b1 & d1) | (c1 & ^d1)
                bufferIndex = (bufferIndex*5 + 1) & 0x0F
            case 2:
                f = b1 ^ c1 ^ d1
                bufferIndex = (bufferIndex*3 + 5) & 0x0F
            case 3:
                f = c1 ^ (b1 | ^d1)
                bufferIndex = (bufferIndex * 7) & 0x0F
            }
            sa := shift[(round<<2)|(j&3)]
            a1 += f + buffer[bufferIndex] + table[j]
            a1, d1, c1, b1 = d1, c1, b1, a1<<sa|a1>>(32-sa)+b1
        }
        a, b, c, d = a+a1, b+b1, c+c1, d+d1
    }

    binary.Write(bytes.NewBuffer(r[:0]), binary.LittleEndian, []uint32{a, b, c, d})
    return
}
