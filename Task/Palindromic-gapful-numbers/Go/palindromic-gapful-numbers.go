package main

import "fmt"

func reverse(s uint64) uint64 {
    e := uint64(0)
    for s > 0 {
        e = e*10 + (s % 10)
        s /= 10
    }
    return e
}

func commatize(n uint) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func ord(n uint) string {
    var suffix string
    if n > 10 && ((n-11)%100 == 0 || (n-12)%100 == 0 || (n-13)%100 == 0) {
        suffix = "th"
    } else {
        switch n % 10 {
        case 1:
            suffix = "st"
        case 2:
            suffix = "nd"
        case 3:
            suffix = "rd"
        default:
            suffix = "th"
        }
    }
    return fmt.Sprintf("%s%s", commatize(n), suffix)
}

func main() {
    const max = 10_000_000
    data := [][3]uint{{1, 20, 7}, {86, 100, 8}, {991, 1000, 10}, {9995, 10000, 12}, {1e5, 1e5, 14},
        {1e6, 1e6, 16}, {1e7, 1e7, 18}}
    results := make(map[uint][]uint64)
    for _, d := range data {
        for i := d[0]; i <= d[1]; i++ {
            results[i] = make([]uint64, 9)
        }
    }
    var p uint64
outer:
    for d := uint64(1); d < 10; d++ {
        count := uint(0)
        pow := uint64(1)
        fl := d * 11
        for nd := 3; nd < 20; nd++ {
            slim := (d + 1) * pow
            for s := d * pow; s < slim; s++ {
                e := reverse(s)
                mlim := uint64(1)
                if nd%2 == 1 {
                    mlim = 10
                }
                for m := uint64(0); m < mlim; m++ {
                    if nd%2 == 0 {
                        p = s*pow*10 + e
                    } else {
                        p = s*pow*100 + m*pow*10 + e
                    }
                    if p%fl == 0 {
                        count++
                        if _, ok := results[count]; ok {
                            results[count][d-1] = p
                        }
                        if count == max {
                            continue outer
                        }
                    }
                }
            }
            if nd%2 == 1 {
                pow *= 10
            }
        }
    }

    for _, d := range data {
        if d[0] != d[1] {
            fmt.Printf("%s to %s palindromic gapful numbers (> 100) ending with:\n", ord(d[0]), ord(d[1]))
        } else {
            fmt.Printf("%s palindromic gapful number (> 100) ending with:\n", ord(d[0]))
        }
        for i := 1; i <= 9; i++ {
            fmt.Printf("%d: ", i)
            for j := d[0]; j <= d[1]; j++ {
                fmt.Printf("%*d ", d[2], results[j][i-1])
            }
            fmt.Println()
        }
        fmt.Println()
    }
}
