package main

import (
    "fmt"
    "os"
    "os/exec"
)

func main() {
    color(red)
    fmt.Println("Red")
    color(green)
    fmt.Println("Green")
    color(blue)
    fmt.Println("Blue")
}

const (
    blue  = "1"
    green = "2"
    red   = "4"
)

func color(c string) {
    cmd := exec.Command("tput", "setf", c)
    cmd.Stdout = os.Stdout
    cmd.Run()
}
