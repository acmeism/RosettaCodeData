package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

func main() {
    f, err := os.Open("data.txt")
    if err != nil {
        fmt.Println("Unable to open the file")
        return
    }
    defer f.Close()
    fmt.Println("Those earthquakes with a magnitude > 6.0 are:\n")
    input := bufio.NewScanner(f)
    for input.Scan() {
        line := input.Text()
        fields := strings.Fields(line)
        mag, err := strconv.ParseFloat(fields[2], 64)
        if err != nil {
            fmt.Println("Unable to parse magnitude of an earthquake")
            return
        }
        if mag > 6.0 {
            fmt.Println(line)
        }
    }
}
