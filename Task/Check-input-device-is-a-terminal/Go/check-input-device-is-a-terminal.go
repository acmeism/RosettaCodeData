package main

import (
    "golang.org/x/crypto/ssh/terminal"
    "fmt"
    "os"
)

func main() {
    if terminal.IsTerminal(int(os.Stdin.Fd())) {
        fmt.Println("Hello terminal")
    } else {
        fmt.Println("Who are you?  You're not a terminal.")
    }
}
