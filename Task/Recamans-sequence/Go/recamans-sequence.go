package main

import "fmt"

func main() {
    a := []int{0}
    used := make(map[int]bool, 1001)
    used[0] = true
    used1000 := make(map[int]bool, 1001)
    used1000[0] = true
    for n, foundDup := 1, false; n <= 15 || !foundDup || len(used1000) < 1001; n++ {
        next := a[n-1] - n
        if next < 1 || used[next] {
            next += 2 * n
        }
        alreadyUsed := used[next]
        a = append(a, next)

        if !alreadyUsed {
            used[next] = true
            if next >= 0 && next <= 1000 {
                used1000[next] = true
            }
        }

        if n == 14 {
            fmt.Println("The first 15 terms of the Recaman's sequence are:", a)
        }

        if !foundDup && alreadyUsed {
            fmt.Printf("The first duplicated term is a[%d] = %d\n", n, next)
            foundDup = true
        }

        if len(used1000) == 1001 {
            fmt.Printf("Terms up to a[%d] are needed to generate 0 to 1000\n", n)
        }
    }
}
