package main

import (
    "fmt"
    "rcu"
)

var inc = []int{4, 2, 4, 2, 4, 6, 2, 6}

// Assumes n is odd.
func firstPrimeFactor(n int) int {
    if n == 1 {
        return 1
    }
    if n%3 == 0 {
        return 3
    }
    if n%5 == 0 {
        return 5
    }
    for k, i := 7, 0; k*k <= n; {
        if n%k == 0 {
            return k
        } else {
            k += inc[i]
            i = (i + 1) % 8
        }
    }
    return n
}

func main() {
    blum := make([]int, 50)
    bc := 0
    counts := make([]int, 4)
    i := 1
    for {
        p := firstPrimeFactor(i)
        if p%4 == 3 {
            q := i / p
            if q != p && q%4 == 3 && rcu.IsPrime(q) {
                if bc < 50 {
                    blum[bc] = i
                }
                counts[i%10/3]++
                bc++
                if bc == 50 {
                    fmt.Println("First 50 Blum integers:")
                    rcu.PrintTable(blum, 10, 3, false)
                    fmt.Println()
                } else if bc == 26828 || bc%100000 == 0 {
                    fmt.Printf("The %7sth Blum integer is: %9s\n", rcu.Commatize(bc), rcu.Commatize(i))
                    if bc == 400000 {
                        fmt.Println("\n% distribution of the first 400,000 Blum integers:")
                        digits := []int{1, 3, 7, 9}
                        for j := 0; j < 4; j++ {
                            fmt.Printf("  %6.3f%% end in %d\n", float64(counts[j])/4000, digits[j])
                        }
                        return
                    }
                }
            }
        }
        if i%5 == 3 {
            i += 4
        } else {
            i += 2
        }
    }
}
