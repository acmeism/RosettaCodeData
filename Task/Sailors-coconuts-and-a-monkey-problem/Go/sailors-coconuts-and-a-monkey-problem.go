package main

import "fmt"

func main() {
    coconuts := 11
outer:
    for ns := 2; ns < 10; ns++ {
        hidden := make([]int, ns)
        coconuts = (coconuts/ns)*ns + 1
        for {
            nc := coconuts
            for s := 1; s <= ns; s++ {
                if nc%ns == 1 {
                    hidden[s-1] = nc / ns
                    nc -= hidden[s-1] + 1
                    if s == ns && nc%ns == 0 {
                        fmt.Println(ns, "sailors require a minimum of", coconuts, "coconuts")
                        for t := 1; t <= ns; t++ {
                            fmt.Println("\tSailor", t, "hides", hidden[t-1])
                        }
                        fmt.Println("\tThe monkey gets", ns)
                        fmt.Println("\tFinally, each sailor takes", nc/ns, "\b\n")
                        continue outer
                    }
                } else {
                    break
                }
            }
            coconuts += ns
        }
    }
}
