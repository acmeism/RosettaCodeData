package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "strings"
)

func isPrime(n int) bool {
    if n < 2 {
        return false
    }
    if n%2 == 0 {
        return n == 2
    }
    if n%3 == 0 {
        return n == 3
    }
    d := 5
    for d*d <= n {
        if n%d == 0 {
            return false
        }
        d += 2
        if n%d == 0 {
            return false
        }
        d += 4
    }
    return true
}

func main() {
    // cache prime runes with codepoints between 33 and 255 say
    var primeRunes []rune
    for i := 33; i < 256; i += 2 {
        if isPrime(i) {
            primeRunes = append(primeRunes, rune(i))
        }
    }
    primeString := string(primeRunes)
    wordList := "unixdict.txt"
    b, err := ioutil.ReadFile(wordList)
    if err != nil {
        log.Fatal("Error reading file")
    }
    bwords := bytes.Fields(b)
    fmt.Println("Prime words in", wordList, "are:")
    for _, bword := range bwords {
        word := string(bword)
        ok := true
        for _, c := range word {
            if !strings.ContainsRune(primeString, c) {
                ok = false
                break
            }
        }
        if ok {
            fmt.Println(word)
        }
    }
}
