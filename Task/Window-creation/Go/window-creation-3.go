package main

import (
    "code.google.com/p/x-go-binding/ui"
    "code.google.com/p/x-go-binding/ui/x11"
    "fmt"
    "os"
)

func main() {
    win, err := x11.NewWindow()
    if err != nil {
        fmt.Printf("Error: %v\n", err)
        os.Exit(1)
    }
    defer win.Close()

    evchan := win.EventChan()
    for ev := range evchan {
        switch e := ev.(type) {
        case ui.ErrEvent:
            fmt.Printf("Error: %v\n", e.Err)
            os.Exit(1)
        }
    }
}
