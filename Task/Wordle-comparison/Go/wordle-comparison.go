package main

import (
    "bytes"
    "fmt"
    "log"
)

func wordle(answer, guess string) []int {
    n := len(guess)
    if n != len(answer) {
        log.Fatal("The words must be of the same length.")
    }
    answerBytes := []byte(answer)
    result := make([]int, n) // all zero by default
    for i := 0; i < n; i++ {
        if guess[i] == answerBytes[i] {
            answerBytes[i] = '\000'
            result[i] = 2
        }
    }
    for i := 0; i < n; i++ {
        ix := bytes.IndexByte(answerBytes, guess[i])
        if ix >= 0 {
            answerBytes[ix] = '\000'
            result[i] = 1
        }
    }
    return result
}

func main() {
    colors := []string{"grey", "yellow", "green"}
    pairs := [][]string{
        {"ALLOW", "LOLLY"},
        {"BULLY", "LOLLY"},
        {"ROBIN", "ALERT"},
        {"ROBIN", "SONIC"},
        {"ROBIN", "ROBIN"},
    }
    for _, pair := range pairs {
        res := wordle(pair[0], pair[1])
        res2 := make([]string, len(res))
        for i := 0; i < len(res); i++ {
            res2[i] = colors[res[i]]
        }
        fmt.Printf("%s v %s => %v => %v\n", pair[0], pair[1], res, res2)
    }
}
