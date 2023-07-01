package main

import "fmt"

type Range struct {
    start, end uint64
    print      bool
}

func main() {
    rgs := []Range{
        {2, 1000, true},
        {1000, 4000, true},
        {2, 1e4, false},
        {2, 1e5, false},
        {2, 1e6, false},
        {2, 1e7, false},
        {2, 1e8, false},
        {2, 1e9, false},
    }
    for _, rg := range rgs {
        if rg.start == 2 {
            fmt.Printf("eban numbers up to and including %d:\n", rg.end)
        } else {
            fmt.Printf("eban numbers between %d and %d (inclusive):\n", rg.start, rg.end)
        }
        count := 0
        for i := rg.start; i <= rg.end; i += 2 {
            b := i / 1000000000
            r := i % 1000000000
            m := r / 1000000
            r = i % 1000000
            t := r / 1000
            r %= 1000
            if m >= 30 && m <= 66 {
                m %= 10
            }
            if t >= 30 && t <= 66 {
                t %= 10
            }
            if r >= 30 && r <= 66 {
                r %= 10
            }
            if b == 0 || b == 2 || b == 4 || b == 6 {
                if m == 0 || m == 2 || m == 4 || m == 6 {
                    if t == 0 || t == 2 || t == 4 || t == 6 {
                        if r == 0 || r == 2 || r == 4 || r == 6 {
                            if rg.print {
                                fmt.Printf("%d ", i)
                            }
                            count++
                        }
                    }
                }
            }
        }
        if rg.print {
            fmt.Println()
        }
        fmt.Println("count =", count, "\n")
    }
}
