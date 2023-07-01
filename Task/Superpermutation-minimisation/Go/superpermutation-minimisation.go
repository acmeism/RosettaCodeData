package main

import "fmt"

const max = 12

var (
    super []byte
    pos   int
    cnt   [max]int
)

// 1! + 2! + ... + n!
func factSum(n int) int {
    s := 0
    for x, f := 0, 1; x < n; {
        x++
        f *= x
        s += f
    }
    return s
}

func r(n int) bool {
    if n == 0 {
        return false
    }
    c := super[pos-n]
    cnt[n]--
    if cnt[n] == 0 {
        cnt[n] = n
        if !r(n - 1) {
            return false
        }
    }
    super[pos] = c
    pos++
    return true
}

func superperm(n int) {
    pos = n
    le := factSum(n)
    super = make([]byte, le)
    for i := 0; i <= n; i++ {
        cnt[i] = i
    }
    for i := 1; i <= n; i++ {
        super[i-1] = byte(i) + '0'
    }

    for r(n) {
    }
}

func main() {
    for n := 0; n < max; n++ {
        fmt.Printf("superperm(%2d) ", n)
        superperm(n)
        fmt.Printf("len = %d\n", len(super))
    }
}
