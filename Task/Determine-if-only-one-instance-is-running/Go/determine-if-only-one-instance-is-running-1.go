package main

import (
    "fmt"
    "net"
    "time"
)

const lNet = "tcp"
const lAddr = ":12345"

func main() {
    if _, err := net.Listen(lNet, lAddr); err != nil {
        fmt.Println("an instance was already running")
        return
    }
    fmt.Println("single instance started")
    time.Sleep(10 * time.Second)
}
