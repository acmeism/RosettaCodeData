package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "sort"
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
    for _, bword := range bwords {
        s := string(bword)
        if utf8.RuneCountInString(s) > 5 {
            words = append(words, s)
        }
    }
    count := 0
    le := len(words)
    for _, word := range words {
        if strings.ContainsRune(word, 'e') {
            repl := strings.ReplaceAll(word, "e", "i")
            ix := sort.SearchStrings(words, repl) // binary search
            if ix < le && words[ix] == repl {
                count++
                fmt.Printf("%2d: %-9s -> %s\n", count, word, repl)
            }
        }
    }
}
