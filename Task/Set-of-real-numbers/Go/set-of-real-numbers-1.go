package main

import "fmt"

type Set func(float64) bool

func Union(a, b Set) Set      { return func(x float64) bool { return a(x) || b(x) } }
func Inter(a, b Set) Set      { return func(x float64) bool { return a(x) && b(x) } }
func Diff(a, b Set) Set       { return func(x float64) bool { return a(x) && !b(x) } }
func open(a, b float64) Set   { return func(x float64) bool { return a < x && x < b } }
func closed(a, b float64) Set { return func(x float64) bool { return a <= x && x <= b } }
func opCl(a, b float64) Set   { return func(x float64) bool { return a < x && x <= b } }
func clOp(a, b float64) Set   { return func(x float64) bool { return a <= x && x < b } }

func main() {
	s := make([]Set, 4)
	s[0] = Union(opCl(0, 1), clOp(0, 2))  // (0,1] ∪ [0,2)
	s[1] = Inter(clOp(0, 2), opCl(1, 2))  // [0,2) ∩ (1,2]
	s[2] = Diff(clOp(0, 3), open(0, 1))   // [0,3) − (0,1)
	s[3] = Diff(clOp(0, 3), closed(0, 1)) // [0,3) − [0,1]

	for i := range s {
		for x := float64(0); x < 3; x++ {
			fmt.Printf("%v ∈ s%d: %t\n", x, i, s[i](x))
		}
		fmt.Println()
	}
}
