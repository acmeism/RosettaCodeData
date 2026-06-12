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
    for _, bword := range bwords {
        s := string(bword)
        if utf8.RuneCountInString(s) > 11 {
            words = append(words, s)
        }
    }
    count := 0
    fmt.Println("Words containing 'the' having a length > 11 in", wordList, "\b:")
    for _, word := range words {
        if strings.Contains(word, "the") {
            count++
            fmt.Printf("%2d: %s\n", count, word)
        }
    }
}
