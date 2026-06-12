package main

import "rcu"

func isIdoneal(n int) bool {
    for a := 1; a < n; a++ {
        for b := a + 1; b < n; b++ {
            if a*b+a+b > n {
                break
            }
            for c := b + 1; c < n; c++ {
                sum := a*b + b*c + a*c
                if sum == n {
                    return false
                }
                if sum > n {
                    break
                }
            }
        }
    }
    return true
}

func main() {
    var idoneals []int
    for n := 1; n <= 1850; n++ {
        if isIdoneal(n) {
            idoneals = append(idoneals, n)
        }
    }
    rcu.PrintTable(idoneals, 13, 4, false)
}
