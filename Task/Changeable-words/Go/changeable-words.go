package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "unicode/utf8"
)

func hammingDist(s1, s2 string) int {
    r1 := []rune(s1) // in case there are non-ASCII characters
    r2 := []rune(s2) // ditto
    if len(r1) != len(r2) {
        return 0
    }
    count := 0
    for i := 0; i < len(r1); i++ {
        if r1[i] != r2[i] {
            count++
            if count == 2 {
                break // don't care about counts > 2
            }
        }
    }
    return count
}

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
        if utf8.RuneCountInString(s) > 11 {
            words = append(words, s)
        }
    }
    count := 0
    fmt.Println("Changeable words in", wordList, "\b:")
    for _, word1 := range words {
        for _, word2 := range words {
            if word1 != word2 && hammingDist(word1, word2) == 1 {
                count++
                fmt.Printf("%2d: %-14s -> %s\n", count, word1, word2)
            }
        }
    }
}
