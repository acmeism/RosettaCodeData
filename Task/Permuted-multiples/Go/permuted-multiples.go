package main

import (
    "fmt"
    "rcu"
    "sort"
)

// assumes l1 is sorted but l2 is not
func areSame(l1, l2 []int) bool {
    if len(l1) != len(l2) {
        return false
    }
    sort.Ints(l2)
    for i := 0; i < len(l1); i++ {
        if l1[i] != l2[i] {
            return false
        }
    }
    return true
}

func main() {
    i := 100 // clearly a 1 or 2 digit number is impossible
    nextPow := 1000
    for {
        digits := rcu.Digits(i, 10)
        if digits[0] != 1 {
            i = nextPow
            nextPow *= 10
            continue
        }
        sort.Ints(digits)
        allSame := true
        for j := 2; j <= 6; j++ {
            digits2 := rcu.Digits(i*j, 10)
            if !areSame(digits, digits2) {
                allSame = false
                break
            }
        }
        if allSame {
            fmt.Println("The smallest positive integer n for which the following")
            fmt.Println("multiples contain exactly the same digits is:")
            fmt.Println("    n =", i)
            for k := 2; k <= 6; k++ {
                fmt.Printf("%d x n = %d\n", k, k*i)
            }
            return
        }
        i = i + 1
    }
}
