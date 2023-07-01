package main

import "rcu"

func main() {
    var res []int
    for n := 1; n <= 70; n++ {
        m := 1
        for rcu.DigitSum(m*n, 10) != n {
            m++
        }
        res = append(res, m)
    }
    rcu.PrintTable(res, 7, 10, true)
}
