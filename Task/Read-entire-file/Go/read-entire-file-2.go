// +build !windows,!plan9,!nacl // These lack syscall.Mmap

package main

import (
    "fmt"
    "log"
    "os"
    "syscall"
)

func main() {
    f, err := os.Open("file")
    if err != nil {
        log.Fatal(err)
    }
    fi, err := f.Stat()
    if err != nil {
        log.Fatal(err)
    }
    data, err := syscall.Mmap(int(f.Fd()), 0, int(fi.Size()),
        syscall.PROT_READ, syscall.MAP_PRIVATE)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Println(string(data))
}
