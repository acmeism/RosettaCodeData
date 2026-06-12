package main

import "fmt"

func rotate(lst []int) {
    len := len(lst)
    last := lst[len-1]
    for i := len - 1; i >= 1; i-- {
        lst[i] = lst[i-1]
    }
    lst[0] = last
}

func roundRobin(n int) {
    lst := make([]int, n-1)
    for i := 0; i < len(lst); i++ {
        lst[i] = i + 2
    }
    if n%2 == 1 {
        lst = append(lst, 0) // 0 denotes a bye
        n++
    }
    for r := 1; r < n; r++ {
        fmt.Printf("Round %2d", r)
        lst2 := append([]int{1}, lst...)
        for i := 0; i < n/2; i++ {
            fmt.Printf(" (%2d vs %-2d)", lst2[i], lst2[n-1-i])
        }
        fmt.Println()
        rotate(lst)
    }
}

func main() {
    fmt.Println("Round robin for 12 players:\n")
    roundRobin(12)
    fmt.Println("\n\nRound robin for 5 players (0 denotes a bye) :\n")
    roundRobin(5)
}
