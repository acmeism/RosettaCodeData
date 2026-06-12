package main

import (
    "fmt"
    "sort"
)

type wordkey struct {
    word string
    key  int
}

func sortWords(words []string, f func(s string) int) {
    var le = len(words)

    // decorate
    wordkeys := make([]wordkey, le)
    for i := 0; i < le; i++ {
        wordkeys[i] = wordkey{words[i], f(words[i])}
    }

    // sort (stable)
    sort.SliceStable(wordkeys, func(i, j int) bool {
        return wordkeys[i].key < wordkeys[j].key
    })

    // undecorate (mutates original slice)
    for i := 0; i < le; i++ {
        words[i] = "\"" + wordkeys[i].word + "\""
    }

    fmt.Println(words)
}

func main() {
    words := []string{"Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site"}
    length := func(s string) int { return len(s) }
    sortWords(words, length)
}
