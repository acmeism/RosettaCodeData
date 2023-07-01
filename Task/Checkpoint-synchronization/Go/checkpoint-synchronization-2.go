package main

import (
    "log"
    "math/rand"
    "strings"
    "time"
)

func worker(part string, completed chan string) {
    log.Println(part, "worker begins part")
    time.Sleep(time.Duration(rand.Int63n(1e6)))
    p := strings.ToLower(part)
    log.Println(part, "worker completed", p)
    completed <- p
}

var (
    partList    = []string{"A", "B", "C", "D"}
    nAssemblies = 3
)

func main() {
    rand.Seed(time.Now().UnixNano())
    completed := make([]chan string, len(partList))
    for i := range completed {
        completed[i] = make(chan string)
    }
    for c := 1; c <= nAssemblies; c++ {
        log.Println("begin assembly cycle", c)
        for i, part := range partList {
            go worker(part, completed[i])
        }
        a := ""
        for _, c := range completed {
            a += <-c
        }
        log.Println(a, "assembled.  cycle", c, "complete")
    }
}
