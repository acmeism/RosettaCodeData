package main

import (
    "fmt"
    "time"
)

const MAX_COUNT = 103*1e4*1e4 + 11*9 + 1

var sv = make([]bool, MAX_COUNT+1)
var digitSum = make([]int, 1e4)

func init() {
    i := 9999
    var s, t int
    for a := 9; a >= 0; a-- {
        for b := 9; b >= 0; b-- {
            s = a + b
            for c := 9; c >= 0; c-- {
                t = s + c
                for d := 9; d >= 0; d-- {
                    digitSum[i] = t + d
                    i--
                }
            }
        }
    }
}

func sieve() {
    n := 0
    for a := 0; a < 103; a++ {
        for b := 0; b < 1e4; b++ {
            s := digitSum[a] + digitSum[b] + n
            for c := 0; c < 1e4; c++ {
                sv[digitSum[c]+s] = true
                s++
            }
            n += 1e4
        }
    }
}

func main() {
    st := time.Now()
    sieve()
    fmt.Println("Sieving took", time.Since(st))
    count := 0
    fmt.Println("\nThe first 50 self numbers are:")
    for i := 0; i < len(sv); i++ {
        if !sv[i] {
            count++
            if count <= 50 {
                fmt.Printf("%d ", i)
            } else {
                fmt.Println("\n\n     Index  Self number")
                break
            }
        }
    }
    count = 0
    limit := 1
    for i := 0; i < len(sv); i++ {
        if !sv[i] {
            count++
            if count == limit {
                fmt.Printf("%10d  %11d\n", count, i)
                limit *= 10
                if limit == 1e10 {
                    break
                }
            }
        }
    }
    fmt.Println("\nOverall took", time.Since(st))
}
