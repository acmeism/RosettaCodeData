import os

fn main() {
	mut result := ""
	mut count := 1
	unixdict := os.read_file("./unixdict.txt") or {panic("file not found")}
	for word in unixdict.split_into_lines() {
		if word.contains_any_substr(["a", "i", "o", "u"]) || word.count("e") <= 3 {continue}
		result += "${count++:2d}: " + "${word}" + "\n"
	}
	println(result)
}
