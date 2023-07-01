package main

import (
    "fmt"
    "time"
)

func main() {
    a := `|/-\`
    fmt.Printf("\033[?25l")  // hide the cursor
    start := time.Now()
    for {
        for i := 0; i < 4; i++ {
            fmt.Print("\033[2J")       // clear terminal
            fmt.Printf("\033[0;0H")    // place cursor at top left corner
            for j := 0; j < 80; j++ {  // 80 character terminal width, say
                fmt.Printf("%c", a[i])
            }
            time.Sleep(250 * time.Millisecond)
        }
        if time.Since(start).Seconds() >= 20.0 { // stop after 20 seconds, say
            break
        }
    }
    fmt.Print("\033[?25h") // restore the cursor
}
