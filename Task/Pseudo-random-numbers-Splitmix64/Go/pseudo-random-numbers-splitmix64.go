package main

import (
    "fmt"
    "math"
)

type Splitmix64 struct{ state uint64 }

func Splitmix64New(state uint64) *Splitmix64 { return &Splitmix64{state} }

func (sm64 *Splitmix64) nextInt() uint64 {
    sm64.state += 0x9e3779b97f4a7c15
    z := sm64.state
    z = (z ^ (z >> 30)) * 0xbf58476d1ce4e5b9
    z = (z ^ (z >> 27)) * 0x94d049bb133111eb
    return z ^ (z >> 31)
}

func (sm64 *Splitmix64) nextFloat() float64 {
    return float64(sm64.nextInt()) / (1 << 64)
}

func main() {
    randomGen := Splitmix64New(1234567)
    for i := 0; i < 5; i++ {
        fmt.Println(randomGen.nextInt())
    }

    var counts [5]int
    randomGen = Splitmix64New(987654321)
    for i := 0; i < 1e5; i++ {
        j := int(math.Floor(randomGen.nextFloat() * 5))
        counts[j]++
    }
    fmt.Println("\nThe counts for 100,000 repetitions are:")
    for i := 0; i < 5; i++ {
        fmt.Printf("  %d : %d\n", i, counts[i])
    }
}
