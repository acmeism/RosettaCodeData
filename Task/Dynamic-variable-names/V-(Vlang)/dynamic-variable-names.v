import os
import strconv

fn main() {
	mut n, mut value, mut i := 0, 0, 1
	mut name :=""
	mut vars := map[string]int{}
    for n < 1 || n > 5 {
		n = strconv.atoi(os.input("Integer variables (max 5): ")) or {println("Invalid input!") continue}
    }
	for i <= n {
		println("OK, enter the variable names and their values, below:")
		println("Variable ${i}")
        name = os.input_opt("    Name: ") or {println("Invalid input!") exit(1)}
		for {
			value = strconv.atoi(os.input("    Value: ")) or {println("Must by a number!") continue}
			break
		}
		vars[name] += value
        i++
	}
	println("\n" + "Enter q to quit")
	for {
 		name = os.input_opt("Which variable do you want to inspect: ") or {println("Invalid input!") exit(1)}
        if name.to_lower() == "q" {break}
        if name !in vars {println("Sorry there's no variable of that name, try again!")}
        else {println("Its value is ${vars[name]}")}
    }
}
