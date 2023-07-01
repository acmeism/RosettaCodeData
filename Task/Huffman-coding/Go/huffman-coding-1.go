package main

import (
    "container/heap"
    "fmt"
)

type HuffmanTree interface {
    Freq() int
}

type HuffmanLeaf struct {
    freq  int
    value rune
}

type HuffmanNode struct {
    freq        int
    left, right HuffmanTree
}

func (self HuffmanLeaf) Freq() int {
    return self.freq
}

func (self HuffmanNode) Freq() int {
    return self.freq
}

type treeHeap []HuffmanTree

func (th treeHeap) Len() int { return len(th) }
func (th treeHeap) Less(i, j int) bool {
    return th[i].Freq() < th[j].Freq()
}
func (th *treeHeap) Push(ele interface{}) {
    *th = append(*th, ele.(HuffmanTree))
}
func (th *treeHeap) Pop() (popped interface{}) {
    popped = (*th)[len(*th)-1]
    *th = (*th)[:len(*th)-1]
    return
}
func (th treeHeap) Swap(i, j int) { th[i], th[j] = th[j], th[i] }

func buildTree(symFreqs map[rune]int) HuffmanTree {
    var trees treeHeap
    for c, f := range symFreqs {
        trees = append(trees, HuffmanLeaf{f, c})
    }
    heap.Init(&trees)
    for trees.Len() > 1 {
        // two trees with least frequency
        a := heap.Pop(&trees).(HuffmanTree)
        b := heap.Pop(&trees).(HuffmanTree)

        // put into new node and re-insert into queue
        heap.Push(&trees, HuffmanNode{a.Freq() + b.Freq(), a, b})
    }
    return heap.Pop(&trees).(HuffmanTree)
}

func printCodes(tree HuffmanTree, prefix []byte) {
    switch i := tree.(type) {
    case HuffmanLeaf:
        // print out symbol, frequency, and code for this
        // leaf (which is just the prefix)
        fmt.Printf("%c\t%d\t%s\n", i.value, i.freq, string(prefix))
    case HuffmanNode:
        // traverse left
        prefix = append(prefix, '0')
        printCodes(i.left, prefix)
        prefix = prefix[:len(prefix)-1]

        // traverse right
        prefix = append(prefix, '1')
        printCodes(i.right, prefix)
        prefix = prefix[:len(prefix)-1]
    }
}

func main() {
    test := "this is an example for huffman encoding"

    symFreqs := make(map[rune]int)
    // read each symbol and record the frequencies
    for _, c := range test {
        symFreqs[c]++
    }

    // build tree
    tree := buildTree(symFreqs)

    // print out results
    fmt.Println("SYMBOL\tWEIGHT\tHUFFMAN CODE")
    printCodes(tree, []byte{})
}
