package main

import (
    "fmt"
    "rcu"
    "strconv"
    "strings"
)

func contains(list []int, s int) bool {
    for _, e := range list {
        if e == s {
            return true
        }
    }
    return false
}

func main() {
    fmt.Println("Steady squares under 10,000:")
    finalDigits := []int{1, 5, 6}
    for i := 1; i < 10000; i++ {
        if !contains(finalDigits, i%10) {
            continue
        }
        sq := i * i
        sqs := strconv.Itoa(sq)
        is := strconv.Itoa(i)
        if strings.HasSuffix(sqs, is) {
            fmt.Printf("%5s -> %10s\n", rcu.Commatize(i), rcu.Commatize(sq))
        }
    }
}
