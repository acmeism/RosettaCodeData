package fib

import "fmt"

type Value interface {
    LT(Value) bool
}

type Node struct {
    value      Value
    parent     *Node
    child      *Node
    prev, next *Node
    rank       int
    mark       bool
}

func (n Node) Value() Value { return n.value }

type Heap struct{ *Node }

// task requirement
func MakeHeap() *Heap { return &Heap{} }

// task requirement
func (h *Heap) Insert(v Value) *Node {
    x := &Node{value: v}
    if h.Node == nil {
        x.next = x
        x.prev = x
        h.Node = x
    } else {
        meld1(h.Node, x)
        if x.value.LT(h.value) {
            h.Node = x
        }
    }
    return x
}

func meld1(list, single *Node) {
    list.prev.next = single
    single.prev = list.prev
    single.next = list
    list.prev = single
}

// task requirement
func (h *Heap) Union(h2 *Heap) {
    switch {
    case h.Node == nil:
        *h = *h2
    case h2.Node != nil:
        meld2(h.Node, h2.Node)
        if h2.value.LT(h.value) {
            *h = *h2
        }
    }
    h2.Node = nil
}

func meld2(a, b *Node) {
    a.prev.next = b
    b.prev.next = a
    a.prev, b.prev = b.prev, a.prev
}

// task requirement
func (h Heap) Minimum() (min Value, ok bool) {
    if h.Node == nil {
        return
    }
    return h.value, true
}

// task requirement
func (h *Heap) ExtractMin() (min Value, ok bool) {
    if h.Node == nil {
        return
    }
    min = h.value
    roots := map[int]*Node{}
    add := func(r *Node) {
        r.prev = r
        r.next = r
        for {
            x, ok := roots[r.rank]
            if !ok {
               break
            }
            delete(roots, r.rank)
            if x.value.LT(r.value) {
                r, x = x, r
            }
            x.parent = r
            x.mark = false
            if r.child == nil {
                x.next = x
                x.prev = x
                r.child = x
            } else {
                meld1(r.child, x)
            }
            r.rank++
        }
        roots[r.rank] = r
    }
    for r := h.next; r != h.Node; {
        n := r.next
        add(r)
        r = n
    }
    if c := h.child; c != nil {
        c.parent = nil
        r := c.next
        add(c)
        for r != c {
            n := r.next
            r.parent = nil
            add(r)
            r = n
        }
    }
    if len(roots) == 0 {
        h.Node = nil
        return min, true
    }
    var mv *Node
    var d int
    for d, mv = range roots {
        break
    }
    delete(roots, d)
    mv.next = mv
    mv.prev = mv
    for _, r := range roots {
        r.prev = mv
        r.next = mv.next
        mv.next.prev = r
        mv.next = r
        if r.value.LT(mv.value) {
            mv = r
        }
    }
    h.Node = mv
    return min, true
}

// task requirement
func (h *Heap) DecreaseKey(n *Node, v Value) error {
    if n.value.LT(v) {
        return fmt.Errorf("DecreaseKey new value greater than existing value")
    }
    n.value = v
    if n == h.Node {
        return nil
    }
    p := n.parent
    if p == nil {
        if v.LT(h.value) {
            h.Node = n
        }
        return nil
    }
    h.cutAndMeld(n)
    return nil
}

func (h Heap) cut(x *Node) {
    p := x.parent
    p.rank--
    if p.rank == 0 {
        p.child = nil
    } else {
        p.child = x.next
        x.prev.next = x.next
        x.next.prev = x.prev
    }
    if p.parent == nil {
        return
    }
    if !p.mark {
        p.mark = true
        return
    }
    h.cutAndMeld(p)
}

func (h Heap) cutAndMeld(x *Node) {
    h.cut(x)
    x.parent = nil
    meld1(h.Node, x)
}

// task requirement
func (h *Heap) Delete(n *Node) {
    p := n.parent
    if p == nil {
        if n == h.Node {
            h.ExtractMin()
            return
        }
        n.prev.next = n.next
        n.next.prev = n.prev
    } else {
        h.cut(n)
    }
    c := n.child
    if c == nil {
        return
    }
    for {
        c.parent = nil
        c = c.next
        if c == n.child {
            break
        }
    }
    meld2(h.Node, c)
}

// adapted from task "Visualize a tree"
func (h Heap) Vis() {
    if h.Node == nil {
        fmt.Println("<empty>")
        return
    }
    var f func(*Node, string)
    f = func(n *Node, pre string) {
        pc := "│ "
        for x := n; ; x = x.next {
            if x.next != n {
                fmt.Print(pre, "├─")
            } else {
                fmt.Print(pre, "└─")
                pc = "  "
            }
            if x.child == nil {
                fmt.Println("╴", x.value)
            } else {
                fmt.Println("┐", x.value)
                f(x.child, pre+pc)
            }
            if x.next == n {
                break
            }
        }
    }
    f(h.Node, "")
}
