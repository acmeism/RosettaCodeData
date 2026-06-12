package main

import (
    "fmt"
    "rcu"
)

// library method customized for this task
func Divisors(n int) []int {
    var divisors []int
    i := 1
    k := 1
    if n%2 == 1 {
        k = 2
    }
    for ; i*i <= n; i += k {
        if i > 1 && n%i == 0 { // exclude 1 and n
            divisors = append(divisors, i)
            if len(divisors) > 2 { // not eligible if has > 2 divisors
                break
            }
            j := n / i
            if j != i {
                divisors = append(divisors, j)
            }
        }
    }
    return divisors
}

func main() {
    count := 0
    limit := 500
    s := 3
    c := 3
    squares := 1
    cubes := 1
    fmt.Printf("Multiplicatively perfect numbers under %d:\n", limit)
    var divs []int
    for i := 0; ; i++ {
        if i != 1 {
            divs = Divisors(i)
        } else {
            divs = []int{1, 1}
        }
        if len(divs) == 2 && divs[0]*divs[1] == i {
            count++
            if i < 500 {
                fmt.Printf("%3d  ", i)
                if count%10 == 0 {
                    fmt.Println()
                }
            }
        }
        if i == 499 {
            fmt.Println()
        }
        if i >= limit-1 {
            var j, k int
            for j = s; j*j < limit; j += 2 {
                if rcu.IsPrime(j) {
                    squares++
                }
            }
            for k = c; k*k*k < limit; k += 2 {
                if rcu.IsPrime(k) {
                    cubes++
                }
            }
            t := count + squares - cubes - 1
            slimit := rcu.Commatize(limit)
            scount := rcu.Commatize(count)
            st := rcu.Commatize(t)
            fmt.Printf("Counts under %9s: MPNs = %7s  Semi-primes = %7s\n", slimit, scount, st)
            if limit == 5000000 {
                break
            }
            s, c = j, k
            limit *= 10
        }
    }
}
