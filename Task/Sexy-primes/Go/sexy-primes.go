package main

import "fmt"

func sieve(limit int) []bool {
    limit++
    // True denotes composite, false denotes prime.
    c := make([]bool, limit) // all false by default
    c[0] = true
    c[1] = true
    // no need to bother with even numbers over 2 for this task
    p := 3 // Start from 3.
    for {
        p2 := p * p
        if p2 >= limit {
            break
        }
        for i := p2; i < limit; i += 2 * p {
            c[i] = true
        }
        for {
            p += 2
            if !c[p] {
                break
            }
        }
    }
    return c
}

func commatize(n int) string {
    s := fmt.Sprintf("%d", n)
    if n < 0 {
        s = s[1:]
    }
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    if n >= 0 {
        return s
    }
    return "-" + s
}

func printHelper(cat string, le, lim, max int) (int, int, string) {
    cle, clim := commatize(le), commatize(lim)
    if cat != "unsexy primes" {
        cat = "sexy prime " + cat
    }
    fmt.Printf("Number of %s less than %s = %s\n", cat, clim, cle)
    last := max
    if le < last {
        last = le
    }
    verb := "are"
    if last == 1 {
        verb = "is"
    }
    return le, last, verb
}

func main() {
    lim := 1000035
    sv := sieve(lim - 1)
    var pairs [][2]int
    var trips [][3]int
    var quads [][4]int
    var quins [][5]int
    var unsexy = []int{2, 3}
    for i := 3; i < lim; i += 2 {
        if i > 5 && i < lim-6 && !sv[i] && sv[i-6] && sv[i+6] {
            unsexy = append(unsexy, i)
            continue
        }
        if i < lim-6 && !sv[i] && !sv[i+6] {
            pair := [2]int{i, i + 6}
            pairs = append(pairs, pair)
        } else {
            continue
        }
        if i < lim-12 && !sv[i+12] {
            trip := [3]int{i, i + 6, i + 12}
            trips = append(trips, trip)
        } else {
            continue
        }
        if i < lim-18 && !sv[i+18] {
            quad := [4]int{i, i + 6, i + 12, i + 18}
            quads = append(quads, quad)
        } else {
            continue
        }
        if i < lim-24 && !sv[i+24] {
            quin := [5]int{i, i + 6, i + 12, i + 18, i + 24}
            quins = append(quins, quin)
        }
    }
    le, n, verb := printHelper("pairs", len(pairs), lim, 5)
    fmt.Printf("The last %d %s:\n  %v\n\n", n, verb, pairs[le-n:])

    le, n, verb = printHelper("triplets", len(trips), lim, 5)
    fmt.Printf("The last %d %s:\n  %v\n\n", n, verb, trips[le-n:])

    le, n, verb = printHelper("quadruplets", len(quads), lim, 5)
    fmt.Printf("The last %d %s:\n  %v\n\n", n, verb, quads[le-n:])

    le, n, verb = printHelper("quintuplets", len(quins), lim, 5)
    fmt.Printf("The last %d %s:\n  %v\n\n", n, verb, quins[le-n:])

    le, n, verb = printHelper("unsexy primes", len(unsexy), lim, 10)
    fmt.Printf("The last %d %s:\n  %v\n\n", n, verb, unsexy[le-n:])
}
