package main

import (
    "fmt"
    "sort"

    "data"
)

func main() {
    if !sort.SliceIsSorted(data.List, func(i, j int) bool {
        return data.List[i].Population > data.List[j].Population
    }) {
        panic("data not sorted by decreasing population")
    }

    i := sort.Search(len(data.List), func(i int) bool {
        return data.List[i].Population < 5
    })
    if i == len(data.List) {
        fmt.Println("*** not found ***")
    } else {
        fmt.Println(data.List[i].Name)
    }
}
