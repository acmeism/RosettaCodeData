package main

import (
    "fmt"
    "github.com/shabbyrobe/go-num"
    "strings"
    "time"
)

func b10(n int64) {
    if n == 1 {
        fmt.Printf("%4d: %28s  %-24d\n", 1, "1", 1)
        return
    }
    n1 := n + 1
    pow := make([]int64, n1)
    val := make([]int64, n1)
    var count, ten, x int64 = 0, 1, 1
    for ; x < n1; x++ {
        val[x] = ten
        for j := int64(0); j < n1; j++ {
            if pow[j] != 0 && pow[(j+ten)%n] == 0 && pow[j] != x {
                pow[(j+ten)%n] = x
            }
        }
        if pow[ten] == 0 {
            pow[ten] = x
        }
        ten = (10 * ten) % n
        if pow[0] != 0 {
            break
        }
    }
    x = n
    if pow[0] != 0 {
        s := ""
        for x != 0 {
            p := pow[x%n]
            if count > p {
                s += strings.Repeat("0", int(count-p))
            }
            count = p - 1
            s += "1"
            x = (n + x - val[p]) % n
        }
        if count > 0 {
            s += strings.Repeat("0", int(count))
        }
        mpm := num.MustI128FromString(s)
        mul := mpm.Quo64(n)
        fmt.Printf("%4d: %28s  %-24d\n", n, s, mul)
    } else {
        fmt.Println("Can't do it!")
    }
}

func main() {
    start := time.Now()
    tests := [][]int64{{1, 10}, {95, 105}, {297}, {576}, {594}, {891}, {909}, {999},
        {1998}, {2079}, {2251}, {2277}, {2439}, {2997}, {4878}}
    fmt.Println("   n                           B10  multiplier")
    fmt.Println("----------------------------------------------")
    for _, test := range tests {
        from := test[0]
        to := from
        if len(test) == 2 {
            to = test[1]
        }
        for n := from; n <= to; n++ {
            b10(n)
        }
    }
    fmt.Printf("\nTook %s\n", time.Since(start))
}
