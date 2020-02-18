package main

import (
    "log"

    gc "code.google.com/p/goncurses"
)

func main() {
    _, err := gc.Init()
    if err != nil {
        log.Fatal("init:", err)
    }
    defer gc.End()
    gc.FlushInput()
}
