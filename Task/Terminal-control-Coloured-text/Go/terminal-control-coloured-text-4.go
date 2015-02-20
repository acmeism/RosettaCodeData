package main

import "fmt"

func main() {
    fmt.Print("\033[44m")   // set background color
    fmt.Print("\033[2J")    // clear screen to paint new background color
    fmt.Print("\033[5;41m") // blink on, red background
    fmt.Println("   Blinking Red   ")
    fmt.Print("\033[25;40m") // blink off, black background
}
