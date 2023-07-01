package main

import "fmt"

func pow(n int, e uint) int {
    if e == 0 {
        return 1
    }
    prod := n
    for i := uint(2); i <= e; i++ {
        prod *= n
    }
    return prod
}

func abs(n int) int {
    if n >= 0 {
        return n
    }
    return -n
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return " " + s
    }
    return "-" + s
}

func main() {
    prod := 1
    sum := 0
    const (
        x     = 5
        y     = -5
        z     = -2
        one   = 1
        three = 3
        seven = 7
    )
    p := pow(11, x)
    var j int

    process := func() {
        sum += abs(j)
        if abs(prod) < (1<<27) && j != 0 {
            prod *= j
        }
    }

    for j = -three; j <= pow(3, 3); j += three {
        process()
    }
    for j = -seven; j <= seven; j += x {
        process()
    }
    for j = 555; j <= 550-y; j++ {
        process()
    }
    for j = 22; j >= -28; j -= three {
        process()
    }
    for j = 1927; j <= 1939; j++ {
        process()
    }
    for j = x; j >= y; j -= -z {
        process()
    }
    for j = p; j <= p+one; j++ {
        process()
    }
    fmt.Println("sum  = ", commatize(sum))
    fmt.Println("prod = ", commatize(prod))
}
