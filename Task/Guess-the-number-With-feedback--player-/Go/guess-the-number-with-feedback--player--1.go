package main

import (
    "fmt"
    "sort"
)

func main() {
    lower, upper := 0, 100
    fmt.Printf(`Instructions:
Think of integer number from %d (inclusive) to %d (exclusive) and
I will guess it. After each guess, I will ask you if it is less than
or equal to some number, and you will respond with "yes" or "no".
`, lower, upper)
    answer := sort.Search(upper-lower, func (i int) bool {
        fmt.Printf("Is your number less than or equal to %d? ", lower+i)
        s := ""
        fmt.Scanf("%s", &s)
        return s != "" && s[0] == 'y'
    })
    fmt.Printf("Your number is %d.\n", lower+answer)
}
