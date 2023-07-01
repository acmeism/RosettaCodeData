package main

import "fmt"

// 1st arg is the number to generate the sequence for.
// 2nd arg is a slice to recycle, to reduce garbage.
func hs(n int, recycle []int) []int {
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

func main() {
    seq := hs(27, nil)
    fmt.Printf("hs(27): %d elements: [%d %d %d %d ... %d %d %d %d]\n",
        len(seq), seq[0], seq[1], seq[2], seq[3],
        seq[len(seq)-4], seq[len(seq)-3], seq[len(seq)-2], seq[len(seq)-1])

    var maxN, maxLen int
    for n := 1; n < 100000; n++ {
        seq = hs(n, seq)
        if len(seq) > maxLen {
            maxN = n
            maxLen = len(seq)
        }
    }
    fmt.Printf("hs(%d): %d elements\n", maxN, maxLen)
}
