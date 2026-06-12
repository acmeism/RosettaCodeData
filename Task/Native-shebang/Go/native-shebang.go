///usr/bin/env go run echo.go "$@"; exit
package main

import (
    "fmt"
    "os"
)

func main() {
    if len(os.Args) > 1 {
        fmt.Println(os.Args[1])
    }
}
