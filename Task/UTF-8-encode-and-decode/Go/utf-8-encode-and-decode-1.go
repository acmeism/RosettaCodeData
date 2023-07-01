package main

import (
    "bytes"
    "encoding/hex"
    "fmt"
    "log"
    "strings"
)

var testCases = []struct {
    rune
    string
}{
    {'A', "41"},
    {'ö', "C3 B6"},
    {'Ж', "D0 96"},
    {'€', "E2 82 AC"},
    {'𝄞', "F0 9D 84 9E"},
}

func main() {
    for _, tc := range testCases {
        // derive some things from test data
        u := fmt.Sprintf("U+%04X", tc.rune)
        b, err := hex.DecodeString(strings.Replace(tc.string, " ", "", -1))
        if err != nil {
            log.Fatal("bad test data")
        }
        // exercise encoder and decoder on test data
        e := encodeUTF8(tc.rune)
        d := decodeUTF8(b)
        // show function return values
        fmt.Printf("%c  %-7s  %X\n", d, u, e)
        // validate return values against test data
        if !bytes.Equal(e, b) {
            log.Fatal("encodeUTF8 wrong")
        }
        if d != tc.rune {
            log.Fatal("decodeUTF8 wrong")
        }
    }
}

const (
    // first byte of a 2-byte encoding starts 110 and carries 5 bits of data
    b2Lead = 0xC0 // 1100 0000
    b2Mask = 0x1F // 0001 1111

    // first byte of a 3-byte encoding starts 1110 and carries 4 bits of data
    b3Lead = 0xE0 // 1110 0000
    b3Mask = 0x0F // 0000 1111

    // first byte of a 4-byte encoding starts 11110 and carries 3 bits of data
    b4Lead = 0xF0 // 1111 0000
    b4Mask = 0x07 // 0000 0111

    // non-first bytes start 10 and carry 6 bits of data
    mbLead = 0x80 // 1000 0000
    mbMask = 0x3F // 0011 1111
)

func encodeUTF8(r rune) []byte {
    switch i := uint32(r); {
    case i <= 1<<7-1: // max code point that encodes into a single byte
        return []byte{byte(r)}
    case i <= 1<<11-1: // into two bytes
        return []byte{
            b2Lead | byte(r>>6),
            mbLead | byte(r)&mbMask}
    case i <= 1<<16-1: // three
        return []byte{
            b3Lead | byte(r>>12),
            mbLead | byte(r>>6)&mbMask,
            mbLead | byte(r)&mbMask}
    default:
        return []byte{
            b4Lead | byte(r>>18),
            mbLead | byte(r>>12)&mbMask,
            mbLead | byte(r>>6)&mbMask,
            mbLead | byte(r)&mbMask}
    }
}

func decodeUTF8(b []byte) rune {
    switch b0 := b[0]; {
    case b0 < 0x80:
        return rune(b0)
    case b0 < 0xE0:
        return rune(b0&b2Mask)<<6 |
            rune(b[1]&mbMask)
    case b0 < 0xF0:
        return rune(b0&b3Mask)<<12 |
            rune(b[1]&mbMask)<<6 |
            rune(b[2]&mbMask)
    default:
        return rune(b0&b4Mask)<<18 |
            rune(b[1]&mbMask)<<12 |
            rune(b[2]&mbMask)<<6 |
            rune(b[3]&mbMask)
    }
}
