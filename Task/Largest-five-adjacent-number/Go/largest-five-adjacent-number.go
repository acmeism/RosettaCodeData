package main

import (
    "fmt"
    "math/rand"
    "rcu"
    "strings"
    "time"
)

func main() {
    rand.Seed(time.Now().UnixNano())
    var sb strings.Builder
    for i := 0; i < 1000; i++ {
        sb.WriteByte(byte(rand.Intn(10) + 48))
    }
    number := sb.String()
    for i := 99999; i >= 0; i-- {
        quintet := fmt.Sprintf("%05d", i)
        if strings.Contains(number, quintet) {
            ci := rcu.Commatize(i)
            fmt.Printf("The largest  number formed from 5 adjacent digits (%s) is: %6s\n", quintet, ci)
            break
        }
    }
    for i := 0; i <= 99999; i++ {
        quintet := fmt.Sprintf("%05d", i)
        if strings.Contains(number, quintet) {
            ci := rcu.Commatize(i)
            fmt.Printf("The smallest number formed from 5 adjacent digits (%s) is: %6s\n", quintet, ci)
            return
        }
    }
}
