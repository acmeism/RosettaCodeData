package main

import (
    "bufio"
    "fmt"
    "log"
    "os"
    "strings"
)

type vf = func()

var history []string

func hello() {
    fmt.Println("Hello World!")
    history = append(history, "hello")
}

func hist() {
    if len(history) == 0 {
        fmt.Println("No history")
    } else {
        for _, cmd := range history {
            fmt.Println("  -", cmd)
        }
    }
    history = append(history, "hist")
}

func help() {
    fmt.Println("Available commands:")
    fmt.Println("  hello")
    fmt.Println("  hist")
    fmt.Println("  exit")
    fmt.Println("  help")
    history = append(history, "help")
}

func main() {
    scanner := bufio.NewScanner(os.Stdin)
    vfs := map[string]vf{"help": help, "hist": hist, "hello": hello}
    fmt.Println("Enter a command, type help for a listing.")
    for {
        fmt.Print(">")
        scanner.Scan()
        if scerr := scanner.Err(); scerr != nil {
            log.Fatal(scerr)
        }
        line := strings.TrimSpace(scanner.Text())
        if line == "exit" {
            return
        }
        cmd, ok := vfs[line]
        if !ok {
            fmt.Println("Unknown command, try again")
        } else {
            cmd()
        }
    }
}
