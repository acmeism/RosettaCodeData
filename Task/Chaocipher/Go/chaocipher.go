package main

import(
    "fmt"
    "strings"
    "unicode/utf8"
)

type Mode int

const(
    Encrypt Mode = iota
    Decrypt
)

const(
    lAlphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
    rAlphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC"
)

func Chao(text string, mode Mode, showSteps bool) string {
    len := len(text)
    if utf8.RuneCountInString(text) != len {
        fmt.Println("Text contains non-ASCII characters")
        return ""
    }
    left  := lAlphabet
    right := rAlphabet
    eText := make([]byte, len)
    temp  := make([]byte, 26)

    for i := 0; i < len; i++ {
        if showSteps {
            fmt.Println(left, " ", right)
        }
        var index int
        if mode == Encrypt {
            index = strings.IndexByte(right, text[i])
            eText[i] = left[index]
        } else {
            index = strings.IndexByte(left, text[i])
            eText[i] = right[index]
        }
        if i == len - 1 {
            break
        }

        // permute left
        for j := index; j < 26; j++ {
            temp[j - index] = left[j]
        }
        for j := 0; j < index; j++ {
            temp[26 - index + j] = left[j]
        }
        store := temp[1]
        for j := 2; j < 14; j++ {
            temp[j - 1] = temp[j]
        }
        temp[13] = store
        left = string(temp[:])

        // permute right

        for j := index; j < 26; j++ {
            temp[j - index] = right[j]
        }
        for j := 0; j < index; j++ {
            temp[26 - index + j] = right[j]
        }
        store = temp[0]
        for j := 1; j < 26; j++ {
            temp[j - 1] = temp[j]
        }
        temp[25] = store
        store = temp[2]
        for j := 3; j < 14; j++ {
            temp[j - 1] = temp[j]
        }
        temp[13] = store
        right = string(temp[:])
    }

    return string(eText[:])
}

func main() {
    plainText := "WELLDONEISBETTERTHANWELLSAID"
    fmt.Println("The original plaintext is :", plainText)
    fmt.Print("\nThe left and right alphabets after each permutation ")
    fmt.Println("during encryption are :\n")
    cipherText := Chao(plainText, Encrypt, true)
    fmt.Println("\nThe ciphertext is :",  cipherText)
    plainText2 := Chao(cipherText, Decrypt, false)
    fmt.Println("\nThe recovered plaintext is :", plainText2)
}
