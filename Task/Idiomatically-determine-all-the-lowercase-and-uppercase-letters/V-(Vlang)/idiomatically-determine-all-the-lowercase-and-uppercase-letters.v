fn main() {
	println(show_ascii(97, 123))
	println(show_ascii(65, 91))
}

fn show_ascii(start int, end int) []string {
	mut ascii_arr := []string{}
	for elem in start .. end {
		ascii_arr << u8(elem).ascii_str()
	}
	return ascii_arr
}
