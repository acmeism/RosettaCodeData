package main

import (
    "fmt"
    "rcu"
)

// only small factorials needed
func factorial(n int) int {
    fact := 1
    for i := 2; i <= n; i++ {
        fact *= i
    }
    return fact
}

// generates all permutations in lexicographical order
func permutations(input []int) [][]int {
    perms := [][]int{input}
    a := make([]int, len(input))
    copy(a, input)
    var n = len(input) - 1
    for c := 1; c < factorial(n+1); c++ {
        i := n - 1
        j := n
        for a[i] > a[i+1] {
            i--
        }
        for a[j] < a[i] {
            j--
        }
        a[i], a[j] = a[j], a[i]
        j = n
        i += 1
        for i < j {
            a[i], a[j] = a[j], a[i]
            i++
            j--
        }
        b := make([]int, len(input))
        copy(b, a)
        perms = append(perms, b)
    }
    return perms
}

func main() {
outer:
    for _, start := range []int{1, 0} {
        fmt.Printf("The largest pandigital decimal prime which uses all the digits %d..n once is:\n", start)
        for _, n := range []int{7, 4} {
            m := n + 1 - start
            list := make([]int, m)
            for i := 0; i < m; i++ {
                list[i] = i + start
            }
            perms := permutations(list)
            for i := len(perms) - 1; i >= 0; i-- {
                le := len(perms[i])
                if perms[i][le-1]%2 == 0 || perms[i][le-1] == 5 || (start == 0 && perms[i][0] == 0) {
                    continue
                }
                p := 0
                pow := 1
                for j := le - 1; j >= 0; j-- {
                    p += perms[i][j] * pow
                    pow *= 10
                }
                if rcu.IsPrime(p) {
                    fmt.Println(rcu.Commatize(p) + "\n")
                    continue outer
                }
            }
        }
    }
}
