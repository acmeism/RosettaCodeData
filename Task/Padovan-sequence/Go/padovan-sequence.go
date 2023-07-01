package main

import (
    "fmt"
    "math"
    "math/big"
    "strings"
)

func padovanRecur(n int) []int {
    p := make([]int, n)
    p[0], p[1], p[2] = 1, 1, 1
    for i := 3; i < n; i++ {
        p[i] = p[i-2] + p[i-3]
    }
    return p
}

func padovanFloor(n int) []int {
    var p, s, t, u = new(big.Rat), new(big.Rat), new(big.Rat), new(big.Rat)
    p, _ = p.SetString("1.324717957244746025960908854")
    s, _ = s.SetString("1.0453567932525329623")
    f := make([]int, n)
    pow := new(big.Rat).SetInt64(1)
    u = u.SetFrac64(1, 2)
    t.Quo(pow, p)
    t.Quo(t, s)
    t.Add(t, u)
    v, _ := t.Float64()
    f[0] = int(math.Floor(v))
    for i := 1; i < n; i++ {
        t.Quo(pow, s)
        t.Add(t, u)
        v, _ = t.Float64()
        f[i] = int(math.Floor(v))
        pow.Mul(pow, p)
    }
    return f
}

type LSystem struct {
    rules         map[string]string
    init, current string
}

func step(lsys *LSystem) string {
    var sb strings.Builder
    if lsys.current == "" {
        lsys.current = lsys.init
    } else {
        for _, c := range lsys.current {
            sb.WriteString(lsys.rules[string(c)])
        }
        lsys.current = sb.String()
    }
    return lsys.current
}

func padovanLSys(n int) []string {
    rules := map[string]string{"A": "B", "B": "C", "C": "AB"}
    lsys := &LSystem{rules, "A", ""}
    p := make([]string, n)
    for i := 0; i < n; i++ {
        p[i] = step(lsys)
    }
    return p
}

// assumes lists are same length
func areSame(l1, l2 []int) bool {
    for i := 0; i < len(l1); i++ {
        if l1[i] != l2[i] {
            return false
        }
    }
    return true
}

func main() {
    fmt.Println("First 20 members of the Padovan sequence:")
    fmt.Println(padovanRecur(20))
    recur := padovanRecur(64)
    floor := padovanFloor(64)
    same := areSame(recur, floor)
    s := "give"
    if !same {
        s = "do not give"
    }
    fmt.Println("\nThe recurrence and floor based functions", s, "the same results for 64 terms.")

    p := padovanLSys(32)
    lsyst := make([]int, 32)
    for i := 0; i < 32; i++ {
        lsyst[i] = len(p[i])
    }
    fmt.Println("\nFirst 10 members of the Padovan L-System:")
    fmt.Println(p[:10])
    fmt.Println("\nand their lengths:")
    fmt.Println(lsyst[:10])

    same = areSame(recur[:32], lsyst)
    s = "give"
    if !same {
        s = "do not give"
    }
    fmt.Println("\nThe recurrence and L-system based functions", s, "the same results for 32 terms.")
