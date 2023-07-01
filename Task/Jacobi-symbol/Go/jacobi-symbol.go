package main

import (
    "fmt"
    "log"
    "math/big"
)

func jacobi(a, n uint64) int {
    if n%2 == 0 {
        log.Fatal("'n' must be a positive odd integer")
    }
    a %= n
    result := 1
    for a != 0 {
        for a%2 == 0 {
            a /= 2
            nn := n % 8
            if nn == 3 || nn == 5 {
                result = -result
            }
        }
        a, n = n, a
        if a%4 == 3 && n%4 == 3 {
            result = -result
        }
        a %= n
    }
    if n == 1 {
        return result
    }
    return 0
}

func main() {
    fmt.Println("Using hand-coded version:")
    fmt.Println("n/a  0  1  2  3  4  5  6  7  8  9")
    fmt.Println("---------------------------------")
    for n := uint64(1); n <= 17; n += 2 {
        fmt.Printf("%2d ", n)
        for a := uint64(0); a <= 9; a++ {
            fmt.Printf(" % d", jacobi(a, n))
        }
        fmt.Println()
    }

    ba, bn := new(big.Int), new(big.Int)
    fmt.Println("\nUsing standard library function:")
    fmt.Println("n/a  0  1  2  3  4  5  6  7  8  9")
    fmt.Println("---------------------------------")
    for n := uint64(1); n <= 17; n += 2 {
        fmt.Printf("%2d ", n)
        for a := uint64(0); a <= 9; a++ {
            ba.SetUint64(a)
            bn.SetUint64(n)
            fmt.Printf(" % d", big.Jacobi(ba, bn))
        }
        fmt.Println()
    }
}
