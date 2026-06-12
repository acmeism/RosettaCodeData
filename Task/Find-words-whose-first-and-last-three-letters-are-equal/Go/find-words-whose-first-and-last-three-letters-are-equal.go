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
    count := 0
    for _, bword := range bwords {
        s := string(bword)
        if utf8.RuneCountInString(s) > 5 && (s[0:3] == s[len(s)-3:]) {
            count++
            fmt.Printf("%d: %s\n", count, s)
        }
    }
}
