fn lex_order(nir int) []int {
	mut first, mut last := 1, nir
	mut numbers := []string{}
	if nir < 1 {
		first = nir
		last = 1
	}
	for ial in first .. last + 1 { numbers << ial.str() }
	return numbers.sorted().map(it.int())
}

fn main() {
	println("In lexicographical order:\n")
	for nal in [0, 5, 13, 21, -22] { println("${nal:3d}: ${lex_order(nal)}") }
}
