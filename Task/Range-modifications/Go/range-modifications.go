package main

import (
    "fmt"
    "strings"
)

type rng struct{ from, to int }

type fn func(rngs *[]rng, n int)

func (r rng) String() string { return fmt.Sprintf("%d-%d", r.from, r.to) }

func rangesAdd(rngs []rng, n int) []rng {
    if len(rngs) == 0 {
        rngs = append(rngs, rng{n, n})
        return rngs
    }
    for i, r := range rngs {
        if n < r.from-1 {
            rngs = append(rngs, rng{})
            copy(rngs[i+1:], rngs[i:])
            rngs[i] = rng{n, n}
            return rngs
        } else if n == r.from-1 {
            rngs[i] = rng{n, r.to}
            return rngs
        } else if n <= r.to {
            return rngs
        } else if n == r.to+1 {
            rngs[i] = rng{r.from, n}
            if i < len(rngs)-1 && (n == rngs[i+1].from || n+1 == rngs[i+1].from) {
                rngs[i] = rng{r.from, rngs[i+1].to}
                copy(rngs[i+1:], rngs[i+2:])
                rngs[len(rngs)-1] = rng{}
                rngs = rngs[:len(rngs)-1]
            }
            return rngs
        } else if i == len(rngs)-1 {
            rngs = append(rngs, rng{n, n})
            return rngs
        }
    }
    return rngs
}

func rangesRemove(rngs []rng, n int) []rng {
    if len(rngs) == 0 {
        return rngs
    }
    for i, r := range rngs {
        if n <= r.from-1 {
            return rngs
        } else if n == r.from && n == r.to {
            copy(rngs[i:], rngs[i+1:])
            rngs[len(rngs)-1] = rng{}
            rngs = rngs[:len(rngs)-1]
            return rngs
        } else if n == r.from {
            rngs[i] = rng{n + 1, r.to}
            return rngs
        } else if n < r.to {
            rngs[i] = rng{r.from, n - 1}
            rngs = append(rngs, rng{})
            copy(rngs[i+2:], rngs[i+1:])
            rngs[i+1] = rng{n + 1, r.to}
            return rngs
        } else if n == r.to {
            rngs[i] = rng{r.from, n - 1}
            return rngs
        }
    }
    return rngs
}

func standard(rngs []rng) string {
    if len(rngs) == 0 {
        return ""
    }
    var sb strings.Builder
    for _, r := range rngs {
        sb.WriteString(fmt.Sprintf("%s,", r))
    }
    s := sb.String()
    return s[:len(s)-1]
}

func main() {
    const add = 0
    const remove = 1
    fns := []fn{
        func(prngs *[]rng, n int) {
            *prngs = rangesAdd(*prngs, n)
            fmt.Printf("       add %2d => %s\n", n, standard(*prngs))
        },
        func(prngs *[]rng, n int) {
            *prngs = rangesRemove(*prngs, n)
            fmt.Printf("    remove %2d => %s\n", n, standard(*prngs))
        },
    }

    var rngs []rng
    ops := [][2]int{{add, 77}, {add, 79}, {add, 78}, {remove, 77}, {remove, 78}, {remove, 79}}
    fmt.Printf("Start: %q\n", standard(rngs))
    for _, op := range ops {
        fns[op[0]](&rngs, op[1])
    }

    rngs = []rng{{1, 3}, {5, 5}}
    ops = [][2]int{{add, 1}, {remove, 4}, {add, 7}, {add, 8}, {add, 6}, {remove, 7}}
    fmt.Printf("\nStart: %q\n", standard(rngs))
    for _, op := range ops {
        fns[op[0]](&rngs, op[1])
    }

    rngs = []rng{{1, 5}, {10, 25}, {27, 30}}
    ops = [][2]int{{add, 26}, {add, 9}, {add, 7}, {remove, 26}, {remove, 9}, {remove, 7}}
    fmt.Printf("\nStart: %q\n", standard(rngs))
    for _, op := range ops {
        fns[op[0]](&rngs, op[1])
    }
}
