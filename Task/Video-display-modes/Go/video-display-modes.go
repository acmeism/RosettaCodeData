package main

import (
    "fmt"
    "log"
    "os/exec"
    "time"
)

func main() {
    // query supported display modes
    out, err := exec.Command("xrandr", "-q").Output()
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(string(out))
    time.Sleep(3 * time.Second)

    // change display mode to 1024x768 say (no text output)
    err = exec.Command("xrandr", "-s", "1024x768").Run()
    if err != nil {
        log.Fatal(err)
    }
    time.Sleep(3 * time.Second)

    // change it back again to 1366x768 (or whatever is optimal for your system)
    err = exec.Command("xrandr", "-s", "1366x768").Run()
    if err != nil {
        log.Fatal(err)
    }
}
