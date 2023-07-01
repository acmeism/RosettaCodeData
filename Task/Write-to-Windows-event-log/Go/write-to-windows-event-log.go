package main

import (
    "fmt"
    "os/exec"
)

func main() {
    command := "EventCreate"
    args := []string{"/T", "INFORMATION", "/ID", "123", "/L", "APPLICATION",
        "/SO", "Go", "/D", "\"Rosetta Code Example\""}
    cmd := exec.Command(command, args...)
    err := cmd.Run()
    if err != nil {
        fmt.Println(err)
    }
}
