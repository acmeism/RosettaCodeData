fn eval(code string) {
	mut accumulator := 0
	for cal in code.trim_space().to_lower() {
		match cal {
			`h` { println("Hello, world!") }
			`q` { println(code) }
			`9` {
				bottles := fn (ir int) string {
					match ir {
						0 { return "No bottles" }
						1 { return "One bottle" }
						else { return "$ir bottles" }
					}
				}
				for ir := 99; ir >= 1; ir-- {
					println("${bottles(ir)} of beer on the wall,")
					println("${bottles(ir)} of beer,")
					println("take one down and pass it around,")
					println("${bottles(ir - 1)} of beer on the wall!")
					println("")
				}
			}
			`+` { accumulator++ }
			else { println("syntax error") }
		}
	}
}

fn main() {
	eval("hq9+")
}
