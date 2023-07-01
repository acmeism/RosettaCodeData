package main

import "fmt"

// flat, level-order representation.
// for node at index k, left child has index 2k, right child has index 2k+1.
// a value of -1 means the node does not exist.
type tree []int

func main() {
    t := tree{1, 2, 3, 4, 5, 6, -1, 7, -1, -1, -1, 8, 9}
    visitor := func(n int) {
        fmt.Print(n, " ")
    }
    fmt.Print("preorder:    ")
    t.iterPreorder(visitor)
    fmt.Print("\ninorder:     ")
    t.iterInorder(visitor)
    fmt.Print("\npostorder:   ")
    t.iterPostorder(visitor)
    fmt.Print("\nlevel-order: ")
    t.iterLevelorder(visitor)
    fmt.Println()
}

func (t tree) iterPreorder(visit func(int)) {
    var traverse func(int)
    traverse = func(k int) {
        if k >= len(t) || t[k] == -1 {
            return
        }
        visit(t[k])
        traverse(2*k + 1)
        traverse(2*k + 2)
    }
    traverse(0)
}

func (t tree) iterInorder(visit func(int)) {
    var traverse func(int)
    traverse = func(k int) {
        if k >= len(t) || t[k] == -1 {
            return
        }
        traverse(2*k + 1)
        visit(t[k])
        traverse(2*k + 2)
    }
    traverse(0)
}

func (t tree) iterPostorder(visit func(int)) {
    var traverse func(int)
    traverse = func(k int) {
        if k >= len(t) || t[k] == -1 {
            return
        }
        traverse(2*k + 1)
        traverse(2*k + 2)
        visit(t[k])
    }
    traverse(0)
}

func (t tree) iterLevelorder(visit func(int)) {
    for _, n := range t {
        if n != -1 {
            visit(n)
        }
    }
}
