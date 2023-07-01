import strconv

fn is_numeric(s string) bool {
	strconv.atof64(s) or {
		return false
	}
	return true
}

fn main() {
    println("Are these strings numeric?")
    strings := ["1", "3.14", "-100", "1e2", "NaN", "rose", "0xff", "0b110"]
    for s in strings {
        println("  ${s:4} -> ${is_numeric(s)}")
    }
}
