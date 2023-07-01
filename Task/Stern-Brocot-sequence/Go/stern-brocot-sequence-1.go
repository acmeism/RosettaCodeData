package main

import (
    "fmt"

    "sternbrocot"
)

func main() {
    // Task 1, using the conventional sort of generator that generates
    // terms endlessly.
    g := sb.Generator()

    // Task 2, demonstrating the generator.
    fmt.Println("First 15:")
    for i := 1; i <= 15; i++ {
        fmt.Printf("%2d:  %d\n", i, g())
    }

    // Task 2 again, showing a simpler technique that might or might not be
    // considered to "generate" terms.
    s := sb.New()
    fmt.Println("First 15:", s.FirstN(15))

    // Tasks 3 and 4.
    for _, x := range []int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 100} {
        fmt.Printf("%3d at 1-based index %d\n", x, 1+s.Find(x))
    }

    // Task 5.
    fmt.Println("1-based indexes: gcd")
    for n, f := range s.FirstN(1000)[:999] {
        g := gcd(f, (*s)[n+1])
        fmt.Printf("%d,%d: gcd(%d, %d) = %d\n", n+1, n+2, f, (*s)[n+1], g)
        if g != 1 {
            panic("oh no!")
            return
        }
    }
}

// gcd copied from greatest common divisor task
func gcd(x, y int) int {
    for y != 0 {
        x, y = y, x%y
    }
    return x
}
