package main

import (
    "fmt"
    "golang.org/x/exp/rand"
    "time"
)

func main() {
    words := []string{"Enjoy", "Rosetta", "Code"}
    seed := uint64(time.Now().UnixNano())
    q := make(chan string)
    for i, w := range words {
        go func(w string, seed uint64) {
            r := rand.New(rand.NewSource(seed))
            time.Sleep(time.Duration(r.Int63n(1e9)))
            q <- w
        }(w, seed+uint64(i))
    }
    for i := 0; i < len(words); i++ {
        fmt.Println(<-q)
    }
}
