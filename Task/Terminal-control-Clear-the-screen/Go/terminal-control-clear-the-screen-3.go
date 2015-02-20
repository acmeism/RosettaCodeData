package main

import (
    "log"
    "time"

    "code.google.com/p/goncurses"
)

func main() {
    s, err := goncurses.Init()
    if err != nil {
        log.Fatal("goncurses:", err)
    }
    defer goncurses.End()
    s.Println("Clearing screen...")
    s.Refresh()
    time.Sleep(1 * time.Second)

    s.Clear() // clear screen

    // Goncurses saves the screen on Init and restores it on End.  This
    // GetChar() allows you to see the effect of the program before it exits.
    s.GetChar() // press any key to continue
}
