package main

import (
    "os"
    "os/exec"
    "time"
)

func main() {
    tput("civis") // hide
    time.Sleep(3 * time.Second)
    tput("cvvis") // show
    time.Sleep(3 * time.Second)
}

func tput(arg string) error {
    cmd := exec.Command("tput", arg)
    cmd.Stdout = os.Stdout
    return cmd.Run()
}
