fn main() {
	mut is_open := [false].repeat(100)

	// do 100 passes
	for pass := 0; pass < 100; pass++ {
		for door := pass; door < 100; door += pass + 1 {
			// there is no NOT operator in V.
			is_open[door] = match is_open[door] {
				true  { false }
				false { true }
				else { false }
			}
		}
	}

	// output results
	for door := 0; door < 100; door ++ {
		print( "door #" )
		print( door + 1 )
		print(
			if is_open[door] {
				" is open."
			}
			else {
				" is closed."
			}
		)
		println("")
	}
}
