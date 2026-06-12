package main

import (
    "fmt"
)

type RE interface {
    Equal(other RE) bool
    String() string
}

type Empty struct{}

func (e Empty) String() string {
    return "0"
}

func (e Empty) Equal(other RE) bool {
    _, ok := other.(Empty)
    return ok
}

type Epsilon struct{}

func (e Epsilon) String() string {
    return "1"
}

func (e Epsilon) Equal(other RE) bool {
    _, ok := other.(Epsilon)
    return ok
}

type Car struct {
    c string
}

func (e Car) String() string {
    return e.c
}

func (e Car) Equal(other RE) bool {
    o, ok := other.(Car)
    return ok && e.c == o.c
}

type Union struct {
    e RE
    f RE
}

func (u Union) String() string {
    return fmt.Sprintf("%s+%s", u.e.String(), u.f.String())
}

func (u Union) Equal(other RE) bool {
    o, ok := other.(Union)
    return ok && u.e.Equal(o.e) && u.f.Equal(o.f)
}

type Concat struct {
    e RE
    f RE
}

func (c Concat) String() string {
    return fmt.Sprintf("(%s)(%s)", c.e.String(), c.f.String())
}

func (c Concat) Equal(other RE) bool {
    o, ok := other.(Concat)
    return ok && c.e.Equal(o.e) && c.f.Equal(o.f)
}

type Star struct {
    e RE
}

func (s Star) String() string {
    return fmt.Sprintf("(%s)*", s.e.String())
}

func (s Star) Equal(other RE) bool {
    o, ok := other.(Star)
    return ok && s.e.Equal(o.e)
}

var empty Empty
var epsilon Epsilon

func simple_re(e RE) RE {
    for {
        new_e := simple(e)
        if new_e.Equal(e) {
            break
        }
        e = new_e
    }
    return e
}

func simple(e RE) RE {
    switch e := e.(type) {
    case Union:
        e_e := simple(e.e)
        e_f := simple(e.f)
        if e_e.Equal(e_f) {
            return e_e
        } else if e_e_union, ok := e_e.(Union); ok {
            return simple(Union{e_e_union.e, Union{e_e_union.f, e_f}})
        } else if e_e.Equal(empty) {
            return e_f
        } else if e_f.Equal(empty) {
            return e_e
        } else {
            return Union{e_e, e_f}
        }
    case Concat:
        e_e := simple(e.e)
        e_f := simple(e.f)
        if e_e.Equal(epsilon) {
            return e_f
        } else if e_f.Equal(epsilon) {
            return e_e
        } else if e_e.Equal(empty) || e_f.Equal(empty) {
            return empty
        } else if e_e_concat, ok := e_e.(Concat); ok {
            return simple(Concat{e_e_concat.e, Concat{e_e_concat.f, e_f}})
        } else {
            return Concat{e_e, e_f}
        }
    case Star:
        e_e := simple(e.e)
        if _, ok := e_e.(Empty); ok || e_e.Equal(epsilon) {
            return epsilon
        } else {
            return Star{e_e}
        }
    default:
        return e
    }
}

func brzozowski(a [][]RE, b []RE) RE {
    m := len(a)
    for n := m - 1; n >= 0; n-- {
        a_nn := a[n][n]
        b[n] = Concat{Star{a_nn}, b[n]}
        for j := 0; j < n; j++ {
            a[n][j] = Concat{Star{a_nn}, a[n][j]}
        }
        for i := 0; i < n; i++ {
            b[i] = Union{b[i], Concat{a[i][n], b[n]}}
            for j := 0; j < n; j++ {
                a[i][j] = Union{a[i][j], Concat{a[i][n], a[n][j]}}
            }
        }
        for i := 0; i < n; i++ {
            a[i][n] = empty
        }
    }
    return b[0]
}

func main() {
    a := [][]RE{
        {empty, Car{"a"}, Car{"b"}},
        {Car{"b"}, empty, Car{"a"}},
        {Car{"a"}, Car{"b"}, empty},
    }

    b := []RE{epsilon, empty, empty}

    re := brzozowski(a, b)
    fmt.Println(re.String())
    fmt.Println()
    fmt.Println(simple_re(re).String())
}
