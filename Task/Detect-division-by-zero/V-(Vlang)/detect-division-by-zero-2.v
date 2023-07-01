fn main() {
	divide(0, 0)	
	divide(15, 0)
	divide(15, 3)
}

pub fn divide(x f64, y f64) {
	succeed := divide_error_handler(x, y) or {
		println(err)
		return
	}
	println(succeed)
}

fn divide_error_handler(x f64, y f64) !f64 {
	result := x/y
	if result.str().contains_any_substr(["inf","nan"]) == true {
		return error("Can\'t divide by zero!")
	}
	return result
}
