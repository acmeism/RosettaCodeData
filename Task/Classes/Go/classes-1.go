package main

import "fmt"

// a basic "class."
// In quotes because Go does not use that term or have that exact concept.
// Go simply has types that can have methods.
type picnicBasket struct {
    nServings int // "instance variables"
    corkscrew bool
}

// a method (yes, Go uses the word method!)
func (b *picnicBasket) happy() bool {
    return b.nServings > 1 && b.corkscrew
}

// a "constructor."
// Also in quotes as Go does not have that exact mechanism as part of the
// language.  A common idiom however, is a function with the name new<Type>,
// that returns a new object of the type, fully initialized as needed and
// ready to use.  It makes sense to use this kind of constructor function when
// non-trivial initialization is needed.  In cases where the concise syntax
// shown is sufficient however, it is not idiomatic to define the function.
// Rather, code that needs a new object would simply contain &picnicBasket{...
func newPicnicBasket(nPeople int) *picnicBasket {
    // arbitrary code to interpret arguments, check resources, etc.
    // ...
    // return data new object.
    // this is the concise syntax.  there are other ways of doing it.
    return &picnicBasket{nPeople, nPeople > 0}
}

// how to instantiate it.
func main() {
    var pb picnicBasket          // create on stack (probably)
    pbl := picnicBasket{}        // equivalent to above
    pbp := &picnicBasket{}       // create on heap.  pbp is pointer to object.
    pbn := new(picnicBasket)     // equivalent to above
    forTwo := newPicnicBasket(2) // using constructor
    // equivalent to above.  field names, called keys, are optional.
    forToo := &picnicBasket{nServings: 2, corkscrew: true}

    fmt.Println(pb.nServings, pb.corkscrew)
    fmt.Println(pbl.nServings, pbl.corkscrew)
    fmt.Println(pbp)
    fmt.Println(pbn)
    fmt.Println(forTwo)
    fmt.Println(forToo)
}
