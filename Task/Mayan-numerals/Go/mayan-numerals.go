package main

import (
    "fmt"
    "strconv"
)

const (
    ul = "╔"
    uc = "╦"
    ur = "╗"
    ll = "╚"
    lc = "╩"
    lr = "╝"
    hb = "═"
    vb = "║"
)

var mayan = [5]string{
    "    ",
    " ∙  ",
    " ∙∙ ",
    "∙∙∙ ",
    "∙∙∙∙",
}

const (
    m0 = " Θ  "
    m5 = "────"
)

func dec2vig(n uint64) []uint64 {
    vig := strconv.FormatUint(n, 20)
    res := make([]uint64, len(vig))
    for i, d := range vig {
        res[i], _ = strconv.ParseUint(string(d), 20, 64)
    }
    return res
}

func vig2quin(n uint64) [4]string {
    if n >= 20 {
        panic("Cant't convert a number >= 20")
    }
    res := [4]string{mayan[0], mayan[0], mayan[0], mayan[0]}
    if n == 0 {
        res[3] = m0
        return res
    }
    fives := n / 5
    rem := n % 5
    res[3-fives] = mayan[rem]
    for i := 3; i > 3-int(fives); i-- {
        res[i] = m5
    }
    return res
}

func draw(mayans [][4]string) {
    lm := len(mayans)
    fmt.Print(ul)
    for i := 0; i < lm; i++ {
        for j := 0; j < 4; j++ {
            fmt.Print(hb)
        }
        if i < lm-1 {
            fmt.Print(uc)
        } else {
            fmt.Println(ur)
        }
    }
    for i := 1; i < 5; i++ {
        fmt.Print(vb)
        for j := 0; j < lm; j++ {
            fmt.Print(mayans[j][i-1])
            fmt.Print(vb)
        }
        fmt.Println()
    }
    fmt.Print(ll)
    for i := 0; i < lm; i++ {
        for j := 0; j < 4; j++ {
            fmt.Print(hb)
        }
        if i < lm-1 {
            fmt.Print(lc)
        } else {
            fmt.Println(lr)
        }
    }
}

func main() {
    numbers := []uint64{4005, 8017, 326205, 886205, 1081439556}
    for _, n := range numbers {
        fmt.Printf("Converting %d to Mayan:\n", n)
        vigs := dec2vig(n)
        lv := len(vigs)
        mayans := make([][4]string, lv)
        for i, vig := range vigs {
            mayans[i] = vig2quin(vig)
        }
        draw(mayans)
        fmt.Println()
    }
}
