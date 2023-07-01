package main

import (
    "code.google.com/p/x-go-binding/ui"
    "code.google.com/p/x-go-binding/ui/x11"
    "log"
)

func main() {
    win, err := x11.NewWindow()
    if err != nil {
        log.Fatalf("Error: %v\n", err)
    }
    defer win.Close()

    for ev := range win.EventChan() {
        switch e := ev.(type) {
        case ui.ErrEvent:
            log.Fatalf("Error: %v\n", e.Err)
        }
    }
}
