// hailstone.go
package main

import "fmt"

func main() {
    freq := make(map[int]int)
    for i := 1; i < 100000; i++ {
        freq[len(hailstone(i, nil))]++
    }
    var mk, mv int
    for k, v := range freq {
        if v > mv {
            mk = k
            mv = v
        }
    }
    fmt.Printf("\nThe Hailstone length returned most is %d, which occurs %d times.\n", mk, mv)
}
