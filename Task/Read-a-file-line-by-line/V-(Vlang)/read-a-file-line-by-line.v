import os

fn main() {
	file := './file.txt'
	mut content_arr := []string{}
		
	if os.is_file(file) == true {
		content_arr << os.read_lines(file) or {
			println('Error: can not read')
			exit(1)
		}
	}
	else {
		println('Error: can not find file')
		exit(1)
	}

	for content in content_arr {
		if content !='' {
			println(content)
		}
	}
}
