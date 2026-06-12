import os

const vowels := ["a", "e", "i", "o", "u"]

fn main() {
	mut result := ""
	mut count := 0
	unixdict := os.read_file("./unixdict.txt") or {panic("file not found")}
	for word in unixdict.split_into_lines()	{
		if vowels.all(word.count(it) == 1) && word.len >= 11 {
			count++
			result += "${count:2}: " + "${word}" + "\n"
		}
	}
	println(result)
}	
