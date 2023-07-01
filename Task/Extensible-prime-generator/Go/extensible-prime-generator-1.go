package main

import (
    "container/heap"
    "fmt"
)

func main() {
    p := newP()
    fmt.Print("First twenty: ")
    for i := 0; i < 20; i++ {
        fmt.Print(p(), " ")
    }
    fmt.Print("\nBetween 100 and 150: ")
    n := p()
    for n <= 100 {
        n = p()
    }
    for ; n < 150; n = p() {
        fmt.Print(n, " ")
    }
    for n <= 7700 {
        n = p()
    }
    c := 0
    for ; n < 8000; n = p() {
        c++
    }
    fmt.Println("\nNumber beween 7,700 and 8,000:", c)
    p = newP()
    for i := 1; i < 10000; i++ {
        p()
    }
    fmt.Println("10,000th prime:", p())
}

func newP() func() int {
    n := 1
    var pq pQueue
    top := &pMult{2, 4, 0}
    return func() int {
        for {
            n++
            if n < top.pMult { // n is a new prime
                heap.Push(&pq, &pMult{prime: n, pMult: n * n})
                top = pq[0]
                return n
            }
            // n was next on the queue, it's a composite
            for top.pMult == n {
                top.pMult += top.prime
                heap.Fix(&pq, 0)
                top = pq[0]
            }
        }
    }
}

type pMult struct {
    prime int
    pMult int
    index int
}

type pQueue []*pMult

func (q pQueue) Len() int           { return len(q) }
func (q pQueue) Less(i, j int) bool { return q[i].pMult < q[j].pMult }
func (q pQueue) Swap(i, j int) {
    q[i], q[j] = q[j], q[i]
    q[i].index = i
    q[j].index = j
}
func (p *pQueue) Push(x interface{}) {
    q := *p
    e := x.(*pMult)
    e.index = len(q)
    *p = append(q, e)
}
func (p *pQueue) Pop() interface{} {
    q := *p
    last := len(q) - 1
    e := q[last]
    *p = q[:last]
    return e
}
