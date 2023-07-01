package main

import (
    "fmt"
    "strconv"
    "time"
)

func isPalindrome2(n uint64) bool {
    x := uint64(0)
    if (n & 1) == 0 {
        return n == 0
    }
    for x < n {
        x = (x << 1) | (n & 1)
        n >>= 1
    }
    return n == x || n == (x>>1)
}

func reverse3(n uint64) uint64 {
    x := uint64(0)
    for n != 0 {
        x = x*3 + (n % 3)
        n /= 3
    }
    return x
}

func show(n uint64) {
    fmt.Println("Decimal :", n)
    fmt.Println("Binary  :", strconv.FormatUint(n, 2))
    fmt.Println("Ternary :", strconv.FormatUint(n, 3))
    fmt.Println("Time    :", time.Since(start))
    fmt.Println()
}

func min(a, b uint64) uint64 {
    if a < b {
        return a
    }
    return b
}

func max(a, b uint64) uint64 {
    if a > b {
        return a
    }
    return b
}

var start time.Time

func main() {
    start = time.Now()
    fmt.Println("The first 7 numbers which are palindromic in both binary and ternary are :\n")
    show(0)
    cnt := 1
    var lo, hi, pow2, pow3 uint64 = 0, 1, 1, 1
    for {
        i := lo
        for ; i < hi; i++ {
            n := (i*3+1)*pow3 + reverse3(i)
            if !isPalindrome2(n) {
                continue
            }
            show(n)
            cnt++
            if cnt >= 7 {
                return
            }
        }

        if i == pow3 {
            pow3 *= 3
        } else {
            pow2 *= 4
        }

        for {
            for pow2 <= pow3 {
                pow2 *= 4
            }

            lo2 := (pow2/pow3 - 1) / 3
            hi2 := (pow2*2/pow3-1)/3 + 1
            lo3 := pow3 / 3
            hi3 := pow3

            if lo2 >= hi3 {
                pow3 *= 3
            } else if lo3 >= hi2 {
                pow2 *= 4
            } else {
                lo = max(lo2, lo3)
                hi = min(hi2, hi3)
                break
            }
        }
    }
}
