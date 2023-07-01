fn main() {
	println(splitter('gHHH5YY++///\\')) \\ The "\" character needs to be escaped.
}

fn splitter(text string) string {
	mut check := text.substr(0, 1)
	mut new_text, mut temp := '', ''
	for index, _ in text {
		temp = text.substr(index, index + 1)
		if temp != check {
			new_text = new_text + ', '
			check = temp
		}
		new_text = new_text + temp
	}
	return new_text
}
