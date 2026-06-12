package main

import (
    "fmt"
    "math"
    "math/rand"
    "time"
)

const (
    DEBUG   = 0
    DAYS    = 365
    n_sigmas = 5.
    WORKERS = 16   // concurrent worker processes
    RUNS    = 1000 // runs per flight
)

func simulate1(p, n int, r *rand.Rand) int {
    var days [DAYS]int
    for i := 0; i < p; i++ {
        days[r.Intn(DAYS)]++
    }
    for _, d := range days {
        if d >= n {
            return 1
        }
    }
    return 0
}

// send yes's per fixed number of simulate1 runs until canceled
func work(p, n int, ych chan int, cancel chan bool) {
    r := rand.New(rand.NewSource(time.Now().Unix() + rand.Int63()))
    for {
        select {
        case <-cancel:
            return
        default:
        }
        y := 0
        for i := 0; i < RUNS; i++ {
            y += simulate1(p, n, r)
        }
        ych <- y
    }
}

func prob(np, n int) (p, d float64) {
    ych := make(chan int, WORKERS)
    cancel := make(chan bool)
    for i := 0; i < WORKERS; i++ {
        go work(np, n, ych, cancel)
    }
    var runs, yes int
    for {
        yes += <-ych
        runs += RUNS
        fr := float64(runs)
        p = float64(yes) / fr
        d = math.Sqrt(p * (1 - p) / fr)
        if DEBUG > 1 {
            fmt.Println("\t\t", np, yes, runs, p, d)
        }
        // .5 here is the "even chance" threshold
        if !(math.Abs(p-.5) < n_sigmas*d) {
            close(cancel)
            break
        }
    }
    if DEBUG > 1 {
        fmt.Println()
    }
    return
}

func find_half_chance(n int) (mid int, p, dev float64) {
reset:
    lo := 0
    hi := DAYS*(n-1) + 1
    for {
        mid = (hi + lo) / 2
        p, dev = prob(mid, n)

        if DEBUG > 0 {
            fmt.Println("\t", lo, mid, hi, p, dev)
        }
        if p < .5 {
            lo = mid + 1
        } else {
            hi = mid
        }
        if hi < lo {
            if DEBUG > 0 {
                fmt.Println("\tMade a mess, will redo.")
            }
            goto reset
        }
        if !(lo < mid || p < .5) {
            break
        }
    }
    return
}

func main() {
    for n := 2; n <= 5; n++ {
        np, p, d := find_half_chance(n)
        fmt.Printf("%d collision: %d people, P = %.4f ± %.4f\n",
            n, np, p, d)
    }
}
