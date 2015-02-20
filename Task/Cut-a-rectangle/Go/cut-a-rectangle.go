package main

import "fmt"

var grid []byte
var w, h, last int
var cnt int
var next [4]int
var dir = [4][2]int{{0, -1}, {-1, 0}, {0, 1}, {1, 0}}

func walk(y, x int) {
    if y == 0 || y == h || x == 0 || x == w {
        cnt += 2
        return
    }
    t := y*(w+1) + x
    grid[t]++
    grid[last-t]++
    for i, d := range dir {
        if grid[t+next[i]] == 0 {
            walk(y+d[0], x+d[1])
        }
    }
    grid[t]--
    grid[last-t]--
}

func solve(hh, ww, recur int) int {
    h = hh
    w = ww

    if h&1 != 0 {
        h, w = w, h
    }
    switch {
    case h&1 == 1:
        return 0
    case w == 1:
        return 1
    case w == 2:
        return h
    case h == 2:
        return w
    }
    cy := h / 2
    cx := w / 2

    grid = make([]byte, (h+1)*(w+1))
    last = len(grid) - 1
    next[0] = -1
    next[1] = -w - 1
    next[2] = 1
    next[3] = w + 1

    if recur != 0 {
        cnt = 0
    }
    for x := cx + 1; x < w; x++ {
        t := cy*(w+1) + x
        grid[t] = 1
        grid[last-t] = 1
        walk(cy-1, x)
    }
    cnt++

    if h == w {
        cnt *= 2
    } else if w&1 == 0 && recur != 0 {
        solve(w, h, 0)
    }
    return cnt
}

func main() {
    for y := 1; y <= 10; y++ {
        for x := 1; x <= y; x++ {
            if x&1 == 0 || y&1 == 0 {
                fmt.Printf("%d x %d: %d\n", y, x, solve(y, x, 1))
            }
        }
    }
}
