package main

import "fmt"

func main() {
    const n = 15
    t := [n + 2]uint64{0, 1}
    for i := 1; i <= n; i++ {
        for j := i; j > 1; j-- {
            t[j] += t[j-1]
        }
        t[i+1] = t[i]
        for j := i + 1; j > 1; j-- {
            t[j] += t[j-1]
        }
        fmt.Printf("%2d : %d\n", i, t[i+1]-t[i])
    }
}
