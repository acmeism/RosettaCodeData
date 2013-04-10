package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    words := []string{"Enjoy", "Rosetta", "Code"}
    rand.Seed(time.Now().UnixNano())
    q := make(chan string)
    for _, w := range words {
        go func(w string) {
            time.Sleep(time.Duration(rand.Int63n(1e9)))
            q <- w
        }(w)
    }
    for i := 0; i < len(words); i++ {
        fmt.Println(<-q)
    }
}
