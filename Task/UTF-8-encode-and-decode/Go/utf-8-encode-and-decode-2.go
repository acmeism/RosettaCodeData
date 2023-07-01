package main

import (
    "fmt"
    "unicode/utf8"
)

func utf8encode(codepoint rune) []byte {
    buffer := make([]byte, 4)
    length := utf8.EncodeRune(buffer, codepoint)
    return buffer[:length]
}

func utf8decode(bytes []byte) rune {
    result, _ := utf8.DecodeRune(bytes)
    return result
}

func main() {
        fmt.Printf("%-7s %7s\t%s\t%s\n", "Char", "Unicode", "UTF-8 encoded", "Decoded");
    for _, codepoint := range []rune{'A', 'ö', 'Ж', '€', '𝄞'} {
        encoded := utf8encode(codepoint)
        decoded := utf8decode(encoded)
        fmt.Printf("%-7c U+%04X\t%-12X\t%c\n", codepoint, codepoint, encoded, decoded)
    }
}
