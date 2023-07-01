fn main() {
	var := 42
	address_of_var := &var // pointer to variable
	println(&address_of_var) // reference
	println(*address_of_var) // dereference a reference // 42
}
