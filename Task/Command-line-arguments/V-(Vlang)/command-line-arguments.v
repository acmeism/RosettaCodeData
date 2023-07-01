import os

fn main() {
	for i, x in os.args[1..] {
		println("the argument #$i is $x")
	}
}
