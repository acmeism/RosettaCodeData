package main

import "fmt"

func countDivisors(n int) int {
    count := 0
    for i := 1; i*i <= n; i++ {
        if n%i == 0 {
            if i == n/i {
                count++
            } else {
                count += 2
            }
        }
    }
    return count
}

func main() {
    const max = 15
    seq := make([]int, max)
    fmt.Println("The first", max, "terms of the sequence are:")
    for i, n := 1, 0; n < max; i++ {
        if k := countDivisors(i); k <= max && seq[k-1] == 0 {
            seq[k-1] = i
            n++
        }
    }
    fmt.Println(seq)
}
