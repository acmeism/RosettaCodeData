package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "strings"
)

func contains(a []string, s string) bool {
    for _, e := range a {
        if e == s {
            return true
        }
    }
    return false
}

func oneAway(a, b string) bool {
    sum := 0
    for i := 0; i < len(a); i++ {
        if a[i] != b[i] {
            sum++
        }
    }
    return sum == 1
}

func wordLadder(words []string, a, b string) {
    l := len(a)
    var poss []string
    for _, word := range words {
        if len(word) == l {
            poss = append(poss, word)
        }
    }
    todo := [][]string{{a}}
    for len(todo) > 0 {
        curr := todo[0]
        todo = todo[1:]
        var next []string
        for _, word := range poss {
            if oneAway(word, curr[len(curr)-1]) {
                next = append(next, word)
            }
        }
        if contains(next, b) {
            curr = append(curr, b)
            fmt.Println(strings.Join(curr, " -> "))
            return
        }
        for i := len(poss) - 1; i >= 0; i-- {
            if contains(next, poss[i]) {
                copy(poss[i:], poss[i+1:])
                poss[len(poss)-1] = ""
                poss = poss[:len(poss)-1]
            }
        }
        for _, s := range next {
            temp := make([]string, len(curr))
            copy(temp, curr)
            temp = append(temp, s)
            todo = append(todo, temp)
        }
    }
    fmt.Println(a, "into", b, "cannot be done.")
}

func main() {
    b, err := ioutil.ReadFile("unixdict.txt")
    if err != nil {
        log.Fatal("Error reading file")
    }
    bwords := bytes.Fields(b)
    words := make([]string, len(bwords))
    for i, bword := range bwords {
        words[i] = string(bword)
    }
    pairs := [][]string{
        {"boy", "man"},
        {"girl", "lady"},
        {"john", "jane"},
        {"child", "adult"},
    }
    for _, pair := range pairs {
        wordLadder(words, pair[0], pair[1])
    }
}
