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
    var k gc.Key
    for {
        gc.FlushInput()
        s.MovePrint(20, 0, "Press y/n ")
        s.Refresh()
        switch k = s.GetChar(); k {
        default:
            continue
        case 'y', 'Y', 'n', 'N':
        }
        break
    }
    s.Printf("\nThanks for the %c!\n", k)
    s.Refresh()
    s.GetChar()
}
