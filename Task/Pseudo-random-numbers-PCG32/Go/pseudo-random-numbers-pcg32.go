package main

import (
    "fmt"
    "math"
)

const CONST = 6364136223846793005

type Pcg32 struct{ state, inc uint64 }

func Pcg32New() *Pcg32 { return &Pcg32{0x853c49e6748fea9b, 0xda3e39cb94b95bdb} }

func (pcg *Pcg32) seed(seedState, seedSequence uint64) {
    pcg.state = 0
    pcg.inc = (seedSequence << 1) | 1
    pcg.nextInt()
    pcg.state = pcg.state + seedState
    pcg.nextInt()
}

func (pcg *Pcg32) nextInt() uint32 {
    old := pcg.state
    pcg.state = old*CONST + pcg.inc
    pcgshifted := uint32(((old >> 18) ^ old) >> 27)
    rot := uint32(old >> 59)
    return (pcgshifted >> rot) | (pcgshifted << ((-rot) & 31))
}

func (pcg *Pcg32) nextFloat() float64 {
    return float64(pcg.nextInt()) / (1 << 32)
}

func main() {
    randomGen := Pcg32New()
    randomGen.seed(42, 54)
    for i := 0; i < 5; i++ {
        fmt.Println(randomGen.nextInt())
    }

    var counts [5]int
    randomGen.seed(987654321, 1)
    for i := 0; i < 1e5; i++ {
        j := int(math.Floor(randomGen.nextFloat() * 5))
        counts[j]++
    }
    fmt.Println("\nThe counts for 100,000 repetitions are:")
    for i := 0; i < 5; i++ {
        fmt.Printf("  %d : %d\n", i, counts[i])
    }
}
