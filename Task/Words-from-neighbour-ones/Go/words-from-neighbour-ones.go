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
        if utf8.RuneCountInString(s) >= 9 {
            words = append(words, s)
        }
    }
    count := 0
    var alreadyFound []string
    le := len(words)
    var sb strings.Builder
    for i := 0; i < le-9; i++ {
        sb.Reset()
        for j := i; j < i+9; j++ {
            sb.WriteByte(words[j][j-i])
        }
        word := sb.String()
        ix := sort.SearchStrings(words, word)
        if ix < le && word == words[ix] {
            ix2 := sort.SearchStrings(alreadyFound, word)
            if ix2 == len(alreadyFound) {
                count++
                fmt.Printf("%2d: %s\n", count, word)
                alreadyFound = append(alreadyFound, word)
            }
        }
    }
}
