package main

import "fmt"

type node struct {
    value       int
    left, right *node
}

func (n *node) iterPreorder(visit func(int)) {
    if n == nil {
        return
    }
    visit(n.value)
    n.left.iterPreorder(visit)
    n.right.iterPreorder(visit)
}

func (n *node) iterInorder(visit func(int)) {
    if n == nil {
        return
    }
    n.left.iterInorder(visit)
    visit(n.value)
    n.right.iterInorder(visit)
}

func (n *node) iterPostorder(visit func(int)) {
    if n == nil {
        return
    }
    n.left.iterPostorder(visit)
    n.right.iterPostorder(visit)
    visit(n.value)
}

func (n *node) iterLevelorder(visit func(int)) {
    if n == nil {
        return
    }
    for queue := []*node{n}; ; {
        n = queue[0]
        visit(n.value)
        copy(queue, queue[1:])
        queue = queue[:len(queue)-1]
        if n.left != nil {
            queue = append(queue, n.left)
        }
        if n.right != nil {
            queue = append(queue, n.right)
        }
        if len(queue) == 0 {
            return
        }
    }
}

func main() {
    tree := &node{1,
        &node{2,
            &node{4,
                &node{7, nil, nil},
                nil},
            &node{5, nil, nil}},
        &node{3,
            &node{6,
                &node{8, nil, nil},
                &node{9, nil, nil}},
            nil}}
    fmt.Print("preorder:    ")
    tree.iterPreorder(visitor)
    fmt.Println()
    fmt.Print("inorder:     ")
    tree.iterInorder(visitor)
    fmt.Println()
    fmt.Print("postorder:   ")
    tree.iterPostorder(visitor)
    fmt.Println()
    fmt.Print("level-order: ")
    tree.iterLevelorder(visitor)
    fmt.Println()
}

func visitor(value int) {
    fmt.Print(value, " ")
}
