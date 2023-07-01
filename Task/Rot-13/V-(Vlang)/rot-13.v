fn main() {
	println(rot13('nowhere ABJURER'))
	println(rot13('abjurer NOWHERE'))
}

fn rot13char(chr u8) u8 {
	if (chr >= u8(97) && chr <= u8(109)) || (chr >= u8(65) && chr <= u8(77)) {
		return chr + 13
	}
	if (chr >= u8(110) && chr <= u8(122)) || (chr >= u8(78) && chr <= u8(90)) {
		return chr - 13
	}
	return chr
}

fn rot13(str string) string {
	mut chr_arr := []u8{}
	for elem in str.split('') {
		chr_arr << rot13char(elem.str)
	}
	return chr_arr.bytestr()
}
