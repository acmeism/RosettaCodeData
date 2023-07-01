import os

fn main() {
	os.rm("./input.txt") or {println(err) exit(-1)}
	os.rmdir("./docs") or {println(err) exit(-2)} // os.rmdir_all, recursively removes specified directory
	// check if file exists
	if os.is_file("./input.txt") == true {println("Found file!")}
	else {println("File was not found!")}
	// check if directory exists
	if os.is_dir("./docs") == true {println("Found directory!")}
	else {println("Directory was not found!")}
}
