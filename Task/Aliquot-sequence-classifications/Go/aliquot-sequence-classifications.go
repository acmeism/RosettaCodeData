package main

import (
    "fmt"
    "math"
    "strings"
)

const threshold = uint64(1) << 47

func indexOf(s []uint64, search uint64) int {
    for i, e := range s {
        if e == search {
            return i
        }
    }
    return -1
}

func contains(s []uint64, search uint64) bool {
    return indexOf(s, search) > -1
}

func maxOf(i1, i2 int) int {
    if i1 > i2 {
        return i1
    }
    return i2
}

func sumProperDivisors(n uint64) uint64 {
    if n < 2 {
        return 0
    }
    sqrt := uint64(math.Sqrt(float64(n)))
    sum := uint64(1)
    for i := uint64(2); i <= sqrt; i++ {
        if n % i != 0 {
            continue
        }
        sum += i + n / i
    }
    if sqrt * sqrt == n {
        sum -= sqrt
    }
    return sum
}

func classifySequence(k uint64) ([]uint64, string) {
    if k == 0 {
        panic("Argument must be positive.")
    }
    last := k
    var seq []uint64
    seq = append(seq, k)
    for {
        last = sumProperDivisors(last)
        seq = append(seq, last)
        n := len(seq)
        aliquot := ""
        switch {
        case last == 0:
            aliquot = "Terminating"
        case n == 2 && last == k:
            aliquot = "Perfect"
        case n == 3 && last == k:
            aliquot = "Amicable"
        case n >= 4 && last == k:
            aliquot = fmt.Sprintf("Sociable[%d]", n - 1)
        case last == seq[n - 2]:
            aliquot = "Aspiring"
        case contains(seq[1 : maxOf(1, n - 2)], last):
            aliquot = fmt.Sprintf("Cyclic[%d]", n - 1 - indexOf(seq[:], last))
        case n == 16 || last > threshold:
            aliquot = "Non-Terminating"
        }
        if aliquot != "" {
            return seq, aliquot
        }
    }
}

func joinWithCommas(seq []uint64) string {
    res := fmt.Sprint(seq)
    res = strings.Replace(res, " ", ", ", -1)
    return res
}

func main() {
    fmt.Println("Aliquot classifications - periods for Sociable/Cyclic in square brackets:\n")
    for k := uint64(1); k <= 10; k++ {
        seq, aliquot := classifySequence(k)
        fmt.Printf("%2d: %-15s %s\n", k, aliquot, joinWithCommas(seq))
    }
    fmt.Println()

    s := []uint64{
        11, 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488,
    }
    for _, k := range s {
        seq, aliquot := classifySequence(k)
        fmt.Printf("%7d: %-15s %s\n",  k, aliquot, joinWithCommas(seq))
    }
    fmt.Println()

    k := uint64(15355717786080)
    seq, aliquot := classifySequence(k)
    fmt.Printf("%d: %-15s %s\n", k, aliquot, joinWithCommas(seq))
}
