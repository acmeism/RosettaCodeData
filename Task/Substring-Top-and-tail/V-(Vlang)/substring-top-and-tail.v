fn main() {
	words := "(The V Programming Language)"
	println("${words.substr(1, words.len)}") // remove first character
	println("${words.substr(0, words.len - 1)}") // remove last character
	println("${words.runes()[1..words.len - 1].string()}") // remove first and last characters
}
