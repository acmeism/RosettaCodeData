package main

import "fmt"

// Define enough of a ring to meet the needs of the task.  Addition and
// multiplication are mentioned in the task; multiplicative identity is not
// mentioned but is useful for the power function.

type ring interface {
    add(ringElement, ringElement) ringElement
    mul(ringElement, ringElement) ringElement
    mulIdent() ringElement
}

type ringElement interface{}

// Define a power function that works for any ring.

func ringPow(r ring, a ringElement, p uint) (pow ringElement) {
    for pow = r.mulIdent(); p > 0; p-- {
        pow = r.mul(pow, a)
    }
    return
}

// The task function f has that constant 1 in it.
// Define a special kind of ring that has this element.

type oneRing interface {
    ring
    one() ringElement // return ring element corresponding to '1'
}

// Now define the required function f.
// It works for any ring (that has a "one.")

func f(r oneRing, x ringElement) ringElement {
    return r.add(r.add(ringPow(r, x, 100), x), r.one())
}

// With rings and the function f defined in a general way, now define
// the specific ring of integers modulo n.

type modRing uint // value is congruence modulus n

func (m modRing) add(a, b ringElement) ringElement {
    return (a.(uint) + b.(uint)) % uint(m)
}

func (m modRing) mul(a, b ringElement) ringElement {
    return (a.(uint) * b.(uint)) % uint(m)
}

func (modRing) mulIdent() ringElement { return uint(1) }

func (modRing) one() ringElement { return uint(1) }

// Demonstrate the general function f on the specific ring with the
// specific values.

func main() {
    fmt.Println(f(modRing(13), uint(10)))
}
