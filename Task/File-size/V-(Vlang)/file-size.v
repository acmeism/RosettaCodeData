import os

fn main() {
	paths := ["input.txt", "./input.txt", "non_existing_file.txt"]
	for path in paths {
		if os.is_file(path) == true {println("The size of '${path}' is ${os.file_size(path)} bytes")}
		else {println("Not found: ${path}")}
	}
}
