package main

import "fmt"

// Using a method bound to a function type:

// fn is a simple function taking an integer and returning another.
type fn func(int) int

// fs applies fn to each argument returning all results.
func (f fn) fs(s ...int) (r []int) {
	for _, i := range s {
		r = append(r, f(i))
	}
	return r
}

// Two simple functions for demonstration.
func f1(i int) int { return i * 2 }
func f2(i int) int { return i * i }

// Another way:

// addn returns a function that adds n to a sequence of numbers
func addn(n int) func(...int) []int {
	return func(s ...int) []int {
		var r []int
		for _, i := range s {
			r = append(r, n+i)
		}
		return r
	}
}

func main() {
	// Turning a method into a function bound to it's reciever:
	fsf1 := fn(f1).fs
	fsf2 := fn(f2).fs
	// Or using a function that returns a function:
	fsf3 := addn(100)

	s := []int{0, 1, 2, 3}
	fmt.Println("For s =", s)
	fmt.Println("  fsf1:", fsf1(s...))       // Called with a slice
	fmt.Println("  fsf2:", fsf2(0, 1, 2, 3)) // ... or with individual arguments
	fmt.Println("  fsf3:", fsf3(0, 1, 2, 3))
	fmt.Println("  fsf2(fsf1):", fsf2(fsf1(s...)...))

	s = []int{2, 4, 6, 8}
	fmt.Println("For s =", s)
	fmt.Println("  fsf1:", fsf1(2, 4, 6, 8))
	fmt.Println("  fsf2:", fsf2(s...))
	fmt.Println("  fsf3:", fsf3(s...))
	fmt.Println("  fsf3(fsf1):", fsf3(fsf1(s...)...))
}
