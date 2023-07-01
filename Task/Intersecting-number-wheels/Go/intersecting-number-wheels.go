package main

import (
    "fmt"
    "sort"
    "strconv"
)

type wheel struct {
    next   int
    values []string
}

type wheelMap = map[string]wheel

func generate(wheels wheelMap, start string, maxCount int) {
    count := 0
    w := wheels[start]
    for {
        s := w.values[w.next]
        v, err := strconv.Atoi(s)
        w.next = (w.next + 1) % len(w.values)
        wheels[start] = w
        if err == nil {
            fmt.Printf("%d ", v)
            count++
            if count == maxCount {
                fmt.Println("...\n")
                return
            }
        } else {
            for {
                w2 := wheels[s]
                ss := s
                s = w2.values[w2.next]
                w2.next = (w2.next + 1) % len(w2.values)
                wheels[ss] = w2
                v, err = strconv.Atoi(s)
                if err == nil {
                    fmt.Printf("%d ", v)
                    count++
                    if count == maxCount {
                        fmt.Println("...\n")
                        return
                    }
                    break
                }
            }
        }
    }
}

func printWheels(wheels wheelMap) {
    var names []string
    for name := range wheels {
        names = append(names, name)
    }
    sort.Strings(names)
    fmt.Println("Intersecting Number Wheel group:")
    for _, name := range names {
        fmt.Printf("  %s: %v\n", name, wheels[name].values)
    }
    fmt.Print("  Generates:\n    ")
}

func main() {
    wheelMaps := []wheelMap{
        {
            "A": {0, []string{"1", "2", "3"}},
        },
        {
            "A": {0, []string{"1", "B", "2"}},
            "B": {0, []string{"3", "4"}},
        },
        {
            "A": {0, []string{"1", "D", "D"}},
            "D": {0, []string{"6", "7", "8"}},
        },
        {
            "A": {0, []string{"1", "B", "C"}},
            "B": {0, []string{"3", "4"}},
            "C": {0, []string{"5", "B"}},
        },
    }
    for _, wheels := range wheelMaps {
        printWheels(wheels)
        generate(wheels, "A", 20)
    }
}
