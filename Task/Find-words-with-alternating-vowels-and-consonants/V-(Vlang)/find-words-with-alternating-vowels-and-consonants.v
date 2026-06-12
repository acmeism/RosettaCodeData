import os

const vowels = "aeiou"

fn main() {
	mut con_even, mut con_odd, mut vow_even, mut vow_odd, mut result := "", "", "", "", ""
	mut count := 1
	unixdict := os.read_file("./unixdict.txt") or {panic("Error reading file")}
	for word in unixdict.split_into_lines() {
		if word.len > 9 {
			for idx, chr in word {
				if idx % 2 == 0 && vowels.contains_u8(word[0]) {vow_even += chr.ascii_str()}
				if idx % 2 == 1 && vowels.contains_u8(word[0]) {con_odd += chr.ascii_str()}	
				if idx % 2 == 0 && !vowels.contains_u8(word[0]) {con_even += chr.ascii_str()}
				if idx % 2 == 1 && !vowels.contains_u8(word[0]) {vow_odd += chr.ascii_str()}
			}
			if vow_odd.contains_only(vowels)
			&& !con_even.contains_any(vowels)
			&& (!con_even.is_blank() || !vow_odd.is_blank()) {
				result += "${count++:2}: " + "${word}" + "\n"
			}
			if vow_even.contains_only(vowels)
			&& !con_odd.contains_any(vowels)
			&& (!vow_even.is_blank() || !con_odd.is_blank()) {
				result += "${count++:2}: " + "${word}" + "\n"
			}			
		}
		con_even, con_odd, vow_even, vow_odd = "", "", "", ""
	}
	println(result)
}
