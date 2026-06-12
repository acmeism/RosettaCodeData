package main

import (
    "fmt"
    "os/exec"
)

func main() {
    synthType := "sine"
    duration := "5"
    frequency := "440"
    cmd := exec.Command("play", "-n", "synth", duration, synthType, frequency)
    err := cmd.Run()
    if err != nil {
        fmt.Println(err)
    }
}
