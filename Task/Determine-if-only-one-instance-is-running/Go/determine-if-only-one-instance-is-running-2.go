package main

import (
    "fmt"
    "os"
    "time"
)

// The path to the lock file should be an absolute path starting from the root.
// (If you wish to prevent the same program running in different directories,
// that is.)
const lfn = "/tmp/rclock"

func main() {
    lf, err := os.OpenFile(lfn, os.O_RDWR|os.O_CREATE|os.O_EXCL, 0666)
    if err != nil {
        fmt.Println("an instance is already running")
        return
    }
    lf.Close()
    fmt.Println("single instance started")
    time.Sleep(10 * time.Second)
    os.Remove(lfn)
}
