package main

import (
    "debug/elf"
    "fmt"
    "os"
)

func main() {
    f, err := elf.Open(os.Args[0])
    if err != nil {
        fmt.Println("  ", err)
        return
    }
    fmt.Println(f.FileHeader.ByteOrder)
    f.Close()
}
