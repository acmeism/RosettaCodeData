package main

import (
    "fmt"
    "sort"
    "strings"
)

var count int = 0

type sortable []string
func (s sortable) Len() int      { return len(s) }
func (s sortable) Swap(i, j int) { s[i], s[j] = s[j], s[i] }
func (s sortable) Less(i, j int) bool {
    s1, s2 := s[i], s[j]
    count++
    fmt.Printf("(%d) Is %s < %s? ", count, s1, s2)
    var response string
    _, err := fmt.Scanln(&response)
    return err == nil && strings.HasPrefix(response, "y")
}

func main() {
    items := sortable{"violet", "red", "green", "indigo", "blue", "yellow", "orange"}
    sort.Sort(items)
    fmt.Println(items)
}
