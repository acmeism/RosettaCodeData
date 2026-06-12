package main

import (
    "fmt"
    "log"
    "math"
    "regexp"
    "strconv"
    "strings"
)

var powers = strings.NewReplacer(
    "0", "⁰",
    "1", "¹",
    "2", "²",
    "3", "³",
    "4", "⁴",
    "5", "⁵",
    "6", "⁶",
    "7", "⁷",
    "8", "⁸",
    "9", "⁹",
    "-", "⁻",
)

var fractions = [][2]string{
    {".25", "¼"},
    {".5", "½"},
    {".75", "¾"},
    {".14285714285714285", "⅐"},
    {".1111111111111111", "⅑"},
    {".1", "⅒"},
    {".3333333333333333", "⅓"},
    {".6666666666666666", "⅔"},
    {".2", "⅕"},
    {".4", "⅖"},
    {".6", "⅗"},
    {".8", "⅘"},
    {".16666666666666666", "⅙"},
    {".8333333333333334", "⅚"},
    {".125", "⅛"},
    {".375", "⅜"},
    {".625", "⅝"},
    {".875", "⅞"},
}

func printEquation(coefs map[int]float64) {
    fmt.Print("=> ")
    if len(coefs) == 0 {
        fmt.Println("0\n")
        return
    }
    max, min := math.MinInt32, math.MaxInt32
    for k := range coefs {
        if k > max {
            max = k
        }
        if k < min {
            min = k
        }
    }
    for p := max; p >= min; p-- {
        if c := coefs[p]; c != 0 {
            if p < max {
                sign := "+"
                if c < 0 {
                    sign = "-"
                    c = -c
                }
                fmt.Printf(" %s ", sign)
            }
            if c != 1 || (c == 1 && p == 0) {
                cs := fmt.Sprintf("%v", c)
                ix := strings.Index(cs, ".")
                if ix >= 0 {
                    dec := cs[ix:]
                    for _, frac := range fractions {
                        if dec == frac[0] {
                            cs = strings.Replace(cs, dec, frac[1], 1)
                            break
                        }
                    }
                }
                if cs[0] == '0' && len(cs) > 1 && cs[1] != '.' {
                    cs = cs[1:]
                }
                fmt.Print(cs)
            }
            if p != 0 {
                ps := strconv.Itoa(p)
                ps = powers.Replace(ps)
                if ps == "¹" {
                    ps = ""
                }
                fmt.Printf("x%s", ps)
            }
        }
    }
    fmt.Println("\n")
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    equs := []string{
        `-0.00x⁺¹⁰ + 1.0·x ** 5 + -2e0x^4 + +0,042.00 × x ⁺³ + +.0x² + 20.000 000 000x¹ - -1x⁺⁰ + .0x⁻¹ + 20.x¹`,
        `x⁵ - 2x⁴ + 42x³ + 0x² + 40x + 1`,
        `0e+0x⁰⁰⁷ + 00e-00x + 0x + .0x⁰⁵ - 0.x⁴ + 0×x³ + 0x⁻⁰ + 0/x + 0/x³ + 0x⁻⁵`,
        `1x⁵ - 2x⁴ + 42x³ + 40x + 1x⁰`,
        `+x⁺⁵ + -2x⁻⁻⁴ + 42x⁺⁺³ + +40x - -1`,
        `x^5 - 2x**4 + 42x^3 + 40x + 1`,
        `x↑5 - 2.00·x⁴ + 42.00·x³ + 40.00·x + 1`,
        `x⁻⁵ - 2⁄x⁴ + 42x⁻³ + 40/x + 1x⁻⁰`,
        `x⁵ - 2x⁴ + 42.000 000x³ + 40x + 1`,
        `x⁵ - 2x⁴ + 0,042x³ + 40.000,000x + 1`,
        `0x⁷ + 10x + 10x + x⁵ - 2x⁴ + 42x³ + 20x + 1`,
        `1E0x⁵ - 2,000,000.e-6x⁴ + 4.2⏨1x³ + .40e+2x + 1`,
        `x⁵ - x⁴⁄2 + 405x³⁄4 + 403x⁄4 + 5⁄2`,
        `x⁵ - 0.5x⁴ + 101.25x³ + 100.75x + 2.5`,
        `x⁻⁵ - 2⁄x⁴ + 42x⁻³ - 40/x`,
        `⅐x⁵ - ⅓x⁴ - ⅔x⁴ + 42⅕x³ + ⅑x - 40⅛ - ⅝`,
    }
    rgx := regexp.MustCompile(`\s+(\+|-)\s+`)
    rep := strings.NewReplacer(
        ",", "",
        " ", "",
        "¼", ".25",
        "½", ".5",
        "¾", ".75",
        "⅐", ".14285714285714285",
        "⅑", ".1111111111111111",
        "⅒", ".1",
        "⅓", ".3333333333333333",
        "⅔", ".6666666666666666",
        "⅕", ".2",
        "⅖", ".4",
        "⅗", ".6",
        "⅘", ".8",
        "⅙", ".16666666666666666",
        "⅚", ".8333333333333334",
        "⅛", ".125",
        "⅜", ".375",
        "⅝", ".625",
        "⅞", ".875",
        "↉", ".0",
        "⏨", "e",
        "⁄", "/",
    )
    rep2 := strings.NewReplacer(
        "⁰", "0",
        "¹", "1",
        "²", "2",
        "³", "3",
        "⁴", "4",
        "⁵", "5",
        "⁶", "6",
        "⁷", "7",
        "⁸", "8",
        "⁹", "9",
        "⁻⁻", "",
        "⁻", "-",
        "⁺", "",
        "**", "",
        "^", "",
        "↑", "",
        "⁄", "/",
    )
    var err error
    for _, equ := range equs {
        fmt.Println(equ)
        terms := rgx.Split(equ, -1)
        ops := rgx.FindAllString(equ, -1)
        for i := 0; i < len(ops); i++ {
            ops[i] = strings.TrimSpace(ops[i])
        }
        coefs := make(map[int]float64)
        for i, term := range terms {
            s := strings.Split(term, "x")
            t := s[0]
            t = strings.TrimRight(t, "·× ")
            t = rep.Replace(t)
            c := 1.0
            inverse := false
            if t == "" || t == "+" || t == "-" {
                t += "1"
            }
            ix := strings.Index(t, "/")
            if ix == len(t)-1 {
                inverse = true
                t = t[0 : len(t)-1]
                c, err = strconv.ParseFloat(t, 64)
                check(err)
            } else if ix >= 0 {
                u := strings.Split(t, "/")
                m, err := strconv.ParseFloat(u[0], 64)
                check(err)
                n, err := strconv.ParseFloat(u[1], 64)
                check(err)
                c = m / n
            } else {
                c, err = strconv.ParseFloat(t, 64)
                check(err)
            }
            if i > 0 && ops[i-1] == "-" {
                c = -c
            }
            if c == -0.0 {
                c = 0
            }
            if len(s) == 1 {
                coefs[0] += c
                continue
            }
            u := s[1]
            u = strings.TrimSpace(u)
            if u == "" {
                p := 1
                if inverse {
                    p = -1
                }
                if c != 0 {
                    coefs[p] += c
                }
                continue
            }
            u = rep2.Replace(u)
            jx := strings.Index(u, "/")
            p := 1
            if jx >= 0 {
                v := strings.Split(u, "/")
                p, err = strconv.Atoi(v[0])
                if (err != nil) {
                    p = 1
                }
                d, err := strconv.ParseFloat(v[1], 64)
                check(err)
                c /= d
            } else {
                p, err = strconv.Atoi(strings.TrimSpace(u))
                if (err != nil) {
                    p = 1
                }
            }
            if inverse {
                p = -p
            }
            if c != 0 {
                coefs[p] += c
            }
        }
        printEquation(coefs)
    }
}
