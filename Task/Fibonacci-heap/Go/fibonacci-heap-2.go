package main

import (
    "fmt"

    "fib"
)

type str string

func (s str) LT(t fib.Value) bool { return s < t.(str) }

func main() {
    fmt.Println("MakeHeap:")
    h := fib.MakeHeap()
    h.Vis()

    fmt.Println("\nInsert:")
    h.Insert(str("cat"))
    h.Vis()

    fmt.Println("\nUnion:")
    h2 := fib.MakeHeap()
    h2.Insert(str("rat"))
    h.Union(h2)
    h.Vis()

    fmt.Println("\nMinimum:")
    m, _ := h.Minimum()
    fmt.Println(m)

    fmt.Println("\nExtractMin:")
    // add a couple more items to demonstrate parent-child linking that
    // happens on delete min.
    h.Insert(str("bat"))
    x := h.Insert(str("meerkat")) // save x for decrease key and delete demos
    m, _ = h.ExtractMin()
    fmt.Printf("(extracted %v)\n", m)
    h.Vis()

    fmt.Println("\nDecreaseKey:")
    h.DecreaseKey(x, str("gnat"))
    h.Vis()
    fmt.Println("\nDelete:")
    // add yet a couple more items to show how F&T's original delete was
    // lazier than CLRS's delete.
    h.Insert(str("bobcat"))
    h.Insert(str("bat"))
    fmt.Printf("(deleting %v)\n", x.Value())
    h.Delete(x)
    h.Vis()
}
