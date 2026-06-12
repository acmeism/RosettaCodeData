package main

import (
    "container/list"
    "fmt"
)

type BinaryTree struct {
    node         int
    leftSubTree  *BinaryTree
    rightSubTree *BinaryTree
}

func (bt *BinaryTree) insert(item int) {
    if bt.node == 0 {
        bt.node = item
        bt.leftSubTree = &BinaryTree{}
        bt.rightSubTree = &BinaryTree{}
    } else if item < bt.node {
        bt.leftSubTree.insert(item)
    } else {
        bt.rightSubTree.insert(item)
    }
}

func (bt *BinaryTree) inOrder(ll *list.List) {
    if bt.node == 0 {
        return
    }
    bt.leftSubTree.inOrder(ll)
    ll.PushBack(bt.node)
    bt.rightSubTree.inOrder(ll)
}
func treeSort(ll *list.List) *list.List {
    searchTree := &BinaryTree{}
    for e := ll.Front(); e != nil; e = e.Next() {
        i := e.Value.(int)
        searchTree.insert(i)
    }
    ll2 := list.New()
    searchTree.inOrder(ll2)
    return ll2
}

func printLinkedList(ll *list.List, f string, sorted bool) {
    for e := ll.Front(); e != nil; e = e.Next() {
        i := e.Value.(int)
        fmt.Printf(f+" ", i)
    }
    if !sorted {
        fmt.Print("-> ")
    } else {
        fmt.Println()
    }
}

func main() {
    sl := []int{5, 3, 7, 9, 1}
    ll := list.New()
    for _, i := range sl {
        ll.PushBack(i)
    }
    printLinkedList(ll, "%d", false)
    lls := treeSort(ll)
    printLinkedList(lls, "%d", true)

    sl2 := []int{'d', 'c', 'e', 'b', 'a'}
    ll2 := list.New()
    for _, c := range sl2 {
        ll2.PushBack(c)
    }
    printLinkedList(ll2, "%c", false)
    lls2 := treeSort(ll2)
    printLinkedList(lls2, "%c", true)
}
