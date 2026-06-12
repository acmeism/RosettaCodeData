package main

import (
    "fmt"
    "strings"
)

var data = `
FILE    FILE DEPENDENCIES
====    =================
top1    des1 ip1 ip2
top2    des1 ip2 ip3
ip1     extra1 ip1a ipcommon
ip2     ip2a ip2b ip2c ipcommon
des1    des1a des1b des1c
des1a   des1a1 des1a2
des1c   des1c1 extra1`

func main() {
    g, dep, err := parseLibDep(data)
    if err != nil {
        fmt.Println(err)
        return
    }
    // Task 1: Determine top levels.  The input parser returns a list (dep)
    // of libraries that are dependants of at least one other library.
    // Top levels are then libraries in the graph that are not on this list.
    var tops []string
    for n := range g {
        if !dep[n] {
            tops = append(tops, n)
        }
    }
    fmt.Println("Top levels:", tops)
    // Task 2 is orderFrom method, below
    showOrder(g, "top1")         // Task 3
    showOrder(g, "top2")         // Task 4
    showOrder(g, "top1", "top2") // Stretch

    fmt.Println("Cycle examples:")
    // reparse with a cyclic dependency
    g, _, err = parseLibDep(data + `
des1a1  des1`)
    if err != nil {
        fmt.Println(err)
        return
    }
    showOrder(g, "top1")       // runs into cycle
    showOrder(g, "ip1", "ip2") // does not involve cycle
}

func showOrder(g graph, target ...string) {
    order, cyclic := g.orderFrom(target...)
    if cyclic == nil {
        reverse(order) // compile order is reverse of dependency order
        fmt.Println("Target", target, "order:", order)
    } else {
        fmt.Println("Target", target, "cyclic dependencies:", cyclic)
    }
}

func reverse(s []string) {
    last := len(s) - 1
    for i, e := range s[:len(s)/2] {
        s[i], s[last-i] = s[last-i], e
    }
}

type graph map[string][]string // adjacency list representation
type depList map[string]bool

// parseLibDep parses the text format of the task and returns a dependency
// graph and a list of nodes that are dependants of at least one other node.
func parseLibDep(data string) (g graph, d depList, err error) {
    lines := strings.Split(data, "\n")
    if len(lines) < 3 || !strings.HasPrefix(lines[2], "=") {
        return nil, nil, fmt.Errorf("data format")
    }
    lines = lines[3:]
    g = graph{}
    d = depList{}
    for _, line := range lines {
        libs := strings.Fields(line)
        if len(libs) == 0 {
            continue
        }
        lib := libs[0]
        var deps []string
        for _, dep := range libs[1:] {
            g[dep] = g[dep]
            if dep == lib {
                continue
            }
            for i := 0; ; i++ {
                if i == len(deps) {
                    deps = append(deps, dep)
                    d[dep] = true
                    break
                }
                if dep == deps[i] {
                    break
                }
            }
        }
        g[lib] = deps
    }
    return g, d, nil
}

// OrderFrom produces a topological ordering of the subgraph of g reachable
// from a set of start nodes, where the subgraph is a directed acyclic graph.
// If the subgraph contains a cycle, orderFrom returns the first cycle found
// and returns a nil order.  Cycles which are in the graph but not in the
// subgraph reachable from start are not detected.
func (g graph) orderFrom(start ...string) (order, cyclic []string) {
    L := make([]string, len(g))
    i := len(L)
    temp := map[string]bool{}
    perm := map[string]bool{}
    var cycleFound bool
    var cycleStart string
    var visit func(string)
    visit = func(n string) {
        switch {
        case temp[n]:
            cycleFound = true
            cycleStart = n
            return
        case perm[n]:
            return
        }
        temp[n] = true
        for _, m := range g[n] {
            visit(m)
            if cycleFound {
                if cycleStart > "" {
                    cyclic = append(cyclic, n)
                    if n == cycleStart {
                        cycleStart = ""
                    }
                }
                return
            }
        }
        delete(temp, n)
        perm[n] = true
        i--
        L[i] = n
    }
    for _, n := range start {
        if perm[n] {
            continue
        }
        visit(n)
        if cycleFound {
            return nil, cyclic
        }
    }
    return L[i:], nil
}
