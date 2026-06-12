package main

import "fmt"

func main() {
    clrs := [7][3]int{
        {255, 0, 0},   // red
        {255, 128, 0}, // orange
        {255, 255, 0}, // yellow
        {0, 255, 0},   // green
        {0, 0, 255},   // blue
        {75, 0, 130},  // indigo
        {128, 0, 255}, // violet
    }
    s := "RAINBOW"
    for i := 0; i < 7; i++ {
        fmt.Printf("\x1B[38;2;%d;%d;%dm%c", clrs[i][0], clrs[i][1], clrs[i][2], s[i])
    }
    fmt.Println()
}
