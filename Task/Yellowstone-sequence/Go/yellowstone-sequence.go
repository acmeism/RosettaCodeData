package main

import (
    "fmt"
    "log"
    "os/exec"
)

func gcd(x, y int) int {
    for y != 0 {
        x, y = y, x%y
    }
    return x
}

func yellowstone(n int) []int {
    m := make(map[int]bool)
    a := make([]int, n+1)
    for i := 1; i < 4; i++ {
        a[i] = i
        m[i] = true
    }
    min := 4
    for c := 4; c <= n; c++ {
        for i := min; ; i++ {
            if !m[i] && gcd(a[c-1], i) == 1 && gcd(a[c-2], i) > 1 {
                a[c] = i
                m[i] = true
                if i == min {
                    min++
                }
                break
            }
        }
    }
    return a[1:]
}

func check(err error) {
    if err != nil {
        log.Fatal(err)
    }
}

func main() {
    x := make([]int, 100)
    for i := 0; i < 100; i++ {
        x[i] = i + 1
    }
    y := yellowstone(100)
    fmt.Println("The first 30 Yellowstone numbers are:")
    fmt.Println(y[:30])
    g := exec.Command("gnuplot", "-persist")
    w, err := g.StdinPipe()
    check(err)
    check(g.Start())
    fmt.Fprintln(w, "unset key; plot '-'")
    for i, xi := range x {
        fmt.Fprintf(w, "%d %d\n", xi, y[i])
    }
    fmt.Fprintln(w, "e")
    w.Close()
    g.Wait()
}
