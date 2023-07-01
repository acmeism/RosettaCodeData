package main

import (
    "log"
    "math/rand"
    "sync"
    "time"
)

var (
    instance string
    once     sync.Once // initialize instance with once.Do
)

func claim(color string, w *sync.WaitGroup) {
    time.Sleep(time.Duration(rand.Intn(1e8))) // hesitate up to .1 sec
    log.Println("trying to claim", color)
    once.Do(func() { instance = color })
    log.Printf("tried %s. instance: %s", color, instance)
    w.Done()
}

func main() {
    rand.Seed(time.Now().Unix())
    var w sync.WaitGroup
    w.Add(2)
    go claim("red", &w) // these two attempts run concurrently
    go claim("blue", &w)
    w.Wait()
    log.Println("after trying both, instance =", instance)
}
