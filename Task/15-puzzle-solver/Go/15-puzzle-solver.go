package main

import "fmt"

var (
    Nr = [16]int{3, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3}
    Nc = [16]int{3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2}
)

var (
    n, _n      int
    N0, N3, N4 [85]int
    N2         [85]uint64
)

const (
    i = 1
    g = 8
    e = 2
    l = 4
)

func fY() bool {
    if N2[n] == 0x123456789abcdef0 {
        return true
    }
    if N4[n] <= _n {
        return fN()
    }
    return false
}

func fZ(w int) bool {
    if w&i > 0 {
        fI()
        if fY() {
            return true
        }
        n--
    }
    if w&g > 0 {
        fG()
        if fY() {
            return true
        }
        n--
    }
    if w&e > 0 {
        fE()
        if fY() {
            return true
        }
        n--
    }
    if w&l > 0 {
        fL()
        if fY() {
            return true
        }
        n--
    }
    return false
}

func fN() bool {
    switch N0[n] {
    case 0:
        switch N3[n] {
        case 'l':
            return fZ(i)
        case 'u':
            return fZ(e)
        default:
            return fZ(i + e)
        }
    case 3:
        switch N3[n] {
        case 'r':
            return fZ(i)
        case 'u':
            return fZ(l)
        default:
            return fZ(i + l)
        }
    case 1, 2:
        switch N3[n] {
        case 'l':
            return fZ(i + l)
        case 'r':
            return fZ(i + e)
        case 'u':
            return fZ(e + l)
        default:
            return fZ(l + e + i)
        }
    case 12:
        switch N3[n] {
        case 'l':
            return fZ(g)
        case 'd':
            return fZ(e)
        default:
            return fZ(e + g)
        }
    case 15:
        switch N3[n] {
        case 'r':
            return fZ(g)
        case 'd':
            return fZ(l)
        default:
            return fZ(g + l)
        }
    case 13, 14:
        switch N3[n] {
        case 'l':
            return fZ(g + l)
        case 'r':
            return fZ(e + g)
        case 'd':
            return fZ(e + l)
        default:
            return fZ(g + e + l)
        }
    case 4, 8:
        switch N3[n] {
        case 'l':
            return fZ(i + g)
        case 'u':
            return fZ(g + e)
        case 'd':
            return fZ(i + e)
        default:
            return fZ(i + g + e)
        }
    case 7, 11:
        switch N3[n] {
        case 'd':
            return fZ(i + l)
        case 'u':
            return fZ(g + l)
        case 'r':
            return fZ(i + g)
        default:
            return fZ(i + g + l)
        }
    default:
        switch N3[n] {
        case 'd':
            return fZ(i + e + l)
        case 'l':
            return fZ(i + g + l)
        case 'r':
            return fZ(i + g + e)
        case 'u':
            return fZ(g + e + l)
        default:
            return fZ(i + g + e + l)
        }
    }
}

func fI() {
    g := (11 - N0[n]) * 4
    a := N2[n] & uint64(15<<uint(g))
    N0[n+1] = N0[n] + 4
    N2[n+1] = N2[n] - a + (a << 16)
    N3[n+1] = 'd'
    N4[n+1] = N4[n]
    cond := Nr[a>>uint(g)] <= N0[n]/4
    if !cond {
        N4[n+1]++
    }
    n++
}

func fG() {
    g := (19 - N0[n]) * 4
    a := N2[n] & uint64(15<<uint(g))
    N0[n+1] = N0[n] - 4
    N2[n+1] = N2[n] - a + (a >> 16)
    N3[n+1] = 'u'
    N4[n+1] = N4[n]
    cond := Nr[a>>uint(g)] >= N0[n]/4
    if !cond {
        N4[n+1]++
    }
    n++
}

func fE() {
    g := (14 - N0[n]) * 4
    a := N2[n] & uint64(15<<uint(g))
    N0[n+1] = N0[n] + 1
    N2[n+1] = N2[n] - a + (a << 4)
    N3[n+1] = 'r'
    N4[n+1] = N4[n]
    cond := Nc[a>>uint(g)] <= N0[n]%4
    if !cond {
        N4[n+1]++
    }
    n++
}

func fL() {
    g := (16 - N0[n]) * 4
    a := N2[n] & uint64(15<<uint(g))
    N0[n+1] = N0[n] - 1
    N2[n+1] = N2[n] - a + (a >> 4)
    N3[n+1] = 'l'
    N4[n+1] = N4[n]
    cond := Nc[a>>uint(g)] >= N0[n]%4
    if !cond {
        N4[n+1]++
    }
    n++
}

func fifteenSolver(n int, g uint64) {
    N0[0] = n
    N2[0] = g
    N4[0] = 0
}

func solve() {
    if fN() {
        fmt.Print("Solution found in ", n, " moves: ")
        for g := 1; g <= n; g++ {
            fmt.Printf("%c", N3[g])
        }
        fmt.Println()
    } else {
        n = 0
        _n++
        solve()
    }
}

func main() {
    fifteenSolver(8, 0xfe169b4c0a73d852)
    solve()
}
