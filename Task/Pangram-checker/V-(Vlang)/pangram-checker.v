const alpha = "abcdefghjiklmnopqrstuvwxyz"

fn main() {
	mut s := "The quick brown fox jumps over the lazy dog."
	println(is_pangram(s))
	s = "My dog has fleas."
	println(is_pangram(s))
}

fn is_pangram(txt string) bool {
	mut str := txt
    str  = txt.to_lower()
	for elem in alpha {
		if elem.ascii_str() !in str.split('') {return false}
	}
	return true
}
