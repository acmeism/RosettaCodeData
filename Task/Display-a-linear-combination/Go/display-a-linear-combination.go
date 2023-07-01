package main

import (
    "fmt"
    "strings"
)

func linearCombo(c []int) string {
    var sb strings.Builder
    for i, n := range c {
        if n == 0 {
            continue
        }
        var op string
        switch {
        case n < 0 && sb.Len() == 0:
            op = "-"
        case n < 0:
            op = " - "
        case n > 0 && sb.Len() == 0:
            op = ""
        default:
            op = " + "
        }
        av := n
        if av < 0 {
            av = -av
        }
        coeff := fmt.Sprintf("%d*", av)
        if av == 1 {
            coeff = ""
        }
        sb.WriteString(fmt.Sprintf("%s%se(%d)", op, coeff, i+1))
    }
    if sb.Len() == 0 {
        return "0"
    } else {
        return sb.String()
    }
}

func main() {
    combos := [][]int{
        {1, 2, 3},
        {0, 1, 2, 3},
        {1, 0, 3, 4},
        {1, 2, 0},
        {0, 0, 0},
        {0},
        {1, 1, 1},
        {-1, -1, -1},
        {-1, -2, 0, -3},
        {-1},
    }
    for _, c := range combos {
        t := strings.Replace(fmt.Sprint(c), " ", ", ", -1)
        fmt.Printf("%-15s  ->  %s\n", t, linearCombo(c))
    }
}
