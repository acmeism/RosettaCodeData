package main

import (
    "fmt"
    "sort"
    "strings"

    "data"
)

func main() {
    nx := make([]int, len(data.List))
    for i := range nx {
        nx[i] = i
    }
    sort.Slice(nx, func(i, j int) bool {
        return data.List[nx[i]].Name < data.List[nx[j]].Name
    })

    i := sort.Search(len(nx), func(i int) bool {
        return data.List[nx[i]].Name >= "Dar Es Salaam"
    })
    if i == len(nx) || data.List[nx[i]].Name != "Dar Es Salaam" {
        fmt.Println("*** not found ***")
    } else {
        fmt.Println(nx[i])
    }

    for i := range nx {
        nx[i] = i
    }
    sort.SliceStable(nx, func(i, j int) bool {
        return data.List[nx[i]].Name[0] < data.List[nx[j]].Name[0]
    })

    i = sort.Search(len(nx), func(i int) bool {
        return data.List[nx[i]].Name >= "A"
    })
    if i == len(nx) || !strings.HasPrefix(data.List[nx[i]].Name, "A") {
        fmt.Println("*** not found ***")
    } else {
        fmt.Println(data.List[nx[i]].Population)
    }
}
