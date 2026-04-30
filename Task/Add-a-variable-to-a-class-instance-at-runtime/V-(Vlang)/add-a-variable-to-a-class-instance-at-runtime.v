import os
import strconv

struct Obj {
    mut:
    var map[string]string
}

fn main() {
    mut obj := Obj{}
	mut nir, mut ir := 0, 1
	mut name, mut val := "", ""
    for nir < 1 || nir > 3 {
		nir = strconv.atoi(os.input("How many variables to create (max 3): ")) or
		{println("Invalid input!") continue}
    }
	for ir <= nir {
		println("Enter the variable names and their values, below:")
		println("Variable ${ir}")
        name = os.input_opt("    Name: ") or {println("Invalid input!") exit(1)}
		for {
			val = os.input_opt("    Value: ") or {println("Invalid input!") exit(2)}
			break
		}
		obj.var[name] = val
        ir++
	}
	println("\n" + "Enter q to quit")
	for {
 		name = os.input_opt("Which variable (field) name to inspect : ") or {continue}
        if name.to_lower() == "q" {break}
        if name !in obj.var {println("There's no variable (field) of that name, try again")}
        else {println("It's value is: '${obj.var[name]}'")}
    }		
}
