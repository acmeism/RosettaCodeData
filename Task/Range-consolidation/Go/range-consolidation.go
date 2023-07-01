package main

import (
    "fmt"
    "math"
    "sort"
)

type Range struct{ Lower, Upper float64 }

func (r Range) Norm() Range {
    if r.Lower > r.Upper {
        return Range{r.Upper, r.Lower}
    }
    return r
}

func (r Range) String() string {
    return fmt.Sprintf("[%g, %g]", r.Lower, r.Upper)
}

func (r1 Range) Union(r2 Range) []Range {
    if r1.Upper < r2.Lower {
        return []Range{r1, r2}
    }
    r := Range{r1.Lower, math.Max(r1.Upper, r2.Upper)}
    return []Range{r}
}

func consolidate(rs []Range) []Range {
    for i := range rs {
        rs[i] = rs[i].Norm()
    }
    le := len(rs)
    if le < 2 {
        return rs
    }
    sort.Slice(rs, func(i, j int) bool {
        return rs[i].Lower < rs[j].Lower
    })
    if le == 2 {
        return rs[0].Union(rs[1])
    }
    for i := 0; i < le-1; i++ {
        for j := i + 1; j < le; j++ {
            ru := rs[i].Union(rs[j])
            if len(ru) == 1 {
                rs[i] = ru[0]
                copy(rs[j:], rs[j+1:])
                rs = rs[:le-1]
                le--
                i--
                break
            }
        }
    }
    return rs
}

func main() {
    rss := [][]Range{
        {{1.1, 2.2}},
        {{6.1, 7.2}, {7.2, 8.3}},
        {{4, 3}, {2, 1}},
        {{4, 3}, {2, 1}, {-1, -2}, {3.9, 10}},
        {{1, 3}, {-6, -1}, {-4, -5}, {8, 2}, {-6, -6}},
    }
    for _, rs := range rss {
        s := fmt.Sprintf("%v", rs)
        fmt.Printf("%40s => ", s[1:len(s)-1])
        rs2 := consolidate(rs)
        s = fmt.Sprintf("%v", rs2)
        fmt.Println(s[1 : len(s)-1])
    }
}
