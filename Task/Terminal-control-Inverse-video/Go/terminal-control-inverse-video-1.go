package main

import (
    "fmt"
    "os"
    "os/exec"
)

func main() {
    tput("rev")
    fmt.Print("Rosetta")
    tput("sgr0")
    fmt.Println(" Code")
}

func tput(arg string) error {
    cmd := exec.Command("tput", arg)
    cmd.Stdout = os.Stdout
    return cmd.Run()
}
