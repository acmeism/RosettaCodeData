package main

import (
    "fmt"
    "math/big"
)

var smallPrimes = [...]int{2, 3, 5, 7, 11, 13, 17, 19, 23, 29}

const maxStack = 128

var (
    tens, values    [maxStack]big.Int
    bigTemp, answer = new(big.Int), new(big.Int)
    base, seenDepth int
)

func addDigit(i int) {
    for d := 1; d < base; d++ {
        values[i].Set(&values[i-1])
        bigTemp.SetUint64(uint64(d))
        bigTemp.Mul(bigTemp, &tens[i])
        values[i].Add(&values[i], bigTemp)
        if !values[i].ProbablyPrime(0) {
            continue
        }
        if i > seenDepth || (i == seenDepth && values[i].Cmp(answer) == 1) {
            if !values[i].ProbablyPrime(0) {
                continue
            }
            answer.Set(&values[i])
            seenDepth = i
        }
        addDigit(i + 1)
    }
}

func doBase() {
    answer.SetUint64(0)
    tens[0].SetUint64(1)
    bigTemp.SetUint64(uint64(base))
    seenDepth = 0
    for i := 1; i < maxStack; i++ {
        tens[i].Mul(&tens[i-1], bigTemp)
    }
    for i := 0; smallPrimes[i] < base; i++ {
        values[0].SetUint64(uint64(smallPrimes[i]))
        addDigit(1)
    }
    fmt.Printf("%2d: %s\n", base, answer.String())
}

func main() {
    for base = 3; base <= 17; base++ {
        doBase()
    }
}
