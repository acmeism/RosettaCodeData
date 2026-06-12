package main

import (
    "fmt"
    "log"
)

func minimum(a []int) int {
    min := a[0]
    for i := 1; i < len(a); i++ {
        if a[i] < min {
            min = a[i]
        }
    }
    return min
}

func sum(a []int) int {
    s := 0
    for _, i := range a {
        s = s + i
    }
    return s
}

func hourglassFlipper(hourglasses []int, target int) (int, []int) {
    flippers := make([]int, len(hourglasses))
    copy(flippers, hourglasses)
    var series []int
    for iter := 0; iter < 10000; iter++ {
        n := minimum(flippers)
        series = append(series, n)
        for i := 0; i < len(flippers); i++ {
            flippers[i] -= n
        }
        for i, flipper := range flippers {
            if flipper == 0 {
                flippers[i] = hourglasses[i]
            }
        }
        for start := len(series) - 1; start >= 0; start-- {
            if sum(series[start:]) == target {
                return start, series
            }
        }
    }
    log.Fatal("Unable to find an answer within 10,000 iterations.")
    return 0, nil
}

func main() {
    fmt.Print("Flip an hourglass every time it runs out of grains, ")
    fmt.Println("and note the interval in time.")
    hgs := [][]int{{4, 7}, {5, 7, 31}}
    ts := []int{9, 36}
    for i := 0; i < len(hgs); i++ {
        start, series := hourglassFlipper(hgs[i], ts[i])
        end := len(series) - 1
        fmt.Println("\nSeries:", series)
        fmt.Printf("Use hourglasses from indices %d to %d (inclusive) to sum ", start, end)
        fmt.Println(ts[i], "using", hgs[i])
    }
}
