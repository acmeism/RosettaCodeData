package main

import "fmt"

func divisors(n int) []int {
    divs := []int{1}
    divs2 := []int{}
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            j := n / i
            divs = append(divs, i)
            if i != j {
                divs2 = append(divs2, j)
            }
        }
    }
    for i := len(divs) - 1; i >= 0; i-- {
        divs2 = append(divs2, divs[i])
    }
    return divs2
}

func abundant(n int, divs []int) bool {
    sum := 0
    for _, div := range divs {
        sum += div
    }
    return sum > n
}

func semiperfect(n int, divs []int) bool {
    le := len(divs)
    if le > 0 {
        h := divs[0]
        t := divs[1:]
        if n < h {
            return semiperfect(n, t)
        } else {
            return n == h || semiperfect(n-h, t) || semiperfect(n, t)
        }
    } else {
        return false
    }
}

func sieve(limit int) []bool {
    // false denotes abundant and not semi-perfect.
    // Only interested in even numbers >= 2
    w := make([]bool, limit)
    for i := 2; i < limit; i += 2 {
        if w[i] {
            continue
        }
        divs := divisors(i)
        if !abundant(i, divs) {
            w[i] = true
        } else if semiperfect(i, divs) {
            for j := i; j < limit; j += i {
                w[j] = true
            }
        }
    }
    return w
}

func main() {
    w := sieve(17000)
    count := 0
    const max = 25
    fmt.Println("The first 25 weird numbers are:")
    for n := 2; count < max; n += 2 {
        if !w[n] {
            fmt.Printf("%d ", n)
            count++
        }
    }
    fmt.Println()
}
