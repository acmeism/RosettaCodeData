fn main() {
	// Create a 128 character Thue-Morse word
	mut thue_morse := "0"
	mut thue_morse_copy := ""
	
	for i := 0; i < 7; i++ {
		thue_morse_copy = thue_morse
		thue_morse = thue_morse.replace("0", "a")
		thue_morse = thue_morse.replace("1", "0")
		thue_morse = thue_morse.replace("a", "1")
		thue_morse = thue_morse_copy + thue_morse
	}

	println("The Thue-Morse word to be factorised:")
	println(thue_morse)

	println("")
	println("The factors are:")
	for factor in duval(thue_morse) {
		println(factor)
	}
}

// Duval's algorithm
fn duval(text string) []string {
	mut factorisation := []string{}
	mut i, mut j, mut k := 0, 0, 0

	for i < text.len {
		j = i + 1
		k = i

		for j < text.len && text[k] <= text[j] {
			if text[k] < text[j] {k = i}
			else {k++}
			j++
		}

		for i <= k {
			factorisation << text[i..i + (j - k)]
			i += j - k
		}
	}
	return factorisation
}
