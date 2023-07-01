package main

import (
    "fmt"
    "math/rand"
    "time"
)

// Generic Knuth Shuffle algorithm.  In Go, this is done with interface
// types.  The parameter s of function shuffle is an interface type.
// Any type satisfying the interface "shuffler" can be shuffled with
// this function.  Since the shuffle function uses the random number
// generator, it's nice to seed the generator at program load time.
func init() {
    rand.Seed(time.Now().UnixNano())
}
func shuffle(s shuffler) {
    for i := s.Len() - 1; i >= 1; i-- {
        j := rand.Intn(i + 1)
        s.Swap(i, j)
    }
}

// Conceptually, a shuffler is an indexed collection of things.
// It requires just two simple methods.
type shuffler interface {
    Len() int      // number of things in the collection
    Swap(i, j int) // swap the two things indexed by i and j
}

// ints is an example of a concrete type implementing the shuffler
// interface.
type ints []int

func (s ints) Len() int      { return len(s) }
func (s ints) Swap(i, j int) { s[i], s[j] = s[j], s[i] }

// Example program.  Make an ints collection, fill with sequential numbers,
// print, shuffle, print.
func main() {
    a := make(ints, 20)
    for i := range a {
        a[i] = i
    }
    fmt.Println(a)
    shuffle(a)
    fmt.Println(a)
}
