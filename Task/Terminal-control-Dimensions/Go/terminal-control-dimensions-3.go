package main

import (
    "fmt"
    "log"

    "code.google.com/p/goncurses"
)

func main() {
    s, err := goncurses.Init()
    if err != nil {
        log.Fatal("init:", err)
    }
    defer goncurses.End()
    height, width := s.MaxYX()
    fmt.Println(height, width)
}
