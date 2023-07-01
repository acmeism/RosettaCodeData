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
    gc.StartColor()
    const (
        red   = 1
        green = 2
        blue  = 3
    )
    gc.InitPair(red, gc.C_RED, gc.C_BLACK)
    gc.InitPair(green, gc.C_GREEN, gc.C_BLACK)
    gc.InitPair(blue, gc.C_BLUE, gc.C_BLACK)
    s.ColorOn(red)
    s.Println("Red")
    s.ColorOn(green)
    s.Println("Green")
    s.ColorOn(blue)
    s.Println("Blue")
    s.GetChar()
}
