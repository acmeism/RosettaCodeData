package main

import "fmt"

// a type that allows cyclic structures
type node []*node

// recursively print the contents of a node
func (n *node) list() {
    if n == nil {
        fmt.Println(n)
        return
    }
    listed := map[*node]bool{nil: true}
    var r func(*node)
    r = func(n *node) {
        listed[n] = true
        fmt.Printf("%p -> %v\n", n, *n)
        for _, m := range *n {
            if !listed[m] {
                r(m)
            }
        }
    }
    r(n)
}

// construct a deep copy of a node
func (n *node) ccopy() *node {
    if n == nil {
        return n
    }
    cc := map[*node]*node{nil: nil}
    var r func(*node) *node
    r = func(n *node) *node {
        c := make(node, len(*n))
        cc[n] = &c
        for i, m := range *n {
            d, ok := cc[m]
            if !ok {
                d = r(m)
            }
            c[i] = d
        }
        return &c
    }
    return r(n)
}

func main() {
    a := node{nil}
    c := &node{&node{&a}}
    a[0] = c
    c.list()
    cc := c.ccopy()
    fmt.Println("copy:")
    cc.list()
    fmt.Println("original:")
    c.list()
}
