package main

import (
    "fmt"
    "math"
    "math/rand"
    "strings"
    "time"
)

func rng(modifier func(x float64) float64) float64 {
    for {
        r1 := rand.Float64()
        r2 := rand.Float64()
        if r2 < modifier(r1) {
            return r1
        }
    }
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func main() {
    rand.Seed(time.Now().UnixNano())
    modifier := func(x float64) float64 {
        if x < 0.5 {
            return 2 * (0.5 - x)
        }
        return 2 * (x - 0.5)
    }
    const (
        N              = 100000
        NUM_BINS       = 20
        HIST_CHAR      = "■"
        HIST_CHAR_SIZE = 125
    )
    bins := make([]int, NUM_BINS) // all zero by default
    binSize := 1.0 / NUM_BINS
    for i := 0; i < N; i++ {
        rn := rng(modifier)
        bn := int(math.Floor(rn / binSize))
        bins[bn]++
    }

    fmt.Println("Modified random distribution with", commatize(N), "samples in range [0, 1):\n")
    fmt.Println("    Range           Number of samples within that range")
    for i := 0; i < NUM_BINS; i++ {
        hist := strings.Repeat(HIST_CHAR, int(math.Round(float64(bins[i])/HIST_CHAR_SIZE)))
        fi := float64(i)
        fmt.Printf("%4.2f ..< %4.2f  %s %s\n", binSize*fi, binSize*(fi+1), hist, commatize(bins[i]))
    }
}
