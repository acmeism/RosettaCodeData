package main

import (
    "fmt"
)

func utf8encode(codepoint rune) []byte {
    return []byte(string([]rune{codepoint}))
}

func utf8decode(bytes []byte) rune {
    return []rune(string(bytes))[0]
}

func main() {
        fmt.Printf("%-7s %7s\t%s\t%s\n", "Char", "Unicode", "UTF-8 encoded", "Decoded");
    for _, codepoint := range []rune{'A', 'ö', 'Ж', '€', '𝄞'} {
        encoded := utf8encode(codepoint)
        decoded := utf8decode(encoded)
        fmt.Printf("%-7c U+%04X\t%-12X\t%c\n", codepoint, codepoint, encoded, decoded)
    }
}
