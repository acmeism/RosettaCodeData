package main

import (
    "fmt"
    "math"
    "math/rand"
    "time"
)

var (
    dists = calcDists()
    dirs  = [8]int{1, -1, 10, -10, 9, 11, -11, -9} // all 8 neighbors
)

// distances
func calcDists() []float64 {
    dists := make([]float64, 10000)
    for i := 0; i < 10000; i++ {
        ab, cd := math.Floor(float64(i)/100), float64(i%100)
        a, b := math.Floor(ab/10), float64(int(ab)%10)
        c, d := math.Floor(cd/10), float64(int(cd)%10)
        dists[i] = math.Hypot(a-c, b-d)
    }
    return dists
}

// index into lookup table of float64s
func dist(ci, cj int) float64 {
    return dists[cj*100+ci]
}

// energy at s, to be minimized
func Es(path []int) float64 {
    d := 0.0
    for i := 0; i < len(path)-1; i++ {
        d += dist(path[i], path[i+1])
    }
    return d
}

// temperature function, decreases to 0
func T(k, kmax, kT int) float64 {
    return (1 - float64(k)/float64(kmax)) * float64(kT)
}

// variation of E, from state s to state s_next
func dE(s []int, u, v int) float64 {
    su, sv := s[u], s[v]
    // old
    a, b, c, d := dist(s[u-1], su), dist(s[u+1], su), dist(s[v-1], sv), dist(s[v+1], sv)
    // new
    na, nb, nc, nd := dist(s[u-1], sv), dist(s[u+1], sv), dist(s[v-1], su), dist(s[v+1], su)
    if v == u+1 {
        return (na + nd) - (a + d)
    } else if u == v+1 {
        return (nc + nb) - (c + b)
    } else {
        return (na + nb + nc + nd) - (a + b + c + d)
    }
}

// probability to move from s to s_next
func P(deltaE float64, k, kmax, kT int) float64 {
    return math.Exp(-deltaE / T(k, kmax, kT))
}

func sa(kmax, kT int) {
    rand.Seed(time.Now().UnixNano())
    temp := make([]int, 99)
    for i := 0; i < 99; i++ {
        temp[i] = i + 1
    }
    rand.Shuffle(len(temp), func(i, j int) {
        temp[i], temp[j] = temp[j], temp[i]
    })
    s := make([]int, 101) // all 0 by default
    copy(s[1:], temp)     // random path from 0 to 0
    fmt.Println("kT =", kT)
    fmt.Printf("E(s0) %f\n\n", Es(s)) // random starter
    Emin := Es(s)                     // E0
    for k := 0; k <= kmax; k++ {
        if k%(kmax/10) == 0 {
            fmt.Printf("k:%10d   T: %8.4f   Es: %8.4f\n", k, T(k, kmax, kT), Es(s))
        }
        u := 1 + rand.Intn(99)          // city index 1 to 99
        cv := s[u] + dirs[rand.Intn(8)] // city number
        if cv <= 0 || cv >= 100 {       // bogus city
            continue
        }
        if dist(s[u], cv) > 5 { // check true neighbor (eg 0 9)
            continue
        }
        v := s[cv] // city index
        deltae := dE(s, u, v)
        if deltae < 0 || // always move if negative
            P(deltae, k, kmax, kT) >= rand.Float64() {
            s[u], s[v] = s[v], s[u]
            Emin += deltae
        }
    }
    fmt.Printf("\nE(s_final) %f\n", Emin)
    fmt.Println("Path:")
    // output final state
    for i := 0; i < len(s); i++ {
        if i > 0 && i%10 == 0 {
            fmt.Println()
        }
        fmt.Printf("%4d", s[i])
    }
    fmt.Println()
}

func main() {
    sa(1e6, 1)
}
