import os

fn main() {
	mut num := 0
	mut word_arr := []u8{}
	mut odd_list :=""
    word_list := os.read_file("./unixdict.txt") or {println(err) exit(-1)}.split_into_lines()
	for word in word_list {
		if word.len > 8 {
			for idx, chars in word {if idx % 2 == 0 {word_arr << chars}}
			if word_list.contains(word_arr.bytestr()) && !odd_list.contains(word) && word_arr.len > 4 {
				num++
				odd_list += "${num}. ${word} >> ${word_arr.bytestr()} \n"
			}
		}
		word_arr.clear()
	}
	println(odd_list)
}
