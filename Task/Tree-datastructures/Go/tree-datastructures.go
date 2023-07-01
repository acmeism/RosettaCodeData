package main

import (
    "fmt"
    "io"
    "os"
    "strings"
)

type nNode struct {
    name     string
    children []nNode
}

type iNode struct {
    level int
    name  string
}

func printNest(n nNode, level int, w io.Writer) {
    if level == 0 {
        fmt.Fprintln(w, "\n==Nest form==\n")
    }
    fmt.Fprintf(w, "%s%s\n", strings.Repeat("  ", level), n.name)
    for _, c := range n.children {
        fmt.Fprintf(w, "%s", strings.Repeat("  ", level+1))
        printNest(c, level+1, w)
    }
}

func toNest(iNodes []iNode, start, level int, n *nNode) {
    if level == 0 {
        n.name = iNodes[0].name
    }
    for i := start + 1; i < len(iNodes); i++ {
        if iNodes[i].level == level+1 {
            c := nNode{iNodes[i].name, nil}
            toNest(iNodes, i, level+1, &c)
            n.children = append(n.children, c)
        } else if iNodes[i].level <= level {
            return
        }
    }
}

func printIndent(iNodes []iNode, w io.Writer) {
    fmt.Fprintln(w, "\n==Indent form==\n")
    for _, n := range iNodes {
        fmt.Fprintf(w, "%d %s\n", n.level, n.name)
    }
}

func toIndent(n nNode, level int, iNodes *[]iNode) {
    *iNodes = append(*iNodes, iNode{level, n.name})
    for _, c := range n.children {
        toIndent(c, level+1, iNodes)
    }
}

func main() {
    n1 := nNode{"RosettaCode", nil}
    n2 := nNode{"rocks", []nNode{{"code", nil}, {"comparison", nil}, {"wiki", nil}}}
    n3 := nNode{"mocks", []nNode{{"trolling", nil}}}
    n1.children = append(n1.children, n2, n3)

    var sb strings.Builder
    printNest(n1, 0, &sb)
    s1 := sb.String()
    fmt.Print(s1)

    var iNodes []iNode
    toIndent(n1, 0, &iNodes)
    printIndent(iNodes, os.Stdout)

    var n nNode
    toNest(iNodes, 0, 0, &n)
    sb.Reset()
    printNest(n, 0, &sb)
    s2 := sb.String()
    fmt.Print(s2)

    fmt.Println("\nRound trip test satisfied? ", s1 == s2)
}
