package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "unicode/utf8"
)

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
        if utf8.RuneCountInString(s) > 10 {
            words = append(words, s)
        }
    }
    count := 0
    fmt.Println("Words which contain all 5 vowels once in", wordList, "\b:\n")
    for _, word := range words {
        ca, ce, ci, co, cu := 0, 0, 0, 0, 0
        for _, r := range word {
            switch r {
            case 'a':
                ca++
            case 'e':
                ce++
            case 'i':
                ci++
            case 'o':
                co++
            case 'u':
                cu++
            }
        }
        if ca == 1 && ce == 1 && ci == 1 && co == 1 && cu == 1 {
            count++
            fmt.Printf("%2d: %s\n", count, word)
        }
    }
}
