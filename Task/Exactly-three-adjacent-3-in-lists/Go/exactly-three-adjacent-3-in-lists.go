package main

import "fmt"

func main() {
    lists := [][]int{
        {9, 3, 3, 3, 2, 1, 7, 8, 5},
        {5, 2, 9, 3, 3, 7, 8, 4, 1},
        {1, 4, 3, 6, 7, 3, 8, 3, 2},
        {1, 2, 3, 4, 5, 6, 7, 8, 9},
        {4, 6, 8, 7, 2, 3, 3, 3, 1},
        {3, 3, 3, 1, 2, 4, 5, 1, 3},
        {0, 3, 3, 3, 3, 7, 2, 2, 6},
        {3, 3, 3, 3, 3, 4, 4, 4, 4},
    }
    for d := 1; d <= 4; d++ {
        fmt.Printf("Exactly %d adjacent %d's:\n", d, d)
        for _, list := range lists {
            var indices []int
            for i, e := range list {
                if e == d {
                    indices = append(indices, i)
                }
            }
            adjacent := false
            if len(indices) == d {
                adjacent = true
                for i := 1; i < len(indices); i++ {
                    if indices[i]-indices[i-1] != 1 {
                        adjacent = false
                        break
                    }
                }
            }
            fmt.Printf("%v -> %t\n", list, adjacent)
        }
        fmt.Println()
    }
}
