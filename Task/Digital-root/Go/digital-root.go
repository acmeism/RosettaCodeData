package main

import (
	"fmt"
	"log"
	"strconv"
)

func Sum(i uint64, base int) (sum int) {
	b64 := uint64(base)
	for ; i > 0; i /= b64 {
		sum += int(i % b64)
	}
	return
}

func DigitalRoot(n uint64, base int) (persistence, root int) {
	root = int(n)
	for x := n; x >= uint64(base); x = uint64(root) {
		root = Sum(x, base)
		persistence++
	}
	return
}

// Normally the below would be moved to a *_test.go file and
// use the testing package to be runnable as a regular test.

var testCases = []struct {
	n           string
	base        int
	persistence int
	root        int
}{
	{"627615", 10, 2, 9},
	{"39390", 10, 2, 6},
	{"588225", 10, 2, 3},
	{"393900588225", 10, 2, 9},
	{"1", 10, 0, 1},
	{"11", 10, 1, 2},
	{"e", 16, 0, 0xe},
	{"87", 16, 1, 0xf},
	// From Applesoft BASIC example:
	{"DigitalRoot", 30, 2, 26}, // 26 is Q base 30
	// From C++ example:
	{"448944221089", 10, 3, 1},
	{"7e0", 16, 2, 0x6},
	{"14e344", 16, 2, 0xf},
	{"d60141", 16, 2, 0xa},
	{"12343210", 16, 2, 0x1},
	// From the D example:
	{"1101122201121110011000000", 3, 3, 1},
}

func main() {
	for _, tc := range testCases {
		n, err := strconv.ParseUint(tc.n, tc.base, 64)
		if err != nil {
			log.Fatal(err)
		}
		p, r := DigitalRoot(n, tc.base)
		fmt.Printf("%12v (base %2d) has additive persistence %d and digital root %s\n",
			tc.n, tc.base, p, strconv.FormatInt(int64(r), tc.base))
		if p != tc.persistence || r != tc.root {
			log.Fatalln("bad result:", tc, p, r)
		}
	}
}
