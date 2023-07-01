package main

import "fmt"

const jobs = 12

type environment struct{ seq, cnt int }

var (
    env      [jobs]environment
    seq, cnt *int
)

func hail() {
    fmt.Printf("% 4d", *seq)
    if *seq == 1 {
        return
    }
    (*cnt)++
    if *seq&1 != 0 {
        *seq = 3*(*seq) + 1
    } else {
        *seq /= 2
    }
}

func switchTo(id int) {
    seq = &env[id].seq
    cnt = &env[id].cnt
}

func main() {
    for i := 0; i < jobs; i++ {
        switchTo(i)
        env[i].seq = i + 1
    }

again:
    for i := 0; i < jobs; i++ {
        switchTo(i)
        hail()
    }
    fmt.Println()

    for j := 0; j < jobs; j++ {
        switchTo(j)
        if *seq != 1 {
            goto again
        }
    }
    fmt.Println()

    fmt.Println("COUNTS:")
    for i := 0; i < jobs; i++ {
        switchTo(i)
        fmt.Printf("% 4d", *cnt)
    }
    fmt.Println()
}
