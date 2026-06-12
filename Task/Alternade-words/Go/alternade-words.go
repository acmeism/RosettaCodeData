package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "unicode/utf8"
)

func main() {
    b, err := ioutil.ReadFile("unixdict.txt")
    if err != nil {
        log.Fatal("Error reading file")
    }
    bwords := bytes.Fields(b)
    dict := make(map[string]bool, len(bwords))
    words := make([]string, len(bwords))
    for i, bword := range bwords {
        word := string(bword)
        dict[word] = true
        words[i] = word
    }
    fmt.Println("'unixdict.txt' contains the following alternades of length 6 or more:\n")
    count := 0
    for _, word := range words {
        if utf8.RuneCountInString(word) < 6 {
            continue
        }
        var w1 = ""
        var w2 = ""
        for i, c := range word {
            if i%2 == 0 {
                w1 += string(c)
            } else {
                w2 += string(c)
            }
        }
        _, ok1 := dict[w1]
        _, ok2 := dict[w2]
        if ok1 && ok2 {
            count++
            fmt.Printf("%2d: %-8s -> %-4s %-4s\n", count, word, w1, w2)
        }
    }
}
