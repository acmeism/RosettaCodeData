package main

import "fmt"

func main() {
    for i := 0; i < 16; i++ {
        for j := 32 + i; j < 128; j += 16 {
            k := string(j)
            switch j {
            case 32:
                k = "Spc"
            case 127:
                k = "Del"
            }
            fmt.Printf("%3d : %-3s   ", j, k)
        }
        fmt.Println()
    }
}
