package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "sort"
    "strings"
)

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func readWords(fileName string) []string {
    file, err := os.Open(fileName)
    check(err)
    defer file.Close()
    var words []string
    scanner := bufio.NewScanner(file)
    for scanner.Scan() {
        word := strings.ToLower(strings.TrimSpace(scanner.Text()))
        if len(word) >= 3 {
            words = append(words, word)
        }
    }
    check(scanner.Err())
    return words
}

func rotate(runes []rune) {
    first := runes[0]
    copy(runes, runes[1:])
    runes[len(runes)-1] = first
}

func main() {
    dicts := []string{"mit_10000.txt", "unixdict.txt"} // local copies
    for _, dict := range dicts {
        fmt.Printf("Using %s:\n\n", dict)
        words := readWords(dict)
        n := len(words)
        used := make(map[string]bool)
    outer:
        for _, word := range words {
            runes := []rune(word)
            variants := []string{word}
            for i := 0; i < len(runes)-1; i++ {
                rotate(runes)
                word2 := string(runes)
                if word == word2 || used[word2] {
                    continue outer
                }
                ix := sort.SearchStrings(words, word2)
                if ix == n || words[ix] != word2 {
                    continue outer
                }
                variants = append(variants, word2)
            }
            for _, variant := range variants {
                used[variant] = true
            }
            fmt.Println(variants)
        }
        fmt.Println()
    }
}
