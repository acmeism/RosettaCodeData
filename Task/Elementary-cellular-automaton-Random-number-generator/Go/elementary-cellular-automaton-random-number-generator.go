package main

import "fmt"

const n = 64

func pow2(x uint) uint64 {
    return uint64(1) << x
}

func evolve(state uint64, rule int) {
    for p := 0; p < 10; p++ {
        b := uint64(0)
        for q := 7; q >= 0; q-- {
            st := state
            b |= (st & 1) << uint(q)
            state = 0
            for i := uint(0); i < n; i++ {
                var t1, t2, t3 uint64
                if i > 0 {
                    t1 = st >> (i - 1)
                } else {
                    t1 = st >> 63
                }
                if i == 0 {
                    t2 = st << 1
                } else if i == 1 {
                    t2 = st << 63

                } else {
                    t2 = st << (n + 1 - i)
                }
                t3 = 7 & (t1 | t2)
                if (uint64(rule) & pow2(uint(t3))) != 0 {
                    state |= pow2(i)
                }
            }
        }
        fmt.Printf("%d ", b)
    }
    fmt.Println()
}

func main() {
    evolve(1, 30)
}
