fn main() {
    println('a'[0]) // prints "97"
	println('π'[0]) // prints "207"

	s := 'aπ'
	println('string cast to bytes: ${s.bytes()}')
	for c in s {
		print('0x${c:x} ')
	}
}
