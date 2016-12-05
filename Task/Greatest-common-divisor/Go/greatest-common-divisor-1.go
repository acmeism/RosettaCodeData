package main

import "fmt"

func gcd(a, b int) int {
    var bgcd func(a, b, res int) int

    bgcd = func(a, b, res int) int {
	switch {
	case a == b:
	    return res * a
	case a % 2 == 0 && b % 2 == 0:
	    return bgcd(a/2, b/2, 2*res)
	case a % 2 == 0:
	    return bgcd(a/2, b, res)
	case b % 2 == 0:
	    return bgcd(a, b/2, res)
	case a > b:
	    return bgcd(a-b, b, res)
	default:
	    return bgcd(a, b-a, res)
	}
    }

    return bgcd(a, b, 1)
}

func main() {
    type pair struct {
	a int
	b int
    }

    var testdata []pair = []pair{
	pair{33, 77},
	pair{49865, 69811},
    }

    for _, v := range testdata {
	fmt.Printf("gcd(%d, %d) = %d\n", v.a, v.b, gcd(v.a, v.b))
    }
}
