import  os

fn main() {
	result := os.execute('cmd /c dir')
	if result.output !='' {println(result.output)}
	else {println('Error: not working') exit(1)}
}
