package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "strings"
    "unicode/utf8"
)

func isVowel(c rune) bool { return strings.ContainsRune("aeiou", c) }

func main() {
    wordList := "unixdict.txt"
    b, err := ioutil.ReadFile(wordList)
    if err != nil {
        log.Fatal("Error reading file")
    }
    bwords := bytes.Fields(b)
    var words []string
    for _, bword := range bwords {
        s := string(bword)
        if utf8.RuneCountInString(s) > 9 {
            words = append(words, s)
        }
    }
    count := 0
    fmt.Println("Words with alternate consonants and vowels in", wordList, "\b:\n")
    for _, word := range words {
        found := true
        for i, c := range word {
            if (i%2 == 0 && isVowel(c)) || (i%2 == 1 && !isVowel(c)) {
                found = false
                break
            }
        }
        if !found {
            found = true
            for i, c := range word {
                if (i%2 == 0 && !isVowel(c)) || (i%2 == 1 && isVowel(c)) {
                    found = false
                    break
                }
            }
        }
        if found {
            count++
            fmt.Printf("%2d: %s\n", count, word)
        }
    }
}
