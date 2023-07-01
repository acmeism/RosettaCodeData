package main

import (
    "log"
    "time"

    gc "code.google.com/p/goncurses"
)

func main() {
    s, err := gc.Init()
    if err != nil {
        log.Fatal("init:", err)
    }
    defer gc.End()
    gc.Cursor(0)
    time.Sleep(3 * time.Second)
    gc.Cursor(1)
    s.GetChar()
}
