package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "log"
)

func levenshtein(s, t string) int {
    d := make([][]int, len(s)+1)
    for i := range d {
        d[i] = make([]int, len(t)+1)
    }
    for i := range d {
        d[i][0] = i
    }
    for j := range d[0] {
        d[0][j] = j
    }
    for j := 1; j <= len(t); j++ {
        for i := 1; i <= len(s); i++ {
            if s[i-1] == t[j-1] {
                d[i][j] = d[i-1][j-1]
            } else {
                min := d[i-1][j]
                if d[i][j-1] < min {
                    min = d[i][j-1]
                }
                if d[i-1][j-1] < min {
                    min = d[i-1][j-1]
                }
                d[i][j] = min + 1
            }
        }

    }
    return d[len(s)][len(t)]
}

func main() {
    search := "complition"
    b, err := ioutil.ReadFile("unixdict.txt")
    if err != nil {
        log.Fatal("Error reading file")
    }
    words := bytes.Fields(b)
    var lev [4][]string
    for _, word := range words {
        s := string(word)
        ld := levenshtein(search, s)
        if ld < 4 {
            lev[ld] = append(lev[ld], s)
        }
    }
    fmt.Printf("Input word: %s\n\n", search)
    for i := 1; i < 4; i++ {
        length := float64(len(search))
        similarity := (length - float64(i)) * 100 / length
        fmt.Printf("Words which are %4.1f%% similar:\n", similarity)
        fmt.Println(lev[i])
        fmt.Println()
    }
}
