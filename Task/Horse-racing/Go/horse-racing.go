package main

import (
    "fmt"
    "sort"
    "strings"
)

func main() {
    // ratings on past form, assuming a rating of 100 for horse A
    a := 100
    b := a - 8 - 2*2 // carried 8 lbs less, finished 2 lengths behind
    c := a + 4 - 2*3.5
    d := a - 4 - 10*0.4 // based on relative weight and time
    e := d + 7 - 2*1
    f := d + 11 - 2*(4-2)
    g := a - 10 + 10*0.2
    h := g + 6 - 2*1.5
    i := g + 15 - 2*2

    // adjustments to ratings for current race
    b += 4
    c -= 4
    h += 3
    j := a - 3 + 10*0.2

    // filly's allowance to give weight adjusted weighting
    b += 3
    d += 3
    i += 3
    j += 3

    // create map of horse to its weight adjusted rating and whether colt (1 == yes, 0 == no)
    m := map[string][2]int{
        "A": {a, 1},
        "B": {b, 0},
        "C": {c, 1},
        "D": {d, 0},
        "E": {e, 1},
        "F": {f, 1},
        "G": {g, 1},
        "H": {h, 1},
        "I": {i, 0},
        "J": {j, 0},
    }

    type kv struct {
        key   string
        value [2]int
    }

    // convert to slice of kv
    l := make([]kv, len(m))
    x := 0
    for k, v := range m {
        l[x] = kv{k, v}
        x++
    }

    // sort in descending order of rating
    sort.Slice(l, func(i, j int) bool { return l[i].value[0] > l[j].value[0] })

    // show expected result of race
    fmt.Println("Race 4\n")
    fmt.Println("Pos Horse  Weight  Dist  Sex")
    pos := ""
    for x := 0; x < len(l); x++ {
        wt := "9.00"
        if l[x].value[1] == 0 {
            wt = "8.11"
        }
        dist := 0.0
        if x > 0 {
            dist = float64(l[x-1].value[0]-l[x].value[0]) * 0.5
        }
        if x == 0 || dist > 0.0 {
            pos = fmt.Sprintf("%d", x+1)
        } else if !strings.HasSuffix(pos, "=") {
            pos = fmt.Sprintf("%d=", x)
        }
        sx := "colt"
        if l[x].value[1] == 0 {
            sx = "filly"
        }
        fmt.Printf("%-2s  %s      %s    %3.1f   %s\n", pos, l[x].key, wt, dist, sx)
    }

    // weight adjusted rating of winner
    wr := float64(l[0].value[0])

    // expected time of winner (relative to A's time in Race 1)
    t := 96.0 - (wr-100)/10
    min := int(t / 60)
    sec := t - float64(min)*60
    fmt.Printf("\nTime %d minute %3.1f seconds\n", min, sec)
}
