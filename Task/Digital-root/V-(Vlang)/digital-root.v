import strconv

fn sum(ii u64, base int) int {
	mut s := 0
	mut i := ii
	b64 := u64(base)
	for ; i > 0; i /= b64 {
		s += int(i % b64)
	}
	return s
}

fn digital_root(n u64, base int) (int, int) {
	mut persistence := 0
	mut root := int(n)
	for x := n; x >= u64(base); x = u64(root) {
		root = sum(x, base)
		persistence++
	}
	return persistence, root
}

// Normally the below would be moved to a *_test.go file and
// use the testing package to be runnable as a regular test.

struct Test{
	n string
	base int
	persistence int
	root int
}

const test_cases = [
	Test{"627615", 10, 2, 9},
	Test{"39390", 10, 2, 6},
	Test{"588225", 10, 2, 3},
	Test{"393900588225", 10, 2, 9},
	Test{"1", 10, 0, 1},
	Test{"11", 10, 1, 2},
	Test{"e", 16, 0, 0xe},
	Test{"87", 16, 1, 0xf},
	// From Applesoft BASIC example:
	Test{"DigitalRoot", 30, 2, 26}, // 26 is Q base 30
	// From C++ example:
	Test{"448944221089", 10, 3, 1},
	Test{"7e0", 16, 2, 0x6},
	Test{"14e344", 16, 2, 0xf},
	Test{"d60141", 16, 2, 0xa},
	Test{"12343210", 16, 2, 0x1},
	// From the D example:
	Test{"1101122201121110011000000", 3, 3, 1},
]

fn main() {
	for tc in test_cases {
		n, err := strconv.common_parse_uint2(tc.n, tc.base, 64)
		if err != 0 {
			panic('ERROR')
		}
		p, r := digital_root(n, tc.base)
		println("${tc.n:12} (base ${tc.base:2}) has additive persistence $p and digital root ${strconv.format_int(i64(r), tc.base)}",)
		if p != tc.persistence || r != tc.root {
			panic("bad result: $tc $p $r")
		}
	}
}
