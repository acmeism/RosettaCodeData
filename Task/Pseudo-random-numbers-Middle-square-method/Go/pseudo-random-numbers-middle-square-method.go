package main

import "fmt"

func random(seed int) int {
    return seed * seed / 1e3 % 1e6
}

func main() {
    seed := 675248
    for i := 1; i <= 5; i++ {
        seed = random(seed)
        fmt.Println(seed)
    }
}
