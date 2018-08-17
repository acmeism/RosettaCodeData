package main

import (
    "fmt"
    "time"
)

func main() {
    fmt.Print("\033[?1049h\033[H")
    fmt.Println("Alternate screen buffer\n")
    s := "s"
    for i := 5; i > 0; i-- {
        if i == 1 {
            s = ""
        }
        fmt.Printf("\rgoing back in %d second%s...", i, s)
        time.Sleep(time.Second)
    }
    fmt.Print("\033[?1049l")
}
