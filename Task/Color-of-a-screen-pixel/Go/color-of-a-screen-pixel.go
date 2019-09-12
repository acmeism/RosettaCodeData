package main

import (
    "fmt"
    "github.com/go-vgo/robotgo"
)

func main() {
    // get position of mouse cursor
    x, y := robotgo.GetMousePos()

    // get color of pixel at that position
    color := robotgo.GetPixelColor(x, y)
    fmt.Printf("Color of pixel at (%d, %d) is 0x%s\n", x, y, color)
}
