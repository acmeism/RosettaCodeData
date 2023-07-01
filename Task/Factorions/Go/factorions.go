package main

import (
    "fmt"
    "strconv"
)

func main() {
    // cache factorials from 0 to 11
    var fact [12]uint64
    fact[0] = 1
    for n := uint64(1); n < 12; n++ {
        fact[n] = fact[n-1] * n
    }

    for b := 9; b <= 12; b++ {
        fmt.Printf("The factorions for base %d are:\n", b)
        for i := uint64(1); i < 1500000; i++ {
            digits := strconv.FormatUint(i, b)
            sum := uint64(0)
            for _, digit := range digits {
                if digit < 'a' {
                    sum += fact[digit-'0']
                } else {
                    sum += fact[digit+10-'a']
                }
            }
            if sum == i {
                fmt.Printf("%d ", i)
            }
        }
        fmt.Println("\n")
    }
}
