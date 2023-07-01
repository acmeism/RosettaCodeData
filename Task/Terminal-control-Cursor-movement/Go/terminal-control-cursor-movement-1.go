package main

import (
    "fmt"
    "time"
    "os"
    "os/exec"
    "strconv"
)

func main() {
    tput("clear") // clear screen
    tput("cup", "6", "3") // an initial position
    time.Sleep(1 * time.Second)
    tput("cub1") // left
    time.Sleep(1 * time.Second)
    tput("cuf1") // right
    time.Sleep(1 * time.Second)
    tput("cuu1") // up
    time.Sleep(1 * time.Second)
    // cud1 seems broken for me.  cud 1 works fine though.
    tput("cud", "1") // down
    time.Sleep(1 * time.Second)
    tput("cr") // begining of line
    time.Sleep(1 * time.Second)
    // get screen size here
    var h, w int
    cmd := exec.Command("stty", "size")
    cmd.Stdin = os.Stdin
    d, _ := cmd.Output()
    fmt.Sscan(string(d), &h, &w)
    // end of line
    tput("hpa", strconv.Itoa(w-1))
    time.Sleep(2 * time.Second)
    // top left
    tput("home")
    time.Sleep(2 * time.Second)
    // bottom right
    tput("cup", strconv.Itoa(h-1), strconv.Itoa(w-1))
    time.Sleep(3 * time.Second)
}

func tput(args ...string) error {
    cmd := exec.Command("tput", args...)
    cmd.Stdout = os.Stdout
    return cmd.Run()
}
