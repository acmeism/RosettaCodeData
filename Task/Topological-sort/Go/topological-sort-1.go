package main

import (
    "fmt"
    "strings"
)

var data = `
LIBRARY          LIBRARY DEPENDENCIES
=======          ====================
des_system_lib   std synopsys std_cell_lib des_system_lib dw02 dw01 ramlib ieee
dw01             ieee dw01 dware gtech
dw02             ieee dw02 dware
dw03             std synopsys dware dw03 dw02 dw01 ieee gtech
dw04             dw04 ieee dw01 dware gtech
dw05             dw05 ieee dware
dw06             dw06 ieee dware
dw07             ieee dware
dware            ieee dware
gtech            ieee gtech
ramlib           std ieee
std_cell_lib     ieee std_cell_lib
synopsys         `

func main() {
    g, in, err := parseLibComp(data)
    if err != nil {
        fmt.Println(err)
        return
    }
    order, cyclic := topSortKahn(g, in)
    if cyclic != nil {
        fmt.Println("Cyclic:", cyclic)
        return
    }
    fmt.Println("Order:", order)
}

type graph map[string][]string
type inDegree map[string]int

// parseLibComp parses the text format of the task and returns a graph
// representation and a list of the in-degrees of each node.  The returned graph
// represents compile order rather than dependency order.  That is, for each map
// map key n, the map elements are libraries that depend on n being compiled
// first.
func parseLibComp(data string) (g graph, in inDegree, err error) {
    // small sanity check on input
    lines := strings.Split(data, "\n")
    if len(lines) < 3 || !strings.HasPrefix(lines[2], "=") {
        return nil, nil, fmt.Errorf("data format")
    }
    // toss header lines
    lines = lines[3:]
    // scan and interpret input, build graph
    g = graph{}
    in = inDegree{}
    for _, line := range lines {
        libs := strings.Fields(line)
        if len(libs) == 0 {
            continue // allow blank lines
        }
        lib := libs[0]
        g[lib] = g[lib]
        for _, dep := range libs[1:] {
            in[dep] = in[dep]
            if dep == lib {
                continue // ignore self dependencies
            }
            successors := g[dep]
            for i := 0; ; i++ {
                if i == len(successors) {
                    g[dep] = append(successors, lib)
                    in[lib]++
                    break
                }
                if dep == successors[i] {
                    break // ignore duplicate dependencies
                }
            }
        }
    }
    return g, in, nil
}

// General purpose topological sort, not specific to the application of
// library dependencies.  Adapted from Wikipedia pseudo code, one main
// difference here is that this function does not consume the input graph.
// WP refers to incoming edges, but does not really need them fully represented.
// A count of incoming edges, or the in-degree of each node is enough.  Also,
// WP stops at cycle detection and doesn't output information about the cycle.
// A little extra code at the end of this function recovers the cyclic nodes.
func topSortKahn(g graph, in inDegree) (order, cyclic []string) {
    var L, S []string
    // rem for "remaining edges," this function makes a local copy of the
    // in-degrees and consumes that instead of consuming an input.
    rem := inDegree{}
    for n, d := range in {
        if d == 0 {
            // accumulate "set of all nodes with no incoming edges"
            S = append(S, n)
        } else {
            // initialize rem from in-degree
            rem[n] = d
        }
    }
    for len(S) > 0 {
        last := len(S) - 1 // "remove a node n from S"
        n := S[last]
        S = S[:last]
        L = append(L, n) // "add n to tail of L"
        for _, m := range g[n] {
            // WP pseudo code reads "for each node m..." but it means for each
            // node m *remaining in the graph.*  We consume rem rather than
            // the graph, so "remaining in the graph" for us means rem[m] > 0.
            if rem[m] > 0 {
                rem[m]--         // "remove edge from the graph"
                if rem[m] == 0 { // if "m has no other incoming edges"
                    S = append(S, m) // "insert m into S"
                }
            }
        }
    }
    // "If graph has edges," for us means a value in rem is > 0.
    for c, in := range rem {
        if in > 0 {
            // recover cyclic nodes
            for _, nb := range g[c] {
                if rem[nb] > 0 {
                    cyclic = append(cyclic, c)
                    break
                }
            }
        }
    }
    if len(cyclic) > 0 {
        return nil, cyclic
    }
    return L, nil
}
