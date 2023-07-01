package main

import (
    "fmt"
    "math/rand"
    "rcu"
    "time"
)

func sleepingBeauty(reps int) float64 {
    wakings := 0
    heads := 0
    for i := 0; i < reps; i++ {
        coin := rand.Intn(2) // heads = 0, tails = 1 say
        wakings++
        if coin == 0 {
            heads++
        } else {
            wakings++
        }
    }
    fmt.Printf("Wakings over %s repetitions = %s\n", rcu.Commatize(reps), rcu.Commatize(wakings))
    return float64(heads) / float64(wakings) * 100
}

func main() {
    rand.Seed(time.Now().UnixNano())
    pc := sleepingBeauty(1e6)
    fmt.Printf("Percentage probability of heads on waking = %f%%\n", pc)
}
