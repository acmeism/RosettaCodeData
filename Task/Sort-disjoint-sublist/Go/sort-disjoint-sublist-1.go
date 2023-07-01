package main

import (
    "fmt"
    "sort"
)

func main() {
    // givens
    values := []int{7, 6, 5, 4, 3, 2, 1, 0}
    indices := map[int]int{6: 0, 1: 0, 7: 0}

    orderedValues := make([]int, len(indices))
    orderedIndices := make([]int, len(indices))
    i := 0
    for j := range indices {
        // validate that indices are within list boundaries
        if j < 0 || j >= len(values) {
            fmt.Println("Invalid index: ", j)
            return
        }
        // extract elements to sort
        orderedValues[i] = values[j]
        orderedIndices[i] = j
        i++
    }
    // sort
    sort.Ints(orderedValues)
    sort.Ints(orderedIndices)

    fmt.Println("initial:", values)
    // replace sorted values
    for i, v := range orderedValues {
        values[orderedIndices[i]] = v
    }
    fmt.Println("sorted: ", values)
}
