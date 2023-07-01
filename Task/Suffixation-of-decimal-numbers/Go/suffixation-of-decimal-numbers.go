package main

import (
    "fmt"
    "math/big"
    "strconv"
    "strings"
)

var suffixes = " KMGTPEZYXWVU"
var ggl = googol()

func googol() *big.Float {
    g1 := new(big.Float).SetPrec(500)
    g1.SetInt64(10000000000)
    g := new(big.Float)
    g.Set(g1)
    for i := 2; i <= 10; i++ {
        g.Mul(g, g1)
    }
    return g
}

func suffize(arg string) {
    fields := strings.Fields(arg)
    a := fields[0]
    if a == "" {
        a = "0"
    }
    var places, base int
    var frac, radix string
    switch len(fields) {
    case 1:
        places = -1
        base = 10
    case 2:
        places, _ = strconv.Atoi(fields[1])
        base = 10
        frac = strconv.Itoa(places)
    case 3:
        if fields[1] == "," {
            places = 0
            frac = ","
        } else {
            places, _ = strconv.Atoi(fields[1])
            frac = strconv.Itoa(places)
        }
        base, _ = strconv.Atoi(fields[2])
        if base != 2 && base != 10 {
            base = 10
        }
        radix = strconv.Itoa(base)
    }
    a = strings.Replace(a, ",", "", -1) // get rid of any commas
    sign := ""
    if a[0] == '+' || a[0] == '-' {
        sign = string(a[0])
        a = a[1:] // remove any sign after storing it
    }
    b := new(big.Float).SetPrec(500)
    d := new(big.Float).SetPrec(500)
    b.SetString(a)
    g := false
    if b.Cmp(ggl) >= 0 {
        g = true
    }
    if !g && base == 2 {
        d.SetUint64(1024)
    } else if !g && base == 10 {
        d.SetUint64(1000)
    } else {
        d.Set(ggl)
    }
    c := 0
    for b.Cmp(d) >= 0 && c < 12 { // allow b >= 1K if c would otherwise exceed 12
        b.Quo(b, d)
        c++
    }
    var suffix string
    if !g {
        suffix = string(suffixes[c])
    } else {
        suffix = "googol"
    }
    if base == 2 {
        suffix += "i"
    }
    fmt.Println("   input number =", fields[0])
    fmt.Println("  fraction digs =", frac)
    fmt.Println("specified radix =", radix)
    fmt.Print("     new number = ")
    if places >= 0 {
        fmt.Printf("%s%.*f%s\n", sign, places, b, suffix)
    } else {
        fmt.Printf("%s%s%s\n", sign, b.Text('g', 50), suffix)
    }
    fmt.Println()
}

func main() {
    tests := []string{
        "87,654,321",
        "-998,877,665,544,332,211,000      3",
        "+112,233                          0",
        "16,777,216                        1",
        "456,789,100,000,000",
        "456,789,100,000,000               2      10",
        "456,789,100,000,000               5       2",
        "456,789,100,000.000e+00           0      10",
        "+16777216                         ,       2",
        "1.2e101",
        "446,835,273,728                   1",
        "1e36",
        "1e39", // there isn't a big enough suffix for this one but it's less than googol
    }
    for _, test := range tests {
        suffize(test)
    }
}
