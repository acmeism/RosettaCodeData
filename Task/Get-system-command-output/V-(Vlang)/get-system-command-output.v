import os

fn main() {
	output := os.execute_opt("ls -l") or {panic(err)}
	println(output)
}
