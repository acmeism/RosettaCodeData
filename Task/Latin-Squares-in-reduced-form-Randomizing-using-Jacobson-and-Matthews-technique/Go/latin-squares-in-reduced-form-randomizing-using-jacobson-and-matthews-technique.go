package main

import (
    "fmt"
    "math/rand"
    "time"
)

type (
    vector []int
    matrix []vector
    cube   []matrix
)

func toReduced(m matrix) matrix {
    n := len(m)
    r := make(matrix, n)
    for i := 0; i < n; i++ {
        r[i] = make(vector, n)
        copy(r[i], m[i])
    }
    for j := 0; j < n-1; j++ {
        if r[0][j] != j {
            for k := j + 1; k < n; k++ {
                if r[0][k] == j {
                    for i := 0; i < n; i++ {
                        r[i][j], r[i][k] = r[i][k], r[i][j]
                    }
                    break
                }
            }
        }
    }
    for i := 1; i < n-1; i++ {
        if r[i][0] != i {
            for k := i + 1; k < n; k++ {
                if r[k][0] == i {
                    for j := 0; j < n; j++ {
                        r[i][j], r[k][j] = r[k][j], r[i][j]
                    }
                    break
                }
            }
        }
    }
    return r
}

// 'm' is assumed to be 0 based
func printMatrix(m matrix) {
    n := len(m)
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            fmt.Printf("%2d ", m[i][j]+1) // back to 1 based
        }
        fmt.Println()
    }
    fmt.Println()
}

// converts 4 x 4 matrix to 'flat' array
func asArray16(m matrix) [16]int {
    var a [16]int
    k := 0
    for i := 0; i < 4; i++ {
        for j := 0; j < 4; j++ {
            a[k] = m[i][j]
            k++
        }
    }
    return a
}

// converts 5 x 5 matrix to 'flat' array
func asArray25(m matrix) [25]int {
    var a [25]int
    k := 0
    for i := 0; i < 5; i++ {
        for j := 0; j < 5; j++ {
            a[k] = m[i][j]
            k++
        }
    }
    return a
}

// 'a' is assumed to be 0 based
func printArray16(a [16]int) {
    for i := 0; i < 4; i++ {
        for j := 0; j < 4; j++ {
            k := i*4 + j
            fmt.Printf("%2d ", a[k]+1) // back to 1 based
        }
        fmt.Println()
    }
    fmt.Println()
}

func shuffleCube(c cube) {
    n := len(c[0])
    proper := true
    var rx, ry, rz int
    for {
        rx = rand.Intn(n)
        ry = rand.Intn(n)
        rz = rand.Intn(n)
        if c[rx][ry][rz] == 0 {
            break
        }
    }
    for {
        var ox, oy, oz int
        for ; ox < n; ox++ {
            if c[ox][ry][rz] == 1 {
                break
            }
        }
        if !proper && rand.Intn(2) == 0 {
            for ox++; ox < n; ox++ {
                if c[ox][ry][rz] == 1 {
                    break
                }
            }
        }

        for ; oy < n; oy++ {
            if c[rx][oy][rz] == 1 {
                break
            }
        }
        if !proper && rand.Intn(2) == 0 {
            for oy++; oy < n; oy++ {
                if c[rx][oy][rz] == 1 {
                    break
                }
            }
        }

        for ; oz < n; oz++ {
            if c[rx][ry][oz] == 1 {
                break
            }
        }
        if !proper && rand.Intn(2) == 0 {
            for oz++; oz < n; oz++ {
                if c[rx][ry][oz] == 1 {
                    break
                }
            }
        }

        c[rx][ry][rz]++
        c[rx][oy][oz]++
        c[ox][ry][oz]++
        c[ox][oy][rz]++

        c[rx][ry][oz]--
        c[rx][oy][rz]--
        c[ox][ry][rz]--
        c[ox][oy][oz]--

        if c[ox][oy][oz] < 0 {
            rx, ry, rz = ox, oy, oz
            proper = false
        } else {
            proper = true
            break
        }
    }
}

func toMatrix(c cube) matrix {
    n := len(c[0])
    m := make(matrix, n)
    for i := 0; i < n; i++ {
        m[i] = make(vector, n)
    }
    for i := 0; i < n; i++ {
        for j := 0; j < n; j++ {
            for k := 0; k < n; k++ {
                if c[i][j][k] != 0 {
                    m[i][j] = k
                    break
                }
            }
        }
    }
    return m
}

// 'from' matrix is assumed to be 1 based
func makeCube(from matrix, n int) cube {
    c := make(cube, n)
    for i := 0; i < n; i++ {
        c[i] = make(matrix, n)
        for j := 0; j < n; j++ {
            c[i][j] = make(vector, n)
            var k int
            if from == nil {
                k = (i + j) % n
            } else {
                k = from[i][j] - 1
            }
            c[i][j][k] = 1
        }
    }
    return c
}

func main() {
    rand.Seed(time.Now().UnixNano())

    // part 1
    fmt.Println("PART 1: 10,000 latin Squares of order 4 in reduced form:\n")
    from := matrix{{1, 2, 3, 4}, {2, 1, 4, 3}, {3, 4, 1, 2}, {4, 3, 2, 1}}
    freqs4 := make(map[[16]int]int, 10000)
    c := makeCube(from, 4)
    for i := 1; i <= 10000; i++ {
        shuffleCube(c)
        m := toMatrix(c)
        rm := toReduced(m)
        a16 := asArray16(rm)
        freqs4[a16]++
    }
    for a, freq := range freqs4 {
        printArray16(a)
        fmt.Printf("Occurs %d times\n\n", freq)
    }

    // part 2
    fmt.Println("\nPART 2: 10,000 latin squares of order 5 in reduced form:")
    from = matrix{{1, 2, 3, 4, 5}, {2, 3, 4, 5, 1}, {3, 4, 5, 1, 2},
        {4, 5, 1, 2, 3}, {5, 1, 2, 3, 4}}
    freqs5 := make(map[[25]int]int, 10000)
    c = makeCube(from, 5)
    for i := 1; i <= 10000; i++ {
        shuffleCube(c)
        m := toMatrix(c)
        rm := toReduced(m)
        a25 := asArray25(rm)
        freqs5[a25]++
    }
    count := 0
    for _, freq := range freqs5 {
        count++
        if count > 1 {
            fmt.Print(", ")
        }
        if (count-1)%8 == 0 {
            fmt.Println()
        }
        fmt.Printf("%2d(%3d)", count, freq)
    }
    fmt.Println("\n")

    // part 3
    fmt.Println("\nPART 3: 750 latin squares of order 42, showing the last one:\n")
    var m42 matrix
    c = makeCube(nil, 42)
    for i := 1; i <= 750; i++ {
        shuffleCube(c)
        if i == 750 {
            m42 = toMatrix(c)
        }
    }
    printMatrix(m42)

    // part 4
    fmt.Println("\nPART 4: 1000 latin squares of order 256:\n")
    start := time.Now()
    c = makeCube(nil, 256)
    for i := 1; i <= 1000; i++ {
        shuffleCube(c)
    }
    elapsed := time.Since(start)
    fmt.Printf("Generated in %s\n", elapsed)
}
