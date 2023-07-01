package main

import (
    "fmt"
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

func makeIndent(outline string, tab int) []iNode {
    lines := strings.Split(outline, "\n")
    iNodes := make([]iNode, len(lines))
    for i, line := range lines {
        line2 := strings.TrimLeft(line, " ")
        le, le2 := len(line), len(line2)
        level := (le - le2) / tab
        iNodes[i] = iNode{level, line2}
    }
    return iNodes
}

func toMarkup(n nNode, cols []string, depth int) string {
    var span int

    var colSpan func(nn nNode)
    colSpan = func(nn nNode) {
        for i, c := range nn.children {
            if i > 0 {
                span++
            }
            colSpan(c)
        }
    }

    for _, c := range n.children {
        span = 1
        colSpan(c)
    }
    var lines []string
    lines = append(lines, `{| class="wikitable" style="text-align: center;"`)
    const l1, l2 = "|-", "|  |"
    lines = append(lines, l1)
    span = 1
    colSpan(n)
    s := fmt.Sprintf(`| style="background: %s " colSpan=%d | %s`, cols[0], span, n.name)
    lines = append(lines, s, l1)

    var nestedFor func(nn nNode, level, maxLevel, col int)
    nestedFor = func(nn nNode, level, maxLevel, col int) {
        if level == 1 && maxLevel > level {
            for i, c := range nn.children {
                nestedFor(c, 2, maxLevel, i)
            }
        } else if level < maxLevel {
            for _, c := range nn.children {
                nestedFor(c, level+1, maxLevel, col)
            }
        } else {
            if len(nn.children) > 0 {
                for i, c := range nn.children {
                    span = 1
                    colSpan(c)
                    cn := col + 1
                    if maxLevel == 1 {
                        cn = i + 1
                    }
                    s := fmt.Sprintf(`| style="background: %s " colspan=%d | %s`, cols[cn], span, c.name)
                    lines = append(lines, s)
                }
            } else {
                lines = append(lines, l2)
            }
        }
    }
    for maxLevel := 1; maxLevel < depth; maxLevel++ {
        nestedFor(n, 1, maxLevel, 0)
        if maxLevel < depth-1 {
            lines = append(lines, l1)
        }
    }
    lines = append(lines, "|}")
    return strings.Join(lines, "\n")
}

func main() {
    const outline = `Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.`
    const (
        yellow = "#ffffe6;"
        orange = "#ffebd2;"
        green  = "#f0fff0;"
        blue   = "#e6ffff;"
        pink   = "#ffeeff;"
    )
    cols := []string{yellow, orange, green, blue, pink}
    iNodes := makeIndent(outline, 4)
    var n nNode
    toNest(iNodes, 0, 0, &n)
    fmt.Println(toMarkup(n, cols, 4))

    fmt.Println("\n")
    const outline2 = `Display an outline as a nested table.
    Parse the outline to a tree,
        measuring the indent of each line,
        translating the indentation to a nested structure,
        and padding the tree to even depth.
    count the leaves descending from each node,
        defining the width of a leaf as 1,
        and the width of a parent node as a sum.
            (The sum of the widths of its children)
            Propagating the sums upward as necessary.
    and write out a table with 'colspan' values
        either as a wiki table,
        or as HTML.
    Optionally add color to the nodes.`
    cols2 := []string{blue, yellow, orange, green, pink}
    var n2 nNode
    iNodes2 := makeIndent(outline2, 4)
    toNest(iNodes2, 0, 0, &n2)
    fmt.Println(toMarkup(n2, cols2, 4))
}
