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
    // an initial position
    s.Move(6, 3)
    s.Refresh()                 // update screen
    time.Sleep(1 * time.Second) // allow time for cursor to blink
    // left
    y, x := s.CursorYX()
    s.Move(y, x-1)
    s.Refresh()
    time.Sleep(1 * time.Second)
    // right
    y, x = s.CursorYX()
    s.Move(y, x+1)
    s.Refresh()
    time.Sleep(1 * time.Second)
    // up
    y, x = s.CursorYX()
    s.Move(y-1, x)
    s.Refresh()
    time.Sleep(1 * time.Second)
    // down
    y, x = s.CursorYX()
    s.Move(y+1, x)
    s.Refresh()
    time.Sleep(1 * time.Second)
    // beginning of line
    y, x = s.CursorYX()
    s.Move(y, 0)
    s.Refresh()
    time.Sleep(1 * time.Second)
    // get window size for moves to edges
    my, mx := s.MaxYX()
    // end of line
    y, x = s.CursorYX()
    s.Move(y, mx-1)
    s.Refresh()
    time.Sleep(2 * time.Second)
    // top left
    s.Move(0, 0)
    s.Refresh()
    time.Sleep(2 * time.Second)
    // bottom right
    s.Move(my-1, mx-1)
    s.Refresh()
    s.GetChar()
}
