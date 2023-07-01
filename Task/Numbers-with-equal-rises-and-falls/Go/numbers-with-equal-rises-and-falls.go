package main

import "fmt"

func risesEqualsFalls(n int) bool {
    if n < 10 {
        return true
    }
    rises := 0
    falls := 0
    prev := -1
    for n > 0 {
        d := n % 10
        if prev >= 0 {
            if d < prev {
                rises = rises + 1
            } else if d > prev {
                falls = falls + 1
            }
        }
        prev = d
        n /= 10
    }
    return rises == falls
}

func main() {
    fmt.Println("The first 200 numbers in the sequence are:")
    count := 0
    n := 1
    for {
        if risesEqualsFalls(n) {
            count++
            if count <= 200 {
                fmt.Printf("%3d ", n)
                if count%20 == 0 {
                    fmt.Println()
                }
            }
            if count == 1e7 {
                fmt.Println("\nThe 10 millionth number in the sequence is ", n)
                break
            }
        }
        n++
    }
}
