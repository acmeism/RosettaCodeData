package main

import (
    "container/heap"
    "fmt"
)

type coded struct {
    sym  rune
    code string
}

type counted struct {
    total int
    syms []coded
}

type cHeap []counted

// satisfy heap.Interface
func (c cHeap) Len() int           { return len(c) }
func (c cHeap) Less(i, j int) bool { return c[i].total < c[j].total }
func (c cHeap) Swap(i, j int)      { c[i], c[j] = c[j], c[i] }
func (c *cHeap) Push(ele interface{}) {
    *c = append(*c, ele.(counted))
}
func (c *cHeap) Pop() (popped interface{}) {
    popped = (*c)[len(*c)-1]
    *c = (*c)[:len(*c)-1]
    return
}

func encode(sym2freq map[rune]int) []coded {
    var ch cHeap
    for sym, freq := range sym2freq {
        ch = append(ch, counted{freq, []coded{{sym: sym}}})
    }
    heap.Init(&ch)
    for len(ch) > 1 {
        a := heap.Pop(&ch).(counted)
        b := heap.Pop(&ch).(counted)
        for i, c := range a.syms {
            a.syms[i].code = "0" + c.code
        }
        for i, c := range b.syms {
            b.syms[i].code = "1" + c.code
        }
        heap.Push(&ch, counted{a.total + b.total, append(a.syms, b.syms...)})
    }
    return heap.Pop(&ch).(counted).syms
}

const txt = "this is an example for huffman encoding"

func main() {
    sym2freq := make(map[rune]int)
    for _, c := range txt {
        sym2freq[c]++
    }
    table := encode(sym2freq)
    fmt.Println("Symbol  Weight Huffman Code")
    for _, c := range table {
        fmt.Printf("     %c    %d    %s\n", c.sym, sym2freq[c.sym], c.code)
    }
}
