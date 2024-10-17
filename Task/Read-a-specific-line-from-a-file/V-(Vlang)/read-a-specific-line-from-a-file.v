import os

fn main() {
	file := "./input.txt"
	mut content_arr := []string{}
	mut line_7 :=""
		
	if os.is_file(file) {content_arr << os.read_lines(file) or {println("Error: not read") exit(1)}}
	else {println("Error: no file") exit(1)}
	if content_arr.len < 7 {println("Only ${content_arr.len} lines in the file") exit(1)}
	else {line_7 = content_arr[6].trim_space()}
	if line_7.is_blank() {println("The seventh line is empty") exit(1)}
	else {println("The seventh line is : ${line_7}")}
}
