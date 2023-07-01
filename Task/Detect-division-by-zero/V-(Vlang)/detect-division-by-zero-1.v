fn main() {
	divide(0, 0)	
	divide(15, 0)
	divide(15, 3)
}

fn divide(x f64, y f64) {
	result := x/y
	if result.str().contains_any_substr(["inf","nan"]) == true {
		println("Can\'t divide by zero!")
		return
	}
	println(result)
}
