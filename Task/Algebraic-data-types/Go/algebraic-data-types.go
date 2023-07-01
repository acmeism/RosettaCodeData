package main

import "fmt"

type Color string

const (
    R Color = "R"
    B       = "B"
)

type Tree interface {
    ins(x int) Tree
}

type E struct{}

func (_ E) ins(x int) Tree {
    return T{R, E{}, x, E{}}
}

func (_ E) String() string {
    return "E"
}

type T struct {
    cl Color
    le Tree
    aa int
    ri Tree
}

func (t T) balance() Tree {
    if t.cl != B {
        return t
    }
    le, leIsT := t.le.(T)
    ri, riIsT := t.ri.(T)
    var lele, leri, rile, riri T
    var leleIsT, leriIsT, rileIsT, ririIsT bool
    if leIsT {
        lele, leleIsT = le.le.(T)
    }
    if leIsT {
        leri, leriIsT = le.ri.(T)
    }
    if riIsT {
        rile, rileIsT = ri.le.(T)
    }
    if riIsT {
        riri, ririIsT = ri.ri.(T)
    }
    switch {
    case leIsT && leleIsT && le.cl == R && lele.cl == R:
        _, t2, z, d := t.destruct()
        _, t3, y, c := t2.(T).destruct()
        _, a, x, b := t3.(T).destruct()
        return T{R, T{B, a, x, b}, y, T{B, c, z, d}}
    case leIsT && leriIsT && le.cl == R && leri.cl == R:
        _, t2, z, d := t.destruct()
        _, a, x, t3 := t2.(T).destruct()
        _, b, y, c := t3.(T).destruct()
        return T{R, T{B, a, x, b}, y, T{B, c, z, d}}
    case riIsT && rileIsT && ri.cl == R && rile.cl == R:
        _, a, x, t2 := t.destruct()
        _, t3, z, d := t2.(T).destruct()
        _, b, y, c := t3.(T).destruct()
        return T{R, T{B, a, x, b}, y, T{B, c, z, d}}
    case riIsT && ririIsT && ri.cl == R && riri.cl == R:
        _, a, x, t2 := t.destruct()
        _, b, y, t3 := t2.(T).destruct()
        _, c, z, d := t3.(T).destruct()
        return T{R, T{B, a, x, b}, y, T{B, c, z, d}}
    default:
        return t
    }
}

func (t T) ins(x int) Tree {
    switch {
    case x < t.aa:
        return T{t.cl, t.le.ins(x), t.aa, t.ri}.balance()
    case x > t.aa:
        return T{t.cl, t.le, t.aa, t.ri.ins(x)}.balance()
    default:
        return t
    }
}

func (t T) destruct() (Color, Tree, int, Tree) {
    return t.cl, t.le, t.aa, t.ri
}

func (t T) String() string {
    return fmt.Sprintf("T(%s, %v, %d, %v)", t.cl, t.le, t.aa, t.ri)
}

func insert(tr Tree, x int) Tree {
    t := tr.ins(x)
    switch t.(type) {
    case T:
        tt := t.(T)
        _, a, y, b := tt.destruct()
        return T{B, a, y, b}
    case E:
        return E{}
    default:
        return nil
    }
}

func main() {
    var tr Tree = E{}
    for i := 1; i <= 16; i++ {
        tr = insert(tr, i)
    }
    fmt.Println(tr)
}
