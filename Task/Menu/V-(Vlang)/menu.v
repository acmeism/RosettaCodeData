import os

const list = ["fee fie", "huff and puff", "mirror mirror", "tick tock"]

fn main() {
	pick := menu(list, "Please make a selection: ")
	if pick == -1 {
		println("Error occured!\nPossibly list or prompt problem.")
		exit(-1)
	}
    else {println("You picked: ${pick}. ${list[pick - 1]}")}
}

fn menu(list []string, prompt string) int {
	mut index := -1
    if list.len == 0 || prompt =='' {return -1}
	println('Choices:')
	for key, value in list {
		println("${key + 1}: ${value}")
    }
	for index !in [1, 2, 3, 4] {index = os.input('${prompt}').int()}
    return index
}
