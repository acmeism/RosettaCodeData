package main

import (
    "fmt"
    "math/rand"
    "time"
)

func main() {
    rand.Seed(time.Now().UnixNano())
    numbers := make([]int, 20)
    for i := 0; i < 20; i++ {
        numbers[i] = i + 1
    }
    for i := 1; i <= 5; i++ {
        rand.Shuffle(20, func(i, j int) {
            numbers[i], numbers[j] = numbers[j], numbers[i]
        })
        s := fmt.Sprintf("%2d ", numbers)
        fmt.Println(s[1 : len(s)-2])
    }
}
