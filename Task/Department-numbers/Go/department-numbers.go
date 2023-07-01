package main

import "fmt"

func main() {
    fmt.Println("Police  Sanitation  Fire")
    fmt.Println("------  ----------  ----")
    count := 0
    for i := 2; i < 7; i += 2 {
        for j := 1; j < 8; j++ {
            if j == i { continue }
            for k := 1; k < 8; k++ {
                if k == i || k == j { continue }
                if i + j + k != 12 { continue }
                fmt.Printf("  %d         %d         %d\n", i, j, k)
                count++
            }
        }
    }
    fmt.Printf("\n%d valid combinations\n", count)
}
