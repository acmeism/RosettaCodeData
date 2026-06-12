package main

import (
    "fmt"
    "time"
)

func ulam(n int) int {
    if n <= 2 {
        return n
    }
    const MAX = 1_352_000
    list := make([]int, MAX+1)
    list[0], list[1] = 1, 2
    sums := make([]byte, 2*MAX+1)
    sums[3] = 1
    size := 2
    var query int
    for {
        query = list[size-1] + 1
        for {
            if sums[query] == 1 {
                for i := 0; i < size; i++ {
                    sum := query + list[i]
                    t := sums[sum] + 1
                    if t <= 2 {
                        sums[sum] = t
                    }
                }
                list[size] = query
                size++
                break
            }
            query++
        }
        if size >= n {
            break
        }
    }
    return query
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func main() {
    start := time.Now()
    for n := 10; n <= 100000; n *= 10 {
        fmt.Println("The", commatize(n), "\bth Ulam number is", commatize(ulam(n)))
    }
    fmt.Println("\nTook", time.Since(start))
}
