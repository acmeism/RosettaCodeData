package main

import (
    "fmt"
    "math/rand"
    "sort"
    "time"
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

func reducedLatinSquares(n int) []matrix {
    var rls []matrix
    if n < 0 {
        n = 0
    }
    rlatin := make(matrix, n)
    for i := 0; i < n; i++ {
        rlatin[i] = make([]int, n)
    }
    if n <= 1 {
        return append(rls, rlatin)
    }
    // first row
    for j := 0; j < n; j++ {
        rlatin[0][j] = j + 1
    }
    // recursive closure to compute reduced latin squares
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
                rl := copyMatrix(rlatin)
                rls = append(rls, rl)
            }
        }
        return
    }

    // remaining rows
    recurse(2)
    return rls
}

func copyMatrix(m matrix) matrix {
    le := len(m)
    cpy := make(matrix, le)
    for i := 0; i < le; i++ {
        cpy[i] = make([]int, le)
        copy(cpy[i], m[i])
    }
    return cpy
}

func printSquare(latin matrix, n int) {
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            fmt.Printf("%d ", latin[i][j]-1)
        }
        fmt.Println()
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

// generate permutations of first n numbers, starting from 0.
func pList(n int) matrix {
    fact := factorial(uint64(n))
    perms := make(matrix, fact)
    a := make([]int, n)
    for i := 0; i < n; i++ {
        a[i] = i
    }
    t := make([]int, n)
    copy(t, a)
    perms[0] = t
    n--
    var i, j int
    for c := uint64(1); c < fact; c++ {
        i = n - 1
        j = n
        for a[i] > a[i+1] {
            i--
        }
        for a[j] < a[i] {
            j--
        }
        a[i], a[j] = a[j], a[i]
        j = n
        i++
        for i < j {
            a[i], a[j] = a[j], a[i]
            i++
            j--
        }
        t := make([]int, n+1)
        copy(t, a)
        perms[c] = t
    }
    return perms
}

func generateLatinSquares(n, tests, echo int) {
    rls := reducedLatinSquares(n)
    perms := pList(n)
    perms2 := pList(n - 1)
    for test := 0; test < tests; test++ {
        rn := rand.Intn(len(rls))
        rl := rls[rn] // select reduced random square at random
        rn = rand.Intn(len(perms))
        rp := perms[rn] // select a random permuation of 'rl's columns
        // permute columns
        t := make(matrix, n)
        for i := 0; i < n; i++ {
            t[i] = make([]int, n)
        }
        for i := 0; i < n; i++ {
            for j := 0; j < n; j++ {
                t[i][j] = rl[i][rp[j]]
            }
        }
        rn = rand.Intn(len(perms2))
        rp = perms2[rn] // select a random permutation of 't's rows 2 to n
        // permute rows 2 to n
        u := make(matrix, n)
        for i := 0; i < n; i++ {
            u[i] = make([]int, n)
        }
        for i := 0; i < n; i++ {
            for j := 0; j < n; j++ {
                if i == 0 {
                    u[i][j] = t[i][j]
                } else {
                    u[i][j] = t[rp[i-1]+1][j]
                }
            }
        }
        if test < echo {
            printSquare(u, n)
        }
        if n == 4 {
            for i := 0; i < 4; i++ {
                for j := 0; j < 4; j++ {
                    u[i][j]--
                }
            }
            for i := 0; i < 4; i++ {
                copy(a[4*i:], u[i])
            }
            for i := 0; i < 4; i++ {
                if testSquares[i] == a {
                    counts[i]++
                    break
                }
            }
        }
    }
}

var testSquares = [4][16]int{
    {0, 1, 2, 3, 1, 0, 3, 2, 2, 3, 0, 1, 3, 2, 1, 0},
    {0, 1, 2, 3, 1, 0, 3, 2, 2, 3, 1, 0, 3, 2, 0, 1},
    {0, 1, 2, 3, 1, 2, 3, 0, 2, 3, 0, 1, 3, 0, 1, 2},
    {0, 1, 2, 3, 1, 3, 0, 2, 2, 0, 3, 1, 3, 2, 1, 0},
}

var (
    counts [4]int
    a      [16]int
)

func main() {
    rand.Seed(time.Now().UnixNano())
    fmt.Println("Two randomly generated latin squares of order 5 are:\n")
    generateLatinSquares(5, 2, 2)

    fmt.Println("Out of 1,000,000 randomly generated latin squares of order 4, ")
    fmt.Println("of which there are 576 instances ( => expected 1736 per instance),")
    fmt.Println("the following squares occurred the number of times shown:\n")
    generateLatinSquares(4, 1e6, 0)
    for i := 0; i < 4; i++ {
        fmt.Println(testSquares[i][:], ":", counts[i])
    }

    fmt.Println("\nA randomly generated latin square of order 6 is:\n")
    generateLatinSquares(6, 1, 1)
}
