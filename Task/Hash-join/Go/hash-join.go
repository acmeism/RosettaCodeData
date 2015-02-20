package main

import "fmt"

func main() {
    tableA := []struct {
        value int
        key   string
    }{
        {27, "Jonah"}, {18, "Alan"}, {28, "Glory"}, {18, "Popeye"},
        {28, "Alan"},
    }
    tableB := []struct {
        key   string
        value string
    }{
        {"Jonah", "Whales"}, {"Jonah", "Spiders"},
        {"Alan", "Ghosts"}, {"Alan", "Zombies"}, {"Glory", "Buffy"},
    }
    // hash phase
    h := map[string][]int{}
    for i, r := range tableA {
        h[r.key] = append(h[r.key], i)
    }
    // join phase
    for _, x := range tableB {
        for _, a := range h[x.key] {
            fmt.Println(tableA[a], x)
        }
    }
}
