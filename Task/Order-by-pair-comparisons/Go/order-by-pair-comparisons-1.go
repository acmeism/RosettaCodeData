package main

import (
    "fmt"
    "sort"
    "strings"
)

var count int = 0

func interactiveCompare(s1, s2 string) bool {
    count++
    fmt.Printf("(%d) Is %s < %s? ", count, s1, s2)
    var response string
    _, err := fmt.Scanln(&response)
    return err == nil && strings.HasPrefix(response, "y")
}

func main() {
    items := []string{"violet", "red", "green", "indigo", "blue", "yellow", "orange"}

    var sortedItems []string

    // Use a binary insertion sort to order the items.  It should ask for
    // close to the minimum number of questions required
    for _, item := range items {
        fmt.Printf("Inserting '%s' into %s\n", item, sortedItems)
        // sort.Search performs the binary search using interactiveCompare to
        // rank the items
        spotToInsert := sort.Search(len(sortedItems), func(i int) bool {
            return interactiveCompare(item, sortedItems[i])
        })
        sortedItems = append(sortedItems[:spotToInsert],
                             append([]string{item}, sortedItems[spotToInsert:]...)...)
    }
    fmt.Println(sortedItems)
}
