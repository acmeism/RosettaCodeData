package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    rand.Seed(time.Now().UnixNano())
    totalSecs := 0
    totalSteps := 0
    fmt.Println("Seconds    steps behind    steps ahead")
    fmt.Println("-------    ------------    -----------")
    for trial := 1; trial < 10000; trial++ {
        sbeh := 0
        slen := 100
        secs := 0
        for sbeh < slen {
            sbeh++
            for wiz := 1; wiz < 6; wiz++ {
                if rand.Intn(slen) < sbeh {
                    sbeh++
                }
                slen++
            }
            secs++
            if trial == 1 && secs > 599 && secs < 610 {
                fmt.Printf("%d        %d            %d\n", secs, sbeh, slen-sbeh)
            }
        }
        totalSecs += secs
        totalSteps += slen
    }
    fmt.Println("\nAverage secs taken:", float64(totalSecs)/10000)
    fmt.Println("Average final length of staircase:", float64(totalSteps)/10000)
}
