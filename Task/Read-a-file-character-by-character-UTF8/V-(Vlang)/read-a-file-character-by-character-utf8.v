import os

fn main() {
	file := './file.txt'
	mut content_arr := []u8{}
		
	if os.is_file(file) == true {
		content_arr << os.read_bytes(file) or {
			println('Error: can not read')
			exit(1)
		}
	}
	else {
		println('Error: can not find file')
		exit(1)
	}

	println(content_arr.bytestr())
}
