package main

import (
    "fmt"
    "time"
)

func ulam(n int) int {
    ulams := []int{1, 2}
    sieve := []int{1, 1}
    u := 2
    for len(ulams) < n {
        s := u + ulams[len(ulams)-2]
        t := s - len(sieve)
        for i := 0; i < t; i++ {
            sieve = append(sieve, 0)
        }
        for i := 1; i <= len(ulams)-1; i++ {
            v := u + ulams[i-1] - 1
            sieve[v]++
        }
        index := -1
        for i, e := range sieve[u:] {
            if e == 1 {
                index = u + i
                break
            }
        }
        u = index + 1
        ulams = append(ulams, u)
    }
    return ulams[n-1]
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
    start := time.Now()
    for n := 1; n <= 10000; n *= 10 {
        s := "th"
        if n == 1 {
            s = "st"
        }
        fmt.Println("The", commatize(n), "\b"+s+" Ulam number is", commatize(ulam(n)))
    }
    fmt.Println("\nTook", time.Since(start))
}
