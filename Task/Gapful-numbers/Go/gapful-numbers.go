package main

import "fmt"

func commatize(n uint64) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    starts := []uint64{1e2, 1e6, 1e7, 1e9, 7123}
    counts := []int{30, 15, 15, 10, 25}
    for i := 0; i < len(starts); i++ {
        count := 0
        j := starts[i]
        pow := uint64(100)
        for {
            if j < pow*10 {
                break
            }
            pow *= 10
        }
        fmt.Printf("First %d gapful numbers starting at %s:\n", counts[i], commatize(starts[i]))
        for count < counts[i] {
            fl := (j/pow)*10 + (j % 10)
            if j%fl == 0 {
                fmt.Printf("%d ", j)
                count++
            }
            j++
            if j >= 10*pow {
                pow *= 10
            }
        }
        fmt.Println("\n")
    }
}
