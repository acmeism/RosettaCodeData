package main

import "fmt"

// a towers of hanoi solver just has one method, play
type solver interface {
    play(int)
}

func main() {
    var t solver    // declare variable of solver type
    t = new(towers) // type towers must satisfy solver interface
    t.play(4)
}

// towers is example of type satisfying solver interface
type towers struct {
    // an empty struct.  some other solver might fill this with some
    // data representation, maybe for algorithm validation, or maybe for
    // visualization.
}

// play is sole method required to implement solver type
func (t *towers) play(n int) {
    // drive recursive solution, per task description
    t.moveN(n, 1, 2, 3)
}

// recursive algorithm
func (t *towers) moveN(n, from, to, via int) {
    if n > 0 {
        t.moveN(n-1, from, via, to)
        t.move1(from, to)
        t.moveN(n-1, via, to, from)
    }
}

// example function prints actions to screen.
// enhance with validation or visualization as needed.
func (t *towers) move1(from, to int) {
    fmt.Println("move disk from rod", from, "to rod", to)
}
