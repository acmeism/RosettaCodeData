package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

func getNumInput() float64 {
    reader := bufio.NewReader(os.Stdin)
    s, err := reader.ReadString('\n')

    if err != nil {
        panic(err)
    }

    s = strings.TrimSpace(s)

    f64, err := strconv.ParseFloat(s, 64)

    if err != nil {
        panic(err)
    }

    return f64
}

func main() {
    fmt.Print("Enter your number: ")
    n := getNumInput()
    iterCount := 0

    for {
        tmp := (n + 3) * 0.86
        iterCount += 1
        if tmp == n {
            fmt.Println(iterCount, "iterations until convergence")
            break
        }
        n = tmp
    }
}
