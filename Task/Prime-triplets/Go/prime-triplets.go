package main

import (
    "fmt"
    "rcu"
)

func main() {
    c := rcu.PrimeSieve(5505, false)
    var triples [][3]int
    fmt.Println("Prime triplets: p, p + 2, p + 6 where p < 5,500:")
    for i := 3; i < 5500; i += 2 {
        if !c[i] && !c[i+2] && !c[i+6] {
            triples = append(triples, [3]int{i, i + 2, i + 6})
        }
    }
    for _, triple := range triples {
        var t [3]string
        for i := 0; i < 3; i++ {
            t[i] = rcu.Commatize(triple[i])
        }
        fmt.Printf("%5s  %5s  %5s\n", t[0], t[1], t[2])
    }
    fmt.Println("\nFound", len(triples), "such prime triplets.")
}
