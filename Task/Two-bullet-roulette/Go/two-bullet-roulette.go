package main

import (
    "fmt"
    "math/rand"
    "strings"
    "time"
)

var cylinder = [6]bool{}

func rshift() {
    t := cylinder[5]
    for i := 4; i >= 0; i-- {
        cylinder[i+1] = cylinder[i]
    }
    cylinder[0] = t
}

func unload() {
    for i := 0; i < 6; i++ {
        cylinder[i] = false
    }
}

func load() {
    for cylinder[0] {
        rshift()
    }
    cylinder[0] = true
    rshift()
}

func spin() {
    var lim = 1 + rand.Intn(6)
    for i := 1; i < lim; i++ {
        rshift()
    }
}

func fire() bool {
    shot := cylinder[0]
    rshift()
    return shot
}

func method(s string) int {
    unload()
    for _, c := range s {
        switch c {
        case 'L':
            load()
        case 'S':
            spin()
        case 'F':
            if fire() {
                return 1
            }
        }
    }
    return 0
}

func mstring(s string) string {
    var l []string
    for _, c := range s {
        switch c {
        case 'L':
            l = append(l, "load")
        case 'S':
            l = append(l, "spin")
        case 'F':
            l = append(l, "fire")
        }
    }
    return strings.Join(l, ", ")
}

func main() {
    rand.Seed(time.Now().UnixNano())
    tests := 100000
    for _, m := range []string{"LSLSFSF", "LSLSFF", "LLSFSF", "LLSFF"} {
        sum := 0
        for t := 1; t <= tests; t++ {
            sum += method(m)
        }
        pc := float64(sum) * 100 / float64(tests)
        fmt.Printf("%-40s produces %6.3f%% deaths.\n", mstring(m), pc)
    }
}
