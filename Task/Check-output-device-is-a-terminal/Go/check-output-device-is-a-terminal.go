package main

import (
    "os"
    "fmt"
)

func main() {
    if fileInfo, _ := os.Stdout.Stat(); (fileInfo.Mode() & os.ModeCharDevice) != 0 {
        fmt.Println("Hello terminal")
    } else {
        fmt.Println("Who are you? You're not a terminal")
    }
}
