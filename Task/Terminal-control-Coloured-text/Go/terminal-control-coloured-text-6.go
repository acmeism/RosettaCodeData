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
    // determine color support
    if !gc.HasColors() {
        log.Fatal("no color support")
    }
    // set background color
    gc.StartColor()
    gc.InitPair(1, gc.C_WHITE, gc.C_BLUE)
    s.ColorOn(1)
    s.SetBackground(gc.Char(' ') | gc.ColorPair(1))
    // blinking, different background color
    s.AttrOn(gc.A_BLINK)
    gc.InitPair(2, gc.C_WHITE, gc.C_RED)
    s.ColorOn(2)
    s.Print("   Blinking Red   ")
    s.GetChar()
}
