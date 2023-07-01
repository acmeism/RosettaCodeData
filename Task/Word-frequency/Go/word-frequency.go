package main

import (
    "fmt"
    "io/ioutil"
    "log"
    "regexp"
    "sort"
    "strings"
)

type keyval struct {
    key string
    val int
}

func main() {
    reg := regexp.MustCompile(`\p{Ll}+`)
    bs, err := ioutil.ReadFile("135-0.txt")
    if err != nil {
        log.Fatal(err)
    }
    text := strings.ToLower(string(bs))
    matches := reg.FindAllString(text, -1)
    groups := make(map[string]int)
    for _, match := range matches {
        groups[match]++
    }
    var keyvals []keyval
    for k, v := range groups {
        keyvals = append(keyvals, keyval{k, v})
    }
    sort.Slice(keyvals, func(i, j int) bool {
        return keyvals[i].val > keyvals[j].val
    })
    fmt.Println("Rank  Word  Frequency")
    fmt.Println("====  ====  =========")
    for rank := 1; rank <= 10; rank++ {
        word := keyvals[rank-1].key
        freq := keyvals[rank-1].val
        fmt.Printf("%2d    %-4s    %5d\n", rank, word, freq)
    }
}
