import os
	
fn main() {
	mut ay_view_content := []string{}
	file := "./input.txt"
	// check if file exists
	if os.is_file(file) == false {
		print("Error: '${file}' not found")
		exit(-1)
	}
	ay_view_content << os.read_lines(file) or {print(err) exit(-2)}
	for line in ay_view_content {
		if line !="" {println(line)}
		if line =="" {println("Found blank line!")}
	}
}
