package main

import(
    "fmt"
    "strings"
)

var codes = map[rune]string {
    'a' : "AAAAA", 'b' : "AAAAB", 'c' : "AAABA", 'd' : "AAABB", 'e' : "AABAA",
    'f' : "AABAB", 'g' : "AABBA", 'h' : "AABBB", 'i' : "ABAAA", 'j' : "ABAAB",
    'k' : "ABABA", 'l' : "ABABB", 'm' : "ABBAA", 'n' : "ABBAB", 'o' : "ABBBA",
    'p' : "ABBBB", 'q' : "BAAAA", 'r' : "BAAAB", 's' : "BAABA", 't' : "BAABB",
    'u' : "BABAA", 'v' : "BABAB", 'w' : "BABBA", 'x' : "BABBB", 'y' : "BBAAA",
    'z' : "BBAAB", ' ' : "BBBAA",  // use ' ' to denote any non-letter
}

func baconEncode(plainText string, message string) string {
    pt := strings.ToLower(plainText)
    var sb []byte
    for _, c := range pt {
        if c >= 'a' && c <= 'z' {
            sb = append(sb, codes[c]...)
        } else {
            sb = append(sb, codes[' ']...)
        }
    }
    et := string(sb)
    mg := strings.ToLower(message)  // 'A's to be in lower case, 'B's in upper case
    sb = nil  // clear the byte slice
    var count = 0
    for _, c := range mg {
        if c >= 'a' && c <= 'z' {
            if et[count] == 'A' {
                sb = append(sb, byte(c))
            } else {
                sb = append(sb, byte(c - 32))  // upper case equivalent
            }
            count++
            if count == len(et) { break }
        } else {
            sb = append(sb, byte(c))
        }
    }
    return string(sb)
}

func baconDecode(message string) string {
    var sb []byte
    for _, c := range message {
        if c >= 'a' && c <= 'z' {
            sb = append(sb, 'A')
        } else if c >= 'A' && c <= 'Z' {
            sb = append(sb, 'B')
        }
    }
    et := string(sb)
    sb = nil  // clear the byte slice
    for i := 0; i < len(et); i += 5 {
        quintet := et[i : i + 5]
        for k, v := range codes {
            if v == quintet {
                sb = append(sb, byte(k))
                break
            }
        }
    }
    return string(sb)
}

func main() {
    plainText := "the quick brown fox jumps over the lazy dog"
    message := "bacon's cipher is a method of steganography created by francis bacon." +
        "this task is to implement a program for encryption and decryption of " +
        "plaintext using the simple alphabet of the baconian cipher or some " +
        "other kind of representation of this alphabet (make anything signify anything). " +
        "the baconian alphabet may optionally be extended to encode all lower " +
        "case characters individually and/or adding a few punctuation characters " +
        "such as the space."
    cipherText := baconEncode(plainText, message)
    fmt.Printf("Cipher text ->\n\n%s\n", cipherText)
    decodedText := baconDecode(cipherText)
    fmt.Printf("\nHidden text ->\n\n%s\n", decodedText)
}
