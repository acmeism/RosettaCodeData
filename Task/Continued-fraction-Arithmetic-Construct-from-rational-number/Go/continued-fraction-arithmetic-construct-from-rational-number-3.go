package cf

import (
	"fmt"
	"math"
)

func Example_ConstructFromRational() {
	cases := [...]Rat{
		{1, 2},
		{3, 1},
		{23, 8},
		{13, 11},
		{22, 7},
		{-151, 77},
	}
	for _, r := range cases {
		fmt.Printf("%7s = %s\n", r, r.AsContinuedFraction())
	}

	for _, tc := range [...]struct {
		name   string
		approx float64
		cf     ContinuedFraction
		d1, d2 int64
	}{
		{"√2", math.Sqrt2, Sqrt2, 1e4, 1e8},
		{"π", math.Pi, nil, 10, 1e10},
		{"ϕ", math.Phi, Phi, 10, 1e5},
		{"e", math.E, E, 1e5, 1e9},
	} {
		fmt.Printf("\nApproximating %s ≅ %v:\n", tc.name, tc.approx)
		for d := tc.d1; d < tc.d2; d *= 10 {
			n := int64(math.Round(tc.approx * float64(d)))
			r := Rat{n, d}
			fmt.Println(r, "=", r.AsContinuedFraction())
		}
		if tc.cf != nil {
			wid := int(math.Log10(float64(tc.d2)))*2 + 2 // ick
			fmt.Printf("%*s: %v\n", wid, "Actual", tc.cf)
		}
	}

	// Output:
	// [… commented output used by go test omitted for
	//    Rosetta Code listing; it is the same as below …]
}
