package main

import (
    "fmt"
    "math/rand"
    "time"
)

// Uses 0-based numbering rather than 1-based numbering throughout.
func doTrials(trials, np int, strategy string) {
    pardoned := 0
trial:
    for t := 0; t < trials; t++ {
        var drawers [100]int
        for i := 0; i < 100; i++ {
            drawers[i] = i
        }
        rand.Shuffle(100, func(i, j int) {
            drawers[i], drawers[j] = drawers[j], drawers[i]
        })
    prisoner:
        for p := 0; p < np; p++ {
            if strategy == "optimal" {
                prev := p
                for d := 0; d < 50; d++ {
                    this := drawers[prev]
                    if this == p {
                        continue prisoner
                    }
                    prev = this
                }
            } else {
                // Assumes a prisoner remembers previous drawers (s)he opened
                // and chooses at random from the others.
                var opened [100]bool
                for d := 0; d < 50; d++ {
                    var n int
                    for {
                        n = rand.Intn(100)
                        if !opened[n] {
                            opened[n] = true
                            break
                        }
                    }
                    if drawers[n] == p {
                        continue prisoner
                    }
                }
            }
            continue trial
        }
        pardoned++
    }
    rf := float64(pardoned) / float64(trials) * 100
    fmt.Printf("  strategy = %-7s  pardoned = %-6d relative frequency = %5.2f%%\n\n", strategy, pardoned, rf)
}

func main() {
    rand.Seed(time.Now().UnixNano())
    const trials = 100000
    for _, np := range []int{10, 100} {
        fmt.Printf("Results from %d trials with %d prisoners:\n\n", trials, np)
        for _, strategy := range [2]string{"random", "optimal"} {
            doTrials(trials, np, strategy)
        }
    }
}
