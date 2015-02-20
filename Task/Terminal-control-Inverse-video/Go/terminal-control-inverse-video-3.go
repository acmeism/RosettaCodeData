package main

import (
    "log"

    gc "code.google.com/p/goncurses"
)

func main() {
    s, err := gc.Init()
    if err != nil {
        log.Fatal("init:", err)
    }
    defer gc.End()
    s.AttrOn(gc.A_REVERSE)
    s.Print("Rosetta")
    s.AttrOff(gc.A_REVERSE)
    s.Println(" Code")
    s.GetChar()
}
