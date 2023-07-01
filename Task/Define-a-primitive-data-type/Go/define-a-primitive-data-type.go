package main

import "fmt"

type TinyInt int

func NewTinyInt(i int) TinyInt {
    if i < 1 {
        i = 1
    } else if i > 10 {
        i = 10
    }
    return TinyInt(i)
}

func (t1 TinyInt) Add(t2 TinyInt) TinyInt {
    return NewTinyInt(int(t1) + int(t2))
}

func (t1 TinyInt) Sub(t2 TinyInt) TinyInt {
    return NewTinyInt(int(t1) - int(t2))
}

func (t1 TinyInt) Mul(t2 TinyInt) TinyInt {
    return NewTinyInt(int(t1) * int(t2))
}

func (t1 TinyInt) Div(t2 TinyInt) TinyInt {
    return NewTinyInt(int(t1) / int(t2))
}

func (t1 TinyInt) Rem(t2 TinyInt) TinyInt {
    return NewTinyInt(int(t1) % int(t2))
}

func (t TinyInt) Inc() TinyInt {
    return t.Add(TinyInt(1))
}

func (t TinyInt) Dec() TinyInt {
    return t.Sub(TinyInt(1))
}

func main() {
    t1 := NewTinyInt(6)
    t2 := NewTinyInt(3)
    fmt.Println("t1      =", t1)
    fmt.Println("t2      =", t2)
    fmt.Println("t1 + t2 =", t1.Add(t2))
    fmt.Println("t1 - t2 =", t1.Sub(t2))
    fmt.Println("t1 * t2 =", t1.Mul(t2))
    fmt.Println("t1 / t2 =", t1.Div(t2))
    fmt.Println("t1 % t2 =", t1.Rem(t2))
    fmt.Println("t1 + 1  =", t1.Inc())
    fmt.Println("t1 - 1  =", t1.Dec())
}
