package main

import (
    "fmt"
    "sort"
)

// type and methods satisfying sort.Interface
type subListSortable struct {
    values  sort.Interface
    indices []int
}

func (s subListSortable) Len() int {
    return len(s.indices)
}

func (s subListSortable) Swap(i, j int) {
    s.values.Swap(s.indices[i], s.indices[j])
}

func (s subListSortable) Less(i, j int) bool {
    return s.values.Less(s.indices[i], s.indices[j])
}

func main() {
    // givens
    values := []int{7, 6, 5, 4, 3, 2, 1, 0}
    indices := map[int]int{6: 0, 1: 0, 7: 0}

    // make ordered list of indices for sort methods
    ordered := make([]int, len(indices))
    if len(indices) > 0 {
        i := 0
        for j := range indices {
            ordered[i] = j
            i++
        }
        sort.Ints(ordered)

        // validate that indices are within list boundaries
        if ordered[0] < 0 {
            fmt.Println("Invalid index: ", ordered[0])
            return
        }
        if ordered[len(ordered)-1] >= len(values) {
            fmt.Println("Invalid index: ", ordered[len(ordered)-1])
            return
        }
    }

    // instantiate sortable type and sort
    s := subListSortable{sort.IntSlice(values), ordered}
    fmt.Println("initial:", s.values)
    sort.Sort(s)
    fmt.Println("sorted: ", s.values)
}
