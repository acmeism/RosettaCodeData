package main

import "fmt"

func main() {
    vis(buildTree("banana$"))
}

type tree []node

type node struct {
    // a substring of the input string
    sub string
    // list of child nodes
    ch  []int
}

func buildTree(s string) tree {
    // root node
    t := tree{node{}}
    for i := range s {
        t = t.addSuffix(s[i:])
    }
    return t
}

func (t tree) addSuffix(suf string) tree {
    n := 0
    for i := 0; i < len(suf); {
        b := suf[i]
        ch := t[n].ch
        var x2, n2 int
        for ; ; x2++ {
            if x2 == len(ch) {
                // no matching child, remainder of suf becomes new node.
                n2 = len(t)
                t = append(t, node{sub: suf[i:]})
                t[n].ch = append(t[n].ch, n2)
                return t
            }
            n2 = ch[x2]
            if t[n2].sub[0] == b {
                break
            }
        }
        // find prefix of remaining suffix in common with child
        sub2 := t[n2].sub
        j := 0
        for ; j < len(sub2); j++ {
            if suf[i+j] != sub2[j] {
                // split n2
                n3 := n2
                // new node for the part in common
                n2 = len(t)
                t = append(t, node{sub2[:j], []int{n3}})
                // old node loses the part in common
                t[n3].sub = sub2[j:]
                t[n].ch[x2] = n2
                // continue down the tree
                break
            }
        }
        // advance past part in common
        i += j
        // continue down the tree
        n = n2
    }
    return t
}

func vis(t tree) {
    if len(t) == 0 {
        fmt.Println("<empty>")
        return
    }
    var f func(int, string)
    f = func(n int, pre string) {
        children := t[n].ch
        if len(children) == 0 {
            fmt.Println("╴", t[n].sub)
            return
        }
        fmt.Println("┐", t[n].sub)
        last := len(children) - 1
        for _, ch := range children[:last] {
            fmt.Print(pre, "├─")
            f(ch, pre+"│ ")
        }
        fmt.Print(pre, "└─")
        f(children[last], pre+"  ")
    }
    f(0, "")
}
