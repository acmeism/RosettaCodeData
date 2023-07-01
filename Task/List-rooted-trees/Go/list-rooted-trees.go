package main

import (
    "fmt"
    "log"
    "os"
    "strconv"
)

type tree uint64

var (
    list   []tree
    offset = [32]uint{1: 1}
)

func add(t tree) {
    list = append(list, 1|t<<1)
}

func show(t tree, l uint) {
    for ; l > 0; t >>= 1 {
        l--
        var paren byte
        if (t & 1) != 0 {
            paren = '('
        } else {
            paren = ')'
        }
        fmt.Printf("%c", paren)
    }
}

func listTrees(n uint) {
    for i := offset[n]; i < offset[n+1]; i++ {
        show(list[i], n*2)
        fmt.Println()
    }
}

/* assemble tree from subtrees
n:   length of tree we want to make
t:   assembled parts so far
sl:  length of subtree we are looking at
pos: offset of subtree we are looking at
rem: remaining length to be put together
*/

func assemble(n uint, t tree, sl, pos, rem uint) {
    if rem == 0 {
        add(t)
        return
    }

    if sl > rem { // need smaller sub-trees
        sl = rem
        pos = offset[sl]
    } else if pos >= offset[sl+1] {
        // used up sl-trees, try smaller ones
        sl--
        if sl == 0 {
            return
        }
        pos = offset[sl]
    }

    assemble(n, t<<(2*sl)|list[pos], sl, pos, rem-sl)
    assemble(n, t, sl, pos+1, rem)
}

func mktrees(n uint) {
    if offset[n+1] > 0 {
        return
    }
    if n > 0 {
        mktrees(n - 1)
    }

    assemble(n, 0, n-1, offset[n-1], n-1)
    offset[n+1] = uint(len(list))
}

func main() {
    if len(os.Args) != 2 {
        log.Fatal("There must be exactly 1 command line argument")
    }
    n, err := strconv.Atoi(os.Args[1])
    if err != nil {
        log.Fatal("Argument is not a valid number")
    }
    if n <= 0 || n > 19 { // stack overflow for n == 20
        n = 5
    }
    // init 1-tree
    add(0)

    mktrees(uint(n))
    fmt.Fprintf(os.Stderr, "Number of %d-trees: %d\n", n, offset[n+1]-offset[n])
    listTrees(uint(n))
}
