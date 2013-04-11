package main

import "fmt"

func hs(n int, seq *[]int) {
    s := append((*seq)[:0], n)
    for n > 1 {
        if n&1 == 0 {
            n = n / 2
        } else {
            n = 3*n + 1
        }
        s = append(s, n)
    }
    *seq = s
}

func main() {
    var seq []int

    hs(27, &seq)
    fmt.Printf("hs(27): %d elements: [%d %d %d %d ... %d %d %d %d]\n",
        len(seq), seq[0], seq[1], seq[2], seq[3],
        seq[len(seq)-4], seq[len(seq)-3], seq[len(seq)-2], seq[len(seq)-1])

    var maxN, maxLen int
    for n := 1; n < 100000; n++ {
        // reusing seq reduces garbage
        hs(n, &seq)
        if len(seq) > maxLen {
            maxN = n
            maxLen = len(seq)
        }
    }
    fmt.Printf("hs(%d): %d elements\n", maxN, maxLen)
}
