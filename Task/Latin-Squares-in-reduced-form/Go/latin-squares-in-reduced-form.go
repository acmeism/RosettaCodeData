package main

import (
    "fmt"
    "sort"
)

type matrix [][]int

// generate derangements of first n numbers, with 'start' in first place.
func dList(n, start int) (r matrix) {
    start-- // use 0 basing
    a := make([]int, n)
    for i := range a {
        a[i] = i
    }
    a[0], a[start] = start, a[0]
    sort.Ints(a[1:])
    first := a[1]
    // recursive closure permutes a[1:]
    var recurse func(last int)
    recurse = func(last int) {
        if last == first {
            // bottom of recursion.  you get here once for each permutation.
            // test if permutation is deranged.
            for j, v := range a[1:] { // j starts from 0, not 1
                if j+1 == v {
                    return // no, ignore it
                }
            }
            // yes, save a copy
            b := make([]int, n)
            copy(b, a)
            for i := range b {
                b[i]++ // change back to 1 basing
            }
            r = append(r, b)
            return
        }
        for i := last; i >= 1; i-- {
            a[i], a[last] = a[last], a[i]
            recurse(last - 1)
            a[i], a[last] = a[last], a[i]
        }
    }
    recurse(n - 1)
    return
}

func reducedLatinSquare(n int, echo bool) uint64 {
    if n <= 0 {
        if echo {
            fmt.Println("[]\n")
        }
        return 0
    } else if n == 1 {
        if echo {
            fmt.Println("[1]\n")
        }
        return 1
    }
    rlatin := make(matrix, n)
    for i := 0; i < n; i++ {
        rlatin[i] = make([]int, n)
    }
    // first row
    for j := 0; j < n; j++ {
        rlatin[0][j] = j + 1
    }

    count := uint64(0)
    // recursive closure to compute reduced latin squares and count or print them
    var recurse func(i int)
    recurse = func(i int) {
        rows := dList(n, i) // get derangements of first n numbers, with 'i' first.
    outer:
        for r := 0; r < len(rows); r++ {
            copy(rlatin[i-1], rows[r])
            for k := 0; k < i-1; k++ {
                for j := 1; j < n; j++ {
                    if rlatin[k][j] == rlatin[i-1][j] {
                        if r < len(rows)-1 {
                            continue outer
                        } else if i > 2 {
                            return
                        }
                    }
                }
            }
            if i < n {
                recurse(i + 1)
            } else {
                count++
                if echo {
                    printSquare(rlatin, n)
                }
            }
        }
        return
    }

    // remaining rows
    recurse(2)
    return count
}

func printSquare(latin matrix, n int) {
    for i := 0; i < n; i++ {
        fmt.Println(latin[i])
    }
    fmt.Println()
}

func factorial(n uint64) uint64 {
    if n == 0 {
        return 1
    }
    prod := uint64(1)
    for i := uint64(2); i <= n; i++ {
        prod *= i
    }
    return prod
}

func main() {
    fmt.Println("The four reduced latin squares of order 4 are:\n")
    reducedLatinSquare(4, true)

    fmt.Println("The size of the set of reduced latin squares for the following orders")
    fmt.Println("and hence the total number of latin squares of these orders are:\n")
    for n := uint64(1); n <= 6; n++ {
        size := reducedLatinSquare(int(n), false)
        f := factorial(n - 1)
        f *= f * n * size
        fmt.Printf("Order %d: Size %-4d x %d! x %d! => Total %d\n", n, size, n, n-1, f)
    }
}
