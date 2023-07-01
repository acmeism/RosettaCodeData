package main

import (
    "fmt"
    "sync"
    "time"
)

var value int
var m sync.Mutex
var wg sync.WaitGroup

func slowInc() {
    m.Lock()
    v := value
    time.Sleep(1e8)
    value = v+1
    m.Unlock()
    wg.Done()
}

func main() {
    wg.Add(2)
    go slowInc()
    go slowInc()
    wg.Wait()
    fmt.Println(value)
}
