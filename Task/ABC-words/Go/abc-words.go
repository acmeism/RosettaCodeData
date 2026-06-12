package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
)

func main() {
    wordList := "unixdict.txt"
    b, err := ioutil.ReadFile(wordList)
    if err != nil {
        log.Fatal("Error reading file")
    }
    bwords := bytes.Fields(b)
    count := 0
    fmt.Println("Based on first occurrences only, the ABC words in", wordList, "are:")
    for _, bword := range bwords {
        a := bytes.IndexRune(bword, 'a')
        b := bytes.IndexRune(bword, 'b')
        c := bytes.IndexRune(bword, 'c')
        if a >= 0 && b > a && c > b {
            count++
            fmt.Printf("%2d: %s\n", count, string(bword))
        }
    }
}
