package main

import (
    "bufio"
    "fmt"
    "math"
    "os"
    "strconv"
    "strings"
)

func getnum(prompt string) (r float64) {
    in := bufio.NewReader(os.Stdin)
    for {
        fmt.Print(prompt)
        s, err := in.ReadString('\n')
        if err != nil {
            fmt.Println(err)
            os.Exit(-1)
        }
        r, err = strconv.ParseFloat(strings.TrimSpace(s), 64)
        if err == nil {
            break
        }
        fmt.Println(err)
    }
    return
}

func main() {
    lat := getnum("Enter latitude       => ")
    lng := getnum("Enter longitude      => ")
    ref := getnum("Enter legal meridian => ")
    slat := math.Sin(lat * math.Pi / 180)
    diff := lng - ref
    fmt.Println("\n    sine of latitude:   ", slat)
    fmt.Println("    diff longitude:     ", diff)
    fmt.Println("\nHour, sun hour angle, dial hour line angle from 6am to 6pm")
    for h := -6.; h <= 6; h++ {
        hra := 15*h - diff
        hla := math.Atan(slat*math.Tan(hra*math.Pi/180)) * 180 / math.Pi
        fmt.Printf("%2.0f %8.3f %8.3f\n", h, hra, hla)
    }
}
