package main

import (
    "fmt"
    "sort"
)

// Check a slice contains a value.
func contains(s []int, f int) bool {
    for _, e := range s {
        if e == f {
            return true
        }
    }
    return false
}

// Assumes s1, s2 are of same length.
func sliceEqual(s1, s2 []int) bool {
    for i := 0; i < len(s1); i++ {
        if s1[i] != s2[i] {
            return false
        }
    }
    return true
}

// Reverses slice in place.
func reverse(s []int) {
    for i, j := 0, len(s)-1; i < j; i, j = i+1, j-1 {
        s[i], s[j] = s[j], s[i]
    }
}

// Check two perimeters are equal.
func perimEqual(p1, p2 []int) bool {
    le := len(p1)
    if le != len(p2) {
        return false
    }
    for _, p := range p1 {
        if !contains(p2, p) {
            return false
        }
    }
    // use copy to avoid mutating 'p1'
    c := make([]int, le)
    copy(c, p1)
    for r := 0; r < 2; r++ {
        for i := 0; i < le; i++ {
            if sliceEqual(c, p2) {
                return true
            }
            // do circular shift to right
            t := c[le-1]
            copy(c[1:], c[0:le-1])
            c[0] = t
        }
        // now process in opposite direction
        reverse(c)
    }
    return false
}

type edge [2]int

// Translates a face to perimeter format.
func faceToPerim(face []edge) []int {
    // use copy to avoid mutating 'face'
    le := len(face)
    if le == 0 {
        return nil
    }
    edges := make([]edge, le)
    for i := 0; i < le; i++ {
        // check edge pairs are in correct order
        if face[i][1] <= face[i][0] {
            return nil
        }
        edges[i] = face[i]
    }
    // sort edges in ascending order
    sort.Slice(edges, func(i, j int) bool {
        if edges[i][0] != edges[j][0] {
            return edges[i][0] < edges[j][0]
        }
        return edges[i][1] < edges[j][1]
    })
    var perim []int
    first, last := edges[0][0], edges[0][1]
    perim = append(perim, first, last)
    // remove first edge
    copy(edges, edges[1:])
    edges = edges[0 : le-1]
    le--
outer:
    for le > 0 {
        for i, e := range edges {
            found := false
            if e[0] == last {
                perim = append(perim, e[1])
                last, found = e[1], true
            } else if e[1] == last {
                perim = append(perim, e[0])
                last, found = e[0], true
            }
            if found {
                // remove i'th edge
                copy(edges[i:], edges[i+1:])
                edges = edges[0 : le-1]
                le--
                if last == first {
                    if le == 0 {
                        break outer
                    } else {
                        return nil
                    }
                }
                continue outer
            }
        }
    }
    return perim[0 : len(perim)-1]
}

func main() {
    fmt.Println("Perimeter format equality checks:")
    areEqual := perimEqual([]int{8, 1, 3}, []int{1, 3, 8})
    fmt.Printf("  Q == R is %t\n", areEqual)
    areEqual = perimEqual([]int{18, 8, 14, 10, 12, 17, 19}, []int{8, 14, 10, 12, 17, 19, 18})
    fmt.Printf("  U == V is %t\n", areEqual)
    e := []edge{{7, 11}, {1, 11}, {1, 7}}
    f := []edge{{11, 23}, {1, 17}, {17, 23}, {1, 11}}
    g := []edge{{8, 14}, {17, 19}, {10, 12}, {10, 14}, {12, 17}, {8, 18}, {18, 19}}
    h := []edge{{1, 3}, {9, 11}, {3, 11}, {1, 11}}
    fmt.Println("\nEdge to perimeter format translations:")
    for i, face := range [][]edge{e, f, g, h} {
        perim := faceToPerim(face)
        if perim == nil {
            fmt.Printf("  %c => Invalid edge format\n", i + 'E')
        } else {
            fmt.Printf("  %c => %v\n", i + 'E', perim)
        }
    }
}
