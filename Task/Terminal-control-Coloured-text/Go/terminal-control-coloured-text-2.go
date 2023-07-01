package main

import (
    "fmt"
    "log"
    "os"
    "os/exec"
)

func main() {
    // set background color to blue, log error message if impossible.
    if err := tput("setb", blue); err != nil {
        log.Fatal("no color capability")
    }
    // clearing the screen will fill screen with background color
    // on most terminals.
    tput("clear")

    tput("blink")     // set blink attribute
    tput("setb", red) // new background color
    fmt.Println("  Blinking Red  ")
    tput("sgr0") // clear blink (and all other attributes)
}

const (
    blue  = "1"
    green = "2"
    red   = "4"
)

func tput(args ...string) error {
    cmd := exec.Command("tput", args...)
    cmd.Stdout = os.Stdout
    return cmd.Run()
}
