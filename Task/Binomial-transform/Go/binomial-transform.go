package main

import "fmt"

func factorial(n int) uint64 {
    if n > 20 {
        return 0 // too big for uint64
    }
    if n < 2 {
        return 1
    }
    fact := uint64(1)
    i := 2
    for i <= n {
        fact *= uint64(i)
        i++
    }
    return fact
}

func binomial(n, k int) uint64 {
    return factorial(n) / factorial(n-k) / factorial(k)
}

func btForward(a []int64) []int64 {
    c := len(a)
    b := make([]int64, c)
    for n := 0; n < c; n++ {
        b[n] = int64(0)
        for k := 0; k <= n; k++ {
            b[n] += int64(binomial(n, k)) * a[k]
        }
    }
    return b
}

func btInverse(b []int64) []int64 {
    c := len(b)
    a := make([]int64, c)
    for n := 0; n < c; n++ {
        a[n] = int64(0)
        for k := 0; k <= n; k++ {
            sign := int64(-1)
            if (n-k)&1 == 0 {
                sign = 1
            }
            a[n] += int64(binomial(n, k)) * b[k] * sign
        }
    }
    return a
}

func btSelfInverting(a []int64) []int64 {
    c := len(a)
    b := make([]int64, c)
    for n := 0; n < c; n++ {
        b[n] = int64(0)
        for k := 0; k <= n; k++ {
            sign := int64(-1)
            if k&1 == 0 {
                sign = 1
            }
            b[n] += int64(binomial(n, k)) * a[k] * sign
        }
    }
    return b
}

func main() {
    seqs := [][]int64{
        {1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845, 35357670, 129644790, 477638700, 1767263190},
        {0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0},
        {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181},
        {1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37},
    }

    names := []string{
        "Catalan number sequence:",
        "Prime flip-flop sequence:",
        "Fibonacci number sequence:",
        "Padovan number sequence:",
    }

    for i, seq := range seqs {
        fmt.Println(names[i])
        fmt.Println(seq)
        fmt.Println("Forward binomial transform:")
        fwd := btForward(seq)
        fmt.Println(fwd)
        fmt.Println("Inverse binomial transform:")
        fmt.Println(btInverse(seq))
        fmt.Println("Round trip:")
        fmt.Println(btInverse(fwd))
        fmt.Println("Self-inverting:")
        si := btSelfInverting(seq)
        fmt.Println(si)
        fmt.Println("Re-inverted:")
        fmt.Println(btSelfInverting(si))
        if i < len(seqs)-1 {
            fmt.Println()
        }
    }
}
