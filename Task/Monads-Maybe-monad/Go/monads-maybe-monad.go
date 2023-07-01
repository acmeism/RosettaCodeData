package main

import (
    "fmt"
    "strconv"
)

type maybe struct{ value *int }

func (m maybe) bind(f func(p *int) maybe) maybe {
    return f(m.value)
}

func unit(p *int) maybe {
    return maybe{p}
}

func decrement(p *int) maybe {
    if p == nil {
        return unit(nil)
    } else {
        q := *p - 1
        return unit(&q)
    }
}

func triple(p *int) maybe {
    if p == nil {
        return unit(nil)
    } else {
        q := (*p) * 3
        return unit(&q)
    }
}

func main() {
    i, j, k := 3, 4, 5
    for _, p := range []*int{&i, &j, nil, &k} {
        m1 := unit(p)
        m2 := m1.bind(decrement).bind(triple)
        var s1, s2 string = "none", "none"
        if m1.value != nil {
            s1 = strconv.Itoa(*m1.value)
        }
        if m2.value != nil {
            s2 = strconv.Itoa(*m2.value)
        }
        fmt.Printf("%4s -> %s\n", s1, s2)
    }
}
