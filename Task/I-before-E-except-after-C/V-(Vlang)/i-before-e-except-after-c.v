import os
import strconv

fn main() {
	mut cei, mut cie, mut ie, mut ei := f32(0), f32(0), f32(0), f32(0)
    unixdict := os.read_file('./unixdict.txt') or {println('Error: file not found') exit(1)}
	words := unixdict.split_into_lines()
	println("The number of words in unixdict: ${words.len}")
	for word in words {
		cei += word.count('cei')
		cie += word.count('cie')
		ei += word.count('ei')
		ie += word.count('ie')
	}
	print("Rule: 'e' before 'i' when preceded by 'c' at the ratio of ")
	print("${strconv.f64_to_str_lnd1((cei / cie), 2)} is ")
	if cei > cie {println("plausible.")} else {println("implausible.")}
	println("$cei cases for and $cie cases against.")

	print("Rule: 'i' before 'e' except after 'c' at the ratio of ")
	print("${strconv.f64_to_str_lnd1(((ie - cie) / (ei - cei)), 2)} is ")
	if ie > ei {println("plausible.")} else {println("implausible.")}
	println("${(ie - cie)} cases for and ${(ei - cei)} cases against.")

	print("Overall the rules are ")
	if cei > cie && ie > ei {println("plausible.")} else {println("implausible.")}
}
