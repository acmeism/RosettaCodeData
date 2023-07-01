package main

import (
    "fmt"
    "time"
)

func sieve() []bool {
    sv := make([]bool, 2*1e9+9*9 + 1)
    n := 0
    var s [8]int
    for a := 0; a < 2; a++ {
        for b := 0; b < 10; b++ {
            s[0] = a + b
            for c := 0; c < 10; c++ {
                s[1] = s[0] + c
                for d := 0; d < 10; d++ {
                    s[2] = s[1] + d
                    for e := 0; e < 10; e++ {
                        s[3] = s[2] + e
                        for f := 0; f < 10; f++ {
                            s[4] = s[3] + f
                            for g := 0; g < 10; g++ {
                                s[5] = s[4] + g
                                for h := 0; h < 10; h++ {
                                    s[6] = s[5] + h
                                    for i := 0; i < 10; i++ {
                                        s[7] = s[6] + i
                                        for j := 0; j < 10; j++ {
                                            sv[s[7]+j+n] = true
                                            n++
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return sv
}

func main() {
    st := time.Now()
    sv := sieve()
    count := 0
    fmt.Println("The first 50 self numbers are:")
    for i := 0; i < len(sv); i++ {
        if !sv[i] {
            count++
            if count <= 50 {
                fmt.Printf("%d ", i)
            }
            if count == 1e8 {
                fmt.Println("\n\nThe 100 millionth self number is", i)
                break
            }
        }
    }
    fmt.Println("Took", time.Since(st))
}
