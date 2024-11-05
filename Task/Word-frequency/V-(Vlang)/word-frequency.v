import os
import maps

fn main() {
	mis := os.read_file("./135-0.txt") or {panic("Error reading file")}
	mut grp, mut rgrp := map[string]int, map[int]string
	mut keys := []int{}
	mut result := ""
	mut count := 1
	for line in mis.split_into_lines() {
		for word in line.split("\x20") {
			if !word.is_blank() {grp[word.to_lower()]++}
		}
	}
	rgrp = maps.invert(grp)
	keys = rgrp.keys()
	keys.sort(a > b)
	for key in keys {
		result += "${count++:2}	" + "${rgrp[key]}	" + "${key}" + "\n"
		if count > 10 {break}
	}
	println("Rank	Word	Frequency")
	println("====	====	=========")
	println(result)
}
