package main

import "fmt"

type (
    seq  []int
    sofs []seq
)

func newSeq(start, end int) seq {
    if end < start {
        end = start
    }
    s := make(seq, end-start+1)
    for i := 0; i < len(s); i++ {
        s[i] = start + i
    }
    return s
}

func newSofs() sofs {
    return sofs{seq{}}
}

func (s sofs) listComp(in seq, expr func(sofs, seq) sofs, pred func(seq) bool) sofs {
    var s2 sofs
    for _, t := range expr(s, in) {
        if pred(t) {
            s2 = append(s2, t)
        }
    }
    return s2
}

func (s sofs) build(t seq) sofs {
    var u sofs
    for _, ss := range s {
        for _, tt := range t {
            uu := make(seq, len(ss))
            copy(uu, ss)
            uu = append(uu, tt)
            u = append(u, uu)
        }
    }
    return u
}

func main() {
    pt := newSofs()
    in := newSeq(1, 20)
    expr := func(s sofs, t seq) sofs {
        return s.build(t).build(t).build(t)
    }
    pred := func(t seq) bool {
        if len(t) != 3 {
            return false
        }
        return t[0]*t[0]+t[1]*t[1] == t[2]*t[2] && t[0] < t[1] && t[1] < t[2]
    }
    pt = pt.listComp(in, expr, pred)
    fmt.Println(pt)
}
