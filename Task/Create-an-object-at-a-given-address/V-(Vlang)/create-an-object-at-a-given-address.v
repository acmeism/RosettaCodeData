fn main() {
	// create an integer object

	mut target := 42
	mut target_ref := &target
	
	println("Here is an integer: ${target}")

	// print the machine address of the object

	println("And its reference is: ${target_ref}")

	// take the address of the object and create another integer object at this address
	
	unsafe{(*target_ref) = 69}

	println("Newly assigned value is: ${*target_ref}")

	// print the value of this object to verify that it is same as one of the origin

	println("Compared with referent: ${target}")
}
