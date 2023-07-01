fn main() {
	word_set := [["the", "that", "a"],
				["frog", "elephant", "thing"],
				["walked", "treaded", "grows"],
				["slowly", "quickly"]]
	text := amb(word_set)
	if text != "" {println("Correct answer is: \n ${text} \n")}
	else {println("Failed to find a correct answer.")}
}

fn word_check(str_1 string, str_2 string) bool {
	if str_1.substr_ni(str_1.len - 1, str_1.len) == str_2.substr_ni(0, 1) {return true}
	return false
}

fn amb(arrays[][]string) string {
	for words_0 in arrays[0] {
		for words_1 in arrays[1] {
			for words_2 in arrays[2] {
				for words_3 in arrays[3] {
					if word_check(words_0, words_1) && word_check(words_1, words_2) && word_check(words_2, words_3) {
						return "${words_0} ${words_1} ${words_2} ${words_3}"
					}
				}
			}
		}
	}
	return ""
}
