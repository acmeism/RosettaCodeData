import os

fn main() {
    mut result :=""
	unixdict := os.read_file("./unixdict.txt") or {println("Error: file not found") exit(1)}
	for word in unixdict.split_into_lines() {
		if word.len > 5 && word.substr(0, 3) == word.substr(word.len - 3, word.len) {
			result += word + "\n"
		}
	}
	println(result)
}
