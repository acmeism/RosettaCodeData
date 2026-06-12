package main

import "fmt"

var (
    a   [17][17]int
    idx [4]int
)

func findGroup(ctype, min, max, depth int) bool {
    if depth == 4 {
        cs := ""
        if ctype == 0 {
            cs = "un"
        }
        fmt.Printf("Totally %sconnected group:", cs)
        for i := 0; i < 4; i++ {
            fmt.Printf(" %d", idx[i])
        }
        fmt.Println()
        return true
    }

    for i := min; i < max; i++ {
        n := 0
        for ; n < depth; n++ {
            if a[idx[n]][i] != ctype {
                break
            }
        }

        if n == depth {
            idx[n] = i
            if findGroup(ctype, 1, max, depth+1) {
                return true
            }
        }
    }
    return false
}

func main() {
    const mark = "01-"

    for i := 0; i < 17; i++ {
        a[i][i] = 2
    }

    for k := 1; k <= 8; k <<= 1 {
        for i := 0; i < 17; i++ {
            j := (i + k) % 17
            a[i][j], a[j][i] = 1, 1
        }
    }

    for i := 0; i < 17; i++ {
        for j := 0; j < 17; j++ {
            fmt.Printf("%c ", mark[a[i][j]])
        }
        fmt.Println()
    }

    // Test case breakage
    // a[2][1] = a[1][2] = 0

    // It's symmetric, so only need to test groups containing node 0.
    for i := 0; i < 17; i++ {
        idx[0] = i
        if findGroup(1, i+1, 17, 1) || findGroup(0, i+1, 17, 1) {
            fmt.Println("No good.")
            return
        }
    }
    fmt.Println("All good.")
}
