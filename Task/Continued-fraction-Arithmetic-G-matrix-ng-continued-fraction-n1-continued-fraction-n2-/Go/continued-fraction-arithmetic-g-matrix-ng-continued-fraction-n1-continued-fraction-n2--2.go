package cf

import "fmt"

func ExampleNG8() {
	cases := [...]struct {
		op     string
		r1, r2 Rat
		ng     NG8
	}{
		{"+", Rat{22, 7}, Rat{1, 2}, NG8Add},
		{"*", Rat{13, 11}, Rat{22, 7}, NG8Mul},
		{"-", Rat{13, 11}, Rat{22, 7}, NG8Sub},
		{"/", Rat{22 * 22, 7 * 7}, Rat{22, 7}, NG8Div},
	}
	for _, tc := range cases {
		n1 := tc.r1.AsContinuedFraction()
		n2 := tc.r2.AsContinuedFraction()
		z := tc.ng.ApplyTo(n1, n2, 1000)
		fmt.Printf("%v %s %v is %v %v %v gives %v\n",
			tc.r1, tc.op, tc.r2,
			tc.ng, n1, n2, z,
		)
	}

	z := NG8Mul.ApplyTo(Sqrt2, Sqrt2, 1000)
	fmt.Println("√2 * √2 =", z)

	// Output:
	// 22/7 + 1/2 is {0 1 1 0 0 0 0 1} [3; 7] [0; 2] gives [3; 1, 1, 1, 4]
	// 13/11 * 22/7 is {1 0 0 0 0 0 0 1} [1; 5, 2] [3; 7] gives [3; 1, 2, 2]
	// 13/11 - 22/7 is {0 1 -1 0 0 0 0 1} [1; 5, 2] [3; 7] gives [-1; -1, -24, -1, -2]
	// 484/49 / 22/7 is {0 1 0 0 0 0 1 0} [9; 1, 7, 6] [3; 7] gives [3; 7]
	// √2 * √2 = [1; 0, 1]
}
