package main

import (
    "fmt"
    "strings"
    "unicode"
)

type ckey struct {
    enc, dec unicode.SpecialCase
}

func newCaesar(k int) (*ckey, bool) {
    if k < 1 || k > 25 {
        return nil, false
    }
    i := uint32(k)
    r := rune(k)
    return &ckey{
        unicode.SpecialCase{
            {'A', 'Z' - i, [3]rune{r}},
            {'Z' - i + 1, 'Z', [3]rune{r - 26}},
            {'a', 'z' - i, [3]rune{r}},
            {'z' - i + 1, 'z', [3]rune{r - 26}},
        },
        unicode.SpecialCase{
            {'A', 'A' + i - 1, [3]rune{26 - r}},
            {'A' + i, 'Z', [3]rune{-r}},
            {'a', 'a' + i - 1, [3]rune{26 - r}},
            {'a' + i, 'z', [3]rune{-r}},
        },
    }, true
}

func (ck ckey) encipher(pt string) string {
    return strings.ToUpperSpecial(ck.enc, pt)
}

func (ck ckey) decipher(ct string) string {
    return strings.ToUpperSpecial(ck.dec, ct)
}

func main() {
    pt := "The five boxing wizards jump quickly"
    fmt.Println("Plaintext:", pt)
    for _, key := range []int{0, 1, 7, 25, 26} {
        ck, ok := newCaesar(key)
        if !ok {
            fmt.Println("Key", key, "invalid")
            continue
        }
        ct := ck.encipher(pt)
        fmt.Println("Key", key)
        fmt.Println("  Enciphered:", ct)
        fmt.Println("  Deciphered:", ck.decipher(ct))
    }
}
