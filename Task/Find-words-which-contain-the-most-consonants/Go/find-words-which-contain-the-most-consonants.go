package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
    "unicode/utf8"
)

func contains(list []int, value int) bool {
    for _, v := range list {
        if v == value {
            return true
        }
    }
    return false
}

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
        if utf8.RuneCountInString(s) > 10 {
            words = append(words, s)
        }
    }
    vowelIndices := []int{0, 4, 8, 14, 20}
    wordGroups := make([][]string, 12)
    for _, word := range words {
        letters := make([]int, 26)
        for _, c := range word {
            index := c - 97
            if index >= 0 && index < 26 {
                letters[index]++
            }
        }
        eligible := true
        uc := 0 // number of unique consonants
        for i := 0; i < 26; i++ {
            if !contains(vowelIndices, i) {
                if letters[i] > 1 {
                    eligible = false
                    break
                } else if letters[i] == 1 {
                    uc++
                }
            }
        }
        if eligible {
            wordGroups[uc] = append(wordGroups[uc], word)
        }
    }

    for i := 11; i >= 0; i-- {
        count := len(wordGroups[i])
        if count > 0 {
            s := "s"
            if count == 1 {
                s = ""
            }
            fmt.Printf("%d word%s found with %d unique consonants:\n", count, s, i)
            for j := 0; j < count; j++ {
                fmt.Printf("%-15s", wordGroups[i][j])
                if j > 0 && (j+1)%5 == 0 {
                    fmt.Println()
                }
            }
            fmt.Println()
            if count%5 != 0 {
                fmt.Println()
            }
        }
    }
}
