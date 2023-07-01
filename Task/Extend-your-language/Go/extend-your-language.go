package main

import "fmt"

type F func()

type If2 struct {cond1, cond2 bool}

func (i If2) else1(f F) If2 {
    if i.cond1 && !i.cond2 {
        f()
    }
    return i
}

func (i If2) else2(f F) If2 {
    if i.cond2 && !i.cond1 {
        f()
    }
    return i
}

func (i If2) else0(f F) If2 {
    if !i.cond1 && !i.cond2 {
        f()
    }
    return i
}

func if2(cond1, cond2 bool, f F) If2 {
    if cond1 && cond2 {
        f()
    }
    return If2{cond1, cond2}
}

func main() {
    a, b := 0, 1
    if2 (a == 1, b == 3, func() {
        fmt.Println("a = 1 and b = 3")
    }).else1 (func() {
        fmt.Println("a = 1 and b <> 3")
    }).else2 (func() {
        fmt.Println("a <> 1 and b = 3")
    }).else0 (func() {
        fmt.Println("a <> 1 and b <> 3")
    })

    // It's also possible to omit any (or all) of the 'else' clauses or to call them out of order
    a, b = 1, 0
    if2 (a == 1, b == 3, func() {
        fmt.Println("a = 1 and b = 3")
    }).else0 (func() {
        fmt.Println("a <> 1 and b <> 3")
    }).else1 (func() {
        fmt.Println("a = 1 and b <> 3")
    })
}
