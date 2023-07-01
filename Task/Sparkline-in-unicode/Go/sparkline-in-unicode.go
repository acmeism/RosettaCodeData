package main

import (
    "bufio"
    "errors"
    "fmt"
    "math"
    "os"
    "regexp"
    "strconv"
    "strings"
)

func main() {
    fmt.Println("Numbers please separated by space/commas:")
    sc := bufio.NewScanner(os.Stdin)
    sc.Scan()
    s, n, min, max, err := spark(sc.Text())
    if err != nil {
        fmt.Println(err)
        return
    }
    if n == 1 {
        fmt.Println("1 value =", min)
    } else {
        fmt.Println(n, "values.  Min:", min, "Max:", max)
    }
    fmt.Println(s)
}

var sep = regexp.MustCompile(`[\s,]+`)

func spark(s0 string) (sp string, n int, min, max float64, err error) {
    ss := sep.Split(s0, -1)
    n = len(ss)
    vs := make([]float64, n)
    var v float64
    min = math.Inf(1)
    max = math.Inf(-1)
    for i, s := range ss {
        switch v, err = strconv.ParseFloat(s, 64); {
        case err != nil:
        case math.IsNaN(v):
            err = errors.New("NaN not supported.")
        case math.IsInf(v, 0):
            err = errors.New("Inf not supported.")
        default:
            if v < min {
                min = v
            }
            if v > max {
                max = v
            }
            vs[i] = v
            continue
        }
        return
    }
    if min == max {
        sp = strings.Repeat("▄", n)
    } else {
        rs := make([]rune, n)
        f := 8 / (max - min)
        for j, v := range vs {
            i := rune(f * (v - min))
            if i > 7 {
                i = 7
            }
            rs[j] = '▁' + i
        }
        sp = string(rs)
    }
    return
}
