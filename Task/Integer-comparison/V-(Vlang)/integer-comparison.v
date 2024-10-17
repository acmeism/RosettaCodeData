import os

fn main(){
	mut enter := ""
	mut a, mut b := 0, 0
	enter = os.input("Enter number for a: ")
	if enter.is_int() {a = enter.int()} else {println("Invalid input!") exit(1)}
	enter = os.input("Enter number for b: ")
	if enter.is_int() {b = enter.int()} else {println("Invalid input!") exit(1)}
	match true {
		a < b  {println("${a} less than ${b}")}
		a == b {println("${a} equal to ${b}")}
		a > b {println("${a} greater than ${b}")}
		else{}
	}
	exit(0)	
}
