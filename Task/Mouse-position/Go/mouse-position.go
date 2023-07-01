package main

import (
    "fmt"
    "github.com/go-vgo/robotgo"
)

func isInside(x, y, w, h, mx, my int) bool {
    rx := x + w - 1
    ry := y + h - 1
    return mx >= x && mx <= rx && my >= y && my <= ry
}

func main() {
    name := "gedit" // say
    fpid, err := robotgo.FindIds(name)
    if err == nil && len(fpid) > 0 {
        pid := fpid[0]
        robotgo.ActivePID(pid) // make gedit active window
        x, y, w, h := robotgo.GetBounds(pid)
        fmt.Printf("The active window's top left corner is at (%d, %d)\n", x, y)
        fmt.Printf("Its width is %d and its height is %d\n", w, h)
        mx, my := robotgo.GetMousePos()
        fmt.Printf("The screen location of the mouse cursor is (%d, %d)\n", mx, my)
        if !isInside(x, y, w, h, mx, my) {
            fmt.Println("The mouse cursor is outside the active window")
        } else {
            wx := mx - x
            wy := my - y
            fmt.Printf("The window location of the mouse cursor is (%d, %d)\n", wx, wy)
        }
    } else {
        fmt.Println("Problem when finding PID(s) of", name)
    }
}
