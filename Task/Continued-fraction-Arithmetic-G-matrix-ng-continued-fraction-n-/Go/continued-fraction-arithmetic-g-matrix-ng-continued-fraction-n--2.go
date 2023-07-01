package cf

import (
	"fmt"
	"reflect"
	"testing"
)

func Example_NG4() {
	cases := [...]struct {
		r  Rat
		ng NG4
	}{
		{Rat{13, 11}, NG4{2, 1, 0, 2}},
		{Rat{22, 7}, NG4{2, 1, 0, 2}},
		{Rat{22, 7}, NG4{1, 0, 0, 4}},
	}
	for _, tc := range cases {
		cf := tc.r.AsContinuedFraction()
		fmt.Printf("%5s = %-9s with %v gives %v\n", tc.r, cf.String(), tc.ng,
			tc.ng.ApplyTo(cf),
		)
	}

	invSqrt2 := NG4{0, 1, 1, 0}.ApplyTo(Sqrt2)
	fmt.Println("    1/√2 =", invSqrt2)
	result := NG4{1, 1, 0, 2}.ApplyTo(Sqrt2)
	fmt.Println("(1+√2)/2 =", result)

	// Output:
	// 13/11 = [1; 5, 2] with {2 1 0 2} gives [1; 1, 2, 7]
	//  22/7 = [3; 7]    with {2 1 0 2} gives [3; 1, 1, 1, 4]
	//  22/7 = [3; 7]    with {1 0 0 4} gives [0; 1, 3, 1, 2]
	//     1/√2 = [0; 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, ...]
	// (1+√2)/2 = [1; 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, 1, 4, ...]
}
