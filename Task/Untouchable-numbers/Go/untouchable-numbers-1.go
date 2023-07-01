package main

import "fmt"

func sumDivisors(n int) int {
    sum := 1
    k := 2
    if n%2 == 0 {
        k = 1
    }
    for i := 1 + k; i*i <= n; i += k {
        if n%i == 0 {
            sum += i
            j := n / i
            if j != i {
                sum += j
            }
        }
    }
    return sum
}

func sieve(n int) []bool {
    n++
    s := make([]bool, n+1) // all false by default
    for i := 6; i <= n; i++ {
        sd := sumDivisors(i)
        if sd <= n {
            s[sd] = true
        }
    }
    return s
}

func primeSieve(limit int) []bool {
    limit++
    // True denotes composite, false denotes prime.
    c := make([]bool, limit) // all false by default
    c[0] = true
    c[1] = true
    // no need to bother with even numbers over 2 for this task
    p := 3 // Start from 3.
    for {
        p2 := p * p
        if p2 >= limit {
            break
        }
        for i := p2; i < limit; i += 2 * p {
            c[i] = true
        }
        for {
            p += 2
            if !c[p] {
                break
            }
        }
    }
    return c
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func main() {
    limit := 1000000
    c := primeSieve(limit)
    s := sieve(63 * limit)
    untouchable := []int{2, 5}
    for n := 6; n <= limit; n += 2 {
        if !s[n] && c[n-1] && c[n-3] {
            untouchable = append(untouchable, n)
        }
    }
    fmt.Println("List of untouchable numbers <= 2,000:")
    count := 0
    for i := 0; untouchable[i] <= 2000; i++ {
        fmt.Printf("%6s", commatize(untouchable[i]))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
        count++
    }
    fmt.Printf("\n\n%7s untouchable numbers were found  <=     2,000\n", commatize(count))
    p := 10
    count = 0
    for _, n := range untouchable {
        count++
        if n > p {
            cc := commatize(count - 1)
            cp := commatize(p)
            fmt.Printf("%7s untouchable numbers were found  <= %9s\n", cc, cp)
            p = p * 10
            if p == limit {
                break
            }
        }
    }
    cu := commatize(len(untouchable))
    cl := commatize(limit)
    fmt.Printf("%7s untouchable numbers were found  <= %s\n", cu, cl)
}
