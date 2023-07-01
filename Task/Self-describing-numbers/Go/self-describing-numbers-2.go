package main

import (
    "fmt"
    "strconv"
    "strings"
    "time"
)

func selfDesc(n uint64) bool {
    if n >= 1e10 {
        return false
    }
    s := strconv.FormatUint(n, 10)
    for d, p := range s {
        if int(p)-'0' != strings.Count(s, strconv.Itoa(d)) {
            return false
        }
    }
    return true
}

func main() {
    start := time.Now()
    fmt.Println("The self-describing numbers are:")
    i := uint64(10)   // self-describing number must end in 0
    pw := uint64(10)  // power of 10
    fd := uint64(1)   // first digit
    sd := uint64(1)   // second digit
    dg := uint64(2)   // number of digits
    mx := uint64(11)  // maximum for current batch
    lim := uint64(9_100_000_001) // sum of digits can't be more than 10
    for i < lim {
        if selfDesc(i) {
            secs := time.Since(start).Seconds()
            fmt.Printf("%d (in %.1f secs)\n", i, secs)
        }
        i += 10
        if i > mx {
            fd++
            sd--
            if sd >= 0 {
                i = fd * pw
            } else {
                pw *= 10
                dg++
                i = pw
                fd = 1
                sd = dg - 1
            }
            mx = i + sd*pw/10
        }
    }
    osecs := time.Since(start).Seconds()
    fmt.Printf("\nTook %.1f secs overall\n", osecs)
}
