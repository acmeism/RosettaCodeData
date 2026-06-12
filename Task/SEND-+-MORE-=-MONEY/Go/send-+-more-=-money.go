package main

import (
    "fmt"
    "time"
)

func contains(a []int, v int) bool {
    for i := 0; i < len(a); i++ {
        if a[i] == v {
            return true
        }
    }
    return false
}

func main() {
    start := time.Now()
    var sends [][4]int
    var ors [][2]int
    m := 1
    digits := []int{0, 2, 3, 4, 5, 6, 7, 8, 9}
    for s := 8; s <= 9; s++ {
        for _, e := range digits {
            if e == s {
                continue
            }
            for _, n := range digits {
                if n == s || n == e {
                    continue
                }
                for _, d := range digits {
                    if d == s || d == e || d == n {
                        continue
                    }
                    sends = append(sends, [4]int{s, e, n, d})
                }
            }
        }
    }
    for _, o := range digits {
        for _, r := range digits {
            if r != o {
                ors = append(ors, [2]int{o, r})
            }
        }
    }
    fmt.Println("Solution(s):")
    for _, send := range sends {
        SEND := 1000*send[0] + 100*send[1] + 10*send[2] + send[3]
        for _, or := range ors {
            send2 := send[:]
            or2 := or[:]
            if contains(send2, or[0]) || contains(send2, or[1]) {
                continue
            }
            MORE := 1000*m + 100*or[0] + 10*or[1] + send[1]
            for _, y := range digits {
                if contains(send2, y) || contains(or2, y) {
                    continue
                }
                MONEY := 10000*m + 1000*or[0] + 100*send[2] + 10*send[1] + y
                if SEND+MORE == MONEY {
                    fmt.Printf("%d + %d = %d\n", SEND, MORE, MONEY)
                }
            }
        }
    }
    fmt.Printf("\nTook %s.\n", time.Since(start))
}
