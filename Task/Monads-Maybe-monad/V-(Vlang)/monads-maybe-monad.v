type Maybe = f64 | string

fn (m Maybe) div(x f64, y f64) Maybe {
	mut result := m{}
	result = x / y
	if result.str().contains_any_substr(["inf","nan"]) {result = "none"}
	return result
}

fn main() {
	mb := Maybe{}
	for a in [15, 0, 5] {
		for b in [5, 0, 0] {
			println(mb.div(a, b))
		}
	}
}
