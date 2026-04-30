import strconv

const weights = [1, 3, 1, 7, 3, 9, 1]

fn main() {
    sedol6s := [
        "710889", "B0YBKJ", "406566", "B0YBLH", "228276", "B0YBKL",
        "557910", "B0YBKR", "585284", "B0YBKT", "B00030", "1234567890",
        "B000301", "A00000", "12🦊", "β0003", "A00030"]
    for sedol6 in sedol6s { println("${sedol6} -> ${sedol7(sedol6) or {continue}}") }
}

fn sedol7(sedol6 string) !string {
	mut sum, mut check := 0, 0
	if sedol6.len != 6 { return "'Incorrect length!'" }
    for i, c in sedol6 {
		if !c.is_alnum() || c.ascii_str().is_lower()
		|| c.ascii_str() in ["A", "E", "I", "O", "U"]  { return "'Illegal character!'" }
		digit := strconv.common_parse_int(c.ascii_str(), 36, 0, true, true) or
        { return "'Invalid conversion!'" }
        sum += int(digit) * weights[i]
    }
    check = (10 - (sum % 10)) % 10
    return "${sedol6}" + "${check.str()}"
}
