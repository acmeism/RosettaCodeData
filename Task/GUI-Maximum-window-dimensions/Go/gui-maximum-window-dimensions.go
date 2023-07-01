package main

import (
    "fmt"
    "github.com/go-vgo/robotgo"
)

func main() {
    w, h := robotgo.GetScreenSize()
    fmt.Printf("Screen size: %d x %d\n", w, h)
    fpid, err := robotgo.FindIds("firefox")
    if err == nil && len(fpid) > 0 {
        pid := fpid[0]
        robotgo.ActivePID(pid)
        robotgo.MaxWindow(pid)
        _, _, w, h = robotgo.GetBounds(pid)
        fmt.Printf("Max usable : %d x %d\n", w, h)
    }
}
