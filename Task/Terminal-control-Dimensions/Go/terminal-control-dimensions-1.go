package main

import (
    "fmt"
    "os"

    "golang.org/x/crypto/ssh/terminal"
)

func main() {
    w, h, err := terminal.GetSize(int(os.Stdout.Fd()))
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(h, w)
}
