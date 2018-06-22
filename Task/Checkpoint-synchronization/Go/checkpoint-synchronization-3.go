package main

import (
    "log"
    "math/rand"
    "strings"
    "sync"
    "time"
)

func worker(part string, completed chan string) {
    log.Println(part, "worker running")
    for {
        select {
        case <-start:
            log.Println(part, "worker begins part")
            time.Sleep(time.Duration(rand.Int63n(1e6)))
            p := strings.ToLower(part)
            log.Println(part, "worker completed", p)
            completed <- p
            <-reset
            wg.Done()
        case <-done:
            log.Println(part, "worker stopped")
            wg.Done()
            return
        }
    }
}

var (
    partList    = []string{"A", "B", "C", "D"}
    nAssemblies = 3
    start       = make(chan int)
    done        = make(chan int)
    reset       chan int
    wg          sync.WaitGroup
)

func main() {
    rand.Seed(time.Now().UnixNano())
    completed := make([]chan string, len(partList))
    for i, part := range partList {
        completed[i] = make(chan string)
        go worker(part, completed[i])
    }
    for c := 1; c <= nAssemblies; c++ {
        log.Println("begin assembly cycle", c)
        reset = make(chan int)
        close(start)
        a := ""
        for _, c := range completed {
            a += <-c
        }
        log.Println(a, "assembled.  cycle", c, "complete")
        wg.Add(len(partList))
        start = make(chan int)
        close(reset)
        wg.Wait()
    }
    wg.Add(len(partList))
    close(done)
    wg.Wait()
}
