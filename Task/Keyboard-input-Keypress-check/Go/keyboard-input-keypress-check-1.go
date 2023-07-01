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
    s.Move(20, 0)
    s.Print("Key check in ")
    for i := 3; i >= 1; i-- {
        s.MovePrint(20, 13, i)
        s.Refresh()
        time.Sleep(500 * time.Millisecond)
    }
