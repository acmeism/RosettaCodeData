package main

import (
    "fmt"
    "math"
)

const CONST = 0x2545F4914F6CDD1D

type XorshiftStar struct{ state uint64 }

func XorshiftStarNew(state uint64) *XorshiftStar { return &XorshiftStar{state} }

func (xor *XorshiftStar) seed(state uint64) { xor.state = state }

func (xor *XorshiftStar) nextInt() uint32 {
    x := xor.state
    x = x ^ (x >> 12)
    x = x ^ (x << 25)
    x = x ^ (x >> 27)
    xor.state = x
    return uint32((x * CONST) >> 32)
}

func (xor *XorshiftStar) nextFloat() float64 {
    return float64(xor.nextInt()) / (1 << 32)
}

func main() {
    randomGen := XorshiftStarNew(1234567)
    for i := 0; i < 5; i++ {
        fmt.Println(randomGen.nextInt())
    }

    var counts [5]int
    randomGen.seed(987654321)
    for i := 0; i < 1e5; i++ {
        j := int(math.Floor(randomGen.nextFloat() * 5))
        counts[j]++
    }
    fmt.Println("\nThe counts for 100,000 repetitions are:")
    for i := 0; i < 5; i++ {
        fmt.Printf("  %d : %d\n", i, counts[i])
    }
}
