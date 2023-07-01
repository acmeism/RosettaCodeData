package main

import "fmt"

type U0 struct {
	error
	s string
}
type U1 int

func foo2() {
	defer func() {
		// We can't just "catch" U0 and ignore U1 directly but ...
		if e := recover(); e != nil {
			// e can be of any type, check for type U0
			if x, ok := e.(*U0); ok {
				// we can only execute code here,
				// not return to the body of foo2
				fmt.Println("Recovered U0:", x.s)
				// We could cheat and call bar the second time
				// from here, if it paniced again (even with U0)
				// it wouldn't get recovered.
				// Instead we've split foo into two calls to foo2.
			} else {
				// ... if we don't want to handle it we can
				// pass it along.
				fmt.Println("passing on:", e)
				panic(e) // like a "re-throw"
			}
		}
	}()
	bar()
}

func foo() {
	// Call bar twice via foo2
	foo2()
	foo2()
	fmt.Println("not reached")
}

func bar() int {
	return baz()
}

var done bool

func baz() int {
	if !done {
		done = true
		panic(&U0{nil, "a message"})
	}
	panic(U1(42))
}

func main() {
	foo()
	fmt.Println("No panic")
}
