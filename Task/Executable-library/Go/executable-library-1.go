// modulino.go
package main

import "fmt"

// Function borrowed from Hailstone sequence task.
// 1st arg is the number to generate the sequence for.
// 2nd arg is a slice to recycle, to reduce garbage.
func hailstone(n int, recycle []int) []int {
    s := append(recycle[:0], n)
    for n > 1 {
        if n&1 == 0 {
            n = n / 2
        } else {
            n = 3*n + 1
        }
        s = append(s, n)
    }
    return s
}

func libMain() {
    seq := hailstone(27, nil)
    fmt.Println("\nHailstone sequence for the number 27:")
    fmt.Println("  has", len(seq), "elements")
    fmt.Println("  starts with", seq[0:4])
    fmt.Println("  ends with", seq[len(seq)-4:])

    var longest, length int
    for i := 1; i < 100000; i++ {
        if le := len(hailstone(i, nil)); le > length {
            longest = i
            length = le
        }
    }
    fmt.Printf("\n%d has the longest Hailstone sequence, its length being %d.\n", longest, length)
}
