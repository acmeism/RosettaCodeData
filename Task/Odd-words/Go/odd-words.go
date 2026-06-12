package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "sort"
    "strings"
)

func main() {
    wordList := "unixdict.txt"
    b, err := ioutil.ReadFile(wordList)
    if err != nil {
        log.Fatal("Error reading file")
    }
    bwords := bytes.Fields(b)
    words := make([]string, len(bwords))
    for i, bword := range bwords {
        words[i] = string(bword)
    }
    count := 0
    fmt.Println("The odd words with length > 4 in", wordList, "are:")
    for _, word := range words {
        rword := []rune(word) // in case any non-ASCII
        if len(rword) > 8 {
            var sb strings.Builder
            for i := 0; i < len(rword); i += 2 {
                sb.WriteRune(rword[i])
            }
            s := sb.String()
            idx := sort.SearchStrings(words, s)      // binary search
            if idx < len(words) && words[idx] == s { // check not just an insertion point
                count = count + 1
                fmt.Printf("%2d: %-12s -> %s\n", count, word, s)
            }
        }
    }
}
