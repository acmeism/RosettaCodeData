fn main() {
    words := os.read_file("./unixdict.txt") or {println(err) exit(-1)}.split_into_lines()
	mut longest_len := 0
	mut longest := []string{}
	mut u_word := []u8{}
	for word in words {
		for chars in word {u_word << chars}
		u_word.sort()
		if word.len > longest_len {
			if word == u_word.bytestr() {
				longest_len = word.len
				longest.clear()
				longest << word
			}
		}
		else if word.len == longest_len {
			if word == u_word.bytestr() {longest << word}
		}
		u_word.clear()
	}
	println("The ${longest.len} ordered words with the longest length (${longest_len}) are:")
	print(longest.join("\n"))
}
