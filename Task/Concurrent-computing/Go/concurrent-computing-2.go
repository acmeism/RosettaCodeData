package main

import (
    "log"
    "math/rand"
    "os"
    "sync"
    "time"
)

func main() {
    words := []string{"Enjoy", "Rosetta", "Code"}
    rand.Seed(time.Now().UnixNano())
    l := log.New(os.Stdout, "", 0)
    var q sync.WaitGroup
    q.Add(len(words))
    for _, w := range words {
        w := w
        time.AfterFunc(time.Duration(rand.Int63n(1e9)), func() {
            l.Println(w)
            q.Done()
        })
    }
    q.Wait()
}
