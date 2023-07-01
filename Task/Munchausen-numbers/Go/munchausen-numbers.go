package main

import(
    "fmt"
    "math"
)

var powers [10]int

func isMunchausen(n int) bool {
    if n < 0 { return false }
    n64 := int64(n)
    nn  := n64
    var sum int64 = 0
    for nn > 0 {
        sum += int64(powers[nn % 10])
        if sum > n64 { return false }
        nn /= 10
    }
    return sum == n64
}

func main() {
    // cache n ^ n for n in 0..9, defining 0 ^ 0 = 0 for this purpose
    for i := 1; i <= 9; i++ {
        d := float64(i)
        powers[i] = int(math.Pow(d, d))
    }

    // check numbers 0 to 500 million
    fmt.Println("The Munchausen numbers between 0 and 500 million are:")
    for i := 0; i <= 500000000; i++ {
        if isMunchausen(i) { fmt.Printf("%d ", i) }
    }
    fmt.Println()
}
