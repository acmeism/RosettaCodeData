package main

import(
    "math"
    "fmt"
)

func minOf(x, y uint) uint {
    if x < y {
        return x
    }
    return y
}

func throwDie(nSides, nDice, s uint, counts []uint) {
    if nDice == 0 {
        counts[s]++
        return
    }
    for i := uint(1); i <= nSides; i++ {
        throwDie(nSides, nDice - 1, s + i, counts)
    }
}

func beatingProbability(nSides1, nDice1, nSides2, nDice2 uint) float64 {
    len1 := (nSides1 + 1) * nDice1
    c1 := make([]uint, len1)  // all elements zero by default
    throwDie(nSides1, nDice1, 0, c1)

    len2 := (nSides2 + 1) * nDice2
    c2 := make([]uint, len2)
    throwDie(nSides2, nDice2, 0, c2)
    p12 := math.Pow(float64(nSides1), float64(nDice1)) *
           math.Pow(float64(nSides2), float64(nDice2))

    tot := 0.0
    for i := uint(0); i < len1; i++ {
        for j := uint(0); j < minOf(i, len2); j++ {
            tot += float64(c1[i] * c2[j]) / p12
        }
    }
    return tot
}

func main() {
    fmt.Println(beatingProbability(4, 9, 6, 6))
    fmt.Println(beatingProbability(10, 5, 7, 6))
}
