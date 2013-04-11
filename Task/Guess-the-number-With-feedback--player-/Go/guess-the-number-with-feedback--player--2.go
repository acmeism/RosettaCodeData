package main

import (
    "bufio"
    "fmt"
    "os"
)

func main() {
    lower, upper := 1, 100
    fmt.Printf(`Instructions:
Think of integer number from %d (inclusive) to %d (inclusive) and I will guess it.
After each guess, you respond with l,h,or c depending on
if my guess was too low, too high, or correct.
Press enter when you are thinking of a number. `, lower, upper)
    in := bufio.NewReader(os.Stdin)
    in.ReadString('\n')
    for {
        guess := (upper+lower)/2
        fmt.Printf("My guess: %d (l/h/c) ", guess)
        s, err := in.ReadString('\n')
        if err != nil {
            fmt.Println("\nSo, bye.")
            return
        }
        switch s {
        case "l\n":
            lower = guess + 1
        case "h\n":
            upper = guess - 1
        case "c\n":
            fmt.Println("I did it. :)")
            return
        default:
            fmt.Println("Please respond by pressing l, h, or c")
        }
    }
}
