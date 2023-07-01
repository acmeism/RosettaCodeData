package main

import (
    "fmt"
    "time"
)

func main() {
    centuries := []string{"20th", "21st", "22nd"}
    starts := []int{1900, 2000, 2100}
    for i := 0; i < len(centuries); i++ {
        var longYears []int
        fmt.Printf("\nLong years in the %s century:\n", centuries[i])
        for j := starts[i]; j < starts[i] + 100; j++ {
            t := time.Date(j, time.December, 28, 0, 0, 0, 0, time.UTC)
            if _, week := t.ISOWeek(); week == 53 {
                longYears = append(longYears, j)
            }
        }
        fmt.Println(longYears)
    }
}
