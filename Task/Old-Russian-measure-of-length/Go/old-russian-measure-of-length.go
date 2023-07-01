package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

func main() {
    units := []string{
        "tochka", "liniya", "dyuim", "vershok", "piad", "fut",
        "arshin", "sazhen", "versta", "milia",
        "centimeter", "meter", "kilometer",
    }

    convs := []float32{
        0.0254, 0.254, 2.54, 4.445, 17.78, 30.48,
        71.12, 213.36, 10668, 74676,
        1, 100, 10000,
    }

    scanner := bufio.NewScanner(os.Stdin)
    for {
        for i, u := range units {
            fmt.Printf("%2d %s\n", i+1, u)
        }
        fmt.Println()
        var unit int
        var err error
        for {
            fmt.Print("Please choose a unit 1 to 13 : ")
            scanner.Scan()
            unit, err = strconv.Atoi(scanner.Text())
            if err == nil && unit >= 1 && unit <= 13 {
                break
            }
        }
        unit--
        var value float64
        for {
            fmt.Print("Now enter a value in that unit : ")
            scanner.Scan()
            value, err = strconv.ParseFloat(scanner.Text(), 32)
            if err == nil && value >= 0 {
                break
            }
        }
        fmt.Println("\nThe equivalent in the remaining units is:\n")
        for i, u := range units {
            if i == unit {
                continue
            }
            fmt.Printf(" %10s : %g\n", u, float32(value)*convs[unit]/convs[i])
        }
        fmt.Println()
        yn := ""
        for yn != "y" && yn != "n" {
            fmt.Print("Do another one y/n : ")
            scanner.Scan()
            yn = strings.ToLower(scanner.Text())
        }
        if yn == "n" {
            return
        }
    }
}
