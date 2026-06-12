package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "strings"
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
outer:
    for _, bword := range bwords {
        s := string(bword)
        if utf8.RuneCountInString(s) >= 4 {
            for _, c := range s {
                if strings.ContainsRune("aiou", c) {
                    continue outer
                }
            }
            words = append(words, s)
        }
    }
    wcount := 0
    for _, word := range words {
        ecount := 0
        for _, c := range word {
            if c == 'e' {
                ecount++
            }
        }
        if ecount > 3 {
            wcount++
            fmt.Printf("%2d: %s\n", wcount, word)
        }
    }
}
