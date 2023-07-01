package main

import "fmt"

func main() {
    tree := eertree([]byte("eertree"))
    fmt.Println(subPalindromes(tree))
}

type edges map[byte]int

type node struct {
    length int
    edges
    suffix int
}

const evenRoot = 0
const oddRoot = 1

func eertree(s []byte) []node {
    tree := []node{
        evenRoot: {length: 0, suffix: oddRoot, edges: edges{}},
        oddRoot:  {length: -1, suffix: oddRoot, edges: edges{}},
    }
    suffix := oddRoot
    var n, k int
    for i, c := range s {
        for n = suffix; ; n = tree[n].suffix {
            k = tree[n].length
            if b := i - k - 1; b >= 0 && s[b] == c {
                break
            }
        }
        if e, ok := tree[n].edges[c]; ok {
            suffix = e
            continue
        }
        suffix = len(tree)
        tree = append(tree, node{length: k + 2, edges: edges{}})
        tree[n].edges[c] = suffix
        if tree[suffix].length == 1 {
            tree[suffix].suffix = 0
            continue
        }
        for {
            n = tree[n].suffix
            if b := i - tree[n].length - 1; b >= 0 && s[b] == c {
                break
            }
        }
        tree[suffix].suffix = tree[n].edges[c]
    }
    return tree
}

func subPalindromes(tree []node) (s []string) {
    var children func(int, string)
    children = func(n int, p string) {
        for c, n := range tree[n].edges {
            c := string(c)
            p := c + p + c
            s = append(s, p)
            children(n, p)
        }
    }
    children(0, "")
    for c, n := range tree[1].edges {
        c := string(c)
        s = append(s, c)
        children(n, c)
    }
    return
}
