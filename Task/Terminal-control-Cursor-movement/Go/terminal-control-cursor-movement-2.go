package main

import (
    "fmt"
    "time"
)

func main() {
    fmt.Print("\033[2J\033[6;3H") // clear screen, move to an initial position
    time.Sleep(1 * time.Second)   // pause to let cursor blink
    fmt.Print("\033[D") // left
    time.Sleep(1 * time.Second)
    fmt.Print("\033[C") // right
    time.Sleep(1 * time.Second)
    fmt.Print("\033[A") // up
    time.Sleep(1 * time.Second)
    fmt.Print("\033[B") // down
    time.Sleep(1 * time.Second)
    fmt.Print("\033[;H") // top left
    time.Sleep(1 * time.Second)
}
