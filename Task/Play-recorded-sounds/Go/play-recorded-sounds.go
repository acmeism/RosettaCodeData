package main

import (
    "log"
    "os"
    "os/exec"
)

func main() {
    args := []string{
        "-m", "-v", "0.75", "a.wav", "-v", "0.25", "b.wav",
        "-d",
        "trim", "4", "6",
        "repeat", "5",
    }
    cmd := exec.Command("sox", args...)
    cmd.Stdout = os.Stdout
    cmd.Stderr = os.Stderr
    if err := cmd.Run(); err != nil {
        log.Fatal(err)
    }
}
