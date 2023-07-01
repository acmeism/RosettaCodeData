package main

import (
    "fmt"
    "github.com/jbarham/primegen.go"
)

func main() {
    p := primegen.New()
    count := 0
    previous := uint64(0)
    power := 1
    limit := uint64(10)
    for {
        prime := p.Next()
        if prime >= limit {
            fmt.Printf("Number of twin prime pairs less than %d: %d\n", limit, count)
            power++
            if power > 10 {
                break
            }
            limit *= 10
        }
        if previous > 0 && prime == previous + 2 {
            count++
        }
        previous = prime
    }
}
