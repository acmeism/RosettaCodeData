package main

import (
    "fmt"
    "math/rand"
)

type symbols struct{ k, q, r, b, n rune }

var A = symbols{'K', 'Q', 'R', 'B', 'N'}
var W = symbols{'♔', '♕', '♖', '♗', '♘'}
var B = symbols{'♚', '♛', '♜', '♝', '♞'}

var krn = []string{
    "nnrkr", "nrnkr", "nrknr", "nrkrn",
    "rnnkr", "rnknr", "rnkrn",
    "rknnr", "rknrn",
    "rkrnn"}

func (sym symbols) chess960(id int) string {
    var pos [8]rune
    q, r := id/4, id%4
    pos[r*2+1] = sym.b
    q, r = q/4, q%4
    pos[r*2] = sym.b
    q, r = q/6, q%6
    for i := 0; ; i++ {
        if pos[i] != 0 {
            continue
        }
        if r == 0 {
            pos[i] = sym.q
            break
        }
        r--
    }
    i := 0
    for _, f := range krn[q] {
        for pos[i] != 0 {
            i++
        }
        switch f {
        case 'k':
            pos[i] = sym.k
        case 'r':
            pos[i] = sym.r
        case 'n':
            pos[i] = sym.n
        }
    }
    return string(pos[:])
}

func main() {
    fmt.Println(" ID  Start position")
    for _, id := range []int{0, 518, 959} {
        fmt.Printf("%3d  %s\n", id, A.chess960(id))
    }
    fmt.Println("\nRandom")
    for i := 0; i < 5; i++ {
        fmt.Println(W.chess960(rand.Intn(960)))
    }
}
